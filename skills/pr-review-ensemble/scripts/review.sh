#!/usr/bin/env bash
# Run one review round of the current change with Claude and Codex in parallel, and merge the findings.
#
# Usage: review.sh [--base <ref>] [--rounds <n>] [--request <text>]
#                  [--claude-model <model>] [--codex-model <model>] [--reset]
#
# The change is `git diff <merge-base>` of the current branch: committed, staged, unstaged, and untracked files.
# The state and every raw output live in $(git rev-parse --absolute-git-dir)/pr-review-ensemble/<branch>/.
# Prints the merged report JSON on stdout.
#
# Exit codes: 0 a report was printed, 1 usage or environment error.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)

usage() {
  echo "usage: review.sh [--base <ref>] [--rounds <n>] [--request <text>] [--claude-model <model>] [--codex-model <model>] [--reset]" >&2
  exit 1
}
fail() { echo "review.sh: $*" >&2; exit 1; }

base= rounds= request= claude_model=opus codex_model= reset=0
while [ $# -gt 0 ]; do
  case $1 in
    --base | --rounds | --request | --claude-model | --codex-model) [ $# -ge 2 ] || usage ;;
  esac
  case $1 in
    --base) base=$2; shift 2 ;;
    --rounds) [[ $2 =~ ^[1-9][0-9]*$ ]] || usage; rounds=$2; shift 2 ;;
    --request) request=$2; shift 2 ;;
    --claude-model) claude_model=$2; shift 2 ;;
    --codex-model) codex_model=$2; shift 2 ;;
    --reset) reset=1; shift ;;
    *) usage ;;
  esac
done

for cmd in git jq claude codex; do
  command -v "$cmd" >/dev/null || fail "$cmd is not on PATH"
done

top=$(git rev-parse --show-toplevel 2>/dev/null) || fail "not inside a git repository"
cd "$top"
branch=$(git symbolic-ref --short -q HEAD || git rev-parse --short HEAD)
state_dir="$(git rev-parse --absolute-git-dir)/pr-review-ensemble/${branch//\//__}"
state="$state_dir/state.json"

[ "$reset" = 1 ] && rm -rf "$state_dir"
mkdir -p "$state_dir"
[ -f "$state" ] || echo '{"round":0,"rounds":null,"extra":0,"critical_seen":false,"base":null,"tree":null,"open":[]}' > "$state"

# The base is fixed at round 1, so a later round cannot widen or move the change.
[ -n "$base" ] || base=$(jq -r '.base // empty' "$state")
[ -n "$base" ] || base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD || echo main)
merge_base=$(git merge-base "$base" HEAD 2>/dev/null) || fail "no merge-base between $base and HEAD"

# Snapshot the working tree, with untracked files, as a tree object. The real index stays untouched.
idx=$(mktemp)
trap 'rm -f "$idx"' EXIT
cp "$(git rev-parse --git-path index)" "$idx" 2>/dev/null || rm -f "$idx"
GIT_INDEX_FILE=$idx git add -A
tree=$(GIT_INDEX_FILE=$idx git write-tree)

round=$(jq '.round' "$state")
next=$((round + 1))
if [ -n "$rounds" ]; then
  jq --argjson n "$rounds" '.rounds = $n' "$state" > "$state.tmp" && mv "$state.tmp" "$state"
fi
limit=$(jq 'if .rounds then .rounds elif .critical_seen then 5 else 3 end' "$state")
extra=$(jq '.extra' "$state")
# A user request allows 1 round past the budget, so the reviewers can answer it.
if [ "$next" -gt $((limit + extra)) ] && [ -n "$request" ]; then
  extra=$((extra + 1))
  jq --argjson e "$extra" '.extra = $e' "$state" > "$state.tmp" && mv "$state.tmp" "$state"
fi

short_report() {
  jq -n --arg status "$1" --argjson round "$round" --argjson limit $((limit + extra)) \
    --arg dir "$state_dir" --slurpfile s "$state" \
    '{status: $status, round: $round, limit: $limit, state_dir: $dir, findings: [],
      prior: [$s[0].open[] | . + {verdicts: [], state: "open", disputed: false}],
      open: [$s[0].open[].id], open_critical: [$s[0].open[] | select(.critical) | .id]}'
}

if [ "$next" -gt $((limit + extra)) ]; then
  short_report BUDGET_EXHAUSTED
  exit 0
fi

prev_tree=$(jq -r '.tree // empty' "$state")
if [ -n "$prev_tree" ] && git cat-file -e "$prev_tree" 2>/dev/null; then
  scope_from=$prev_tree
else
  scope_from=$merge_base
fi

diff_opts=(--no-prefix --no-color --no-ext-diff)
if [ -z "$(git diff "${diff_opts[@]}" --stat "$merge_base" "$tree")" ] ||
  [ -z "$(git diff "${diff_opts[@]}" --stat "$scope_from" "$tree")" ]; then
  short_report NO_CHANGES
  exit 0
fi

rdir="$state_dir/round-$next"
rm -rf "$rdir"
mkdir -p "$rdir"
git diff "${diff_opts[@]}" "$merge_base" "$tree" > "$rdir/full.patch"
git diff "${diff_opts[@]}" "$scope_from" "$tree" > "$rdir/scope.patch"

# The scope is every new-side line range in the round's diff. A pure deletion keeps the lines next to it.
git diff "${diff_opts[@]}" -U0 "$scope_from" "$tree" | awk '
  /^\+\+\+ / { f = substr($0, 5); if (f == "/dev/null") f = ""; next }
  /^@@ / && f != "" {
    split($3, a, ","); s = substr(a[1], 2) + 0; n = (a[2] == "" ? 1 : a[2] + 0)
    e = (n == 0 ? s + 1 : s + n - 1); if (s < 1) s = 1
    print f "\t" s "\t" e
  }' | jq -R -s 'split("\n") | map(select(length > 0) | split("\t")
      | {file: .[0], start: (.[1] | tonumber), end: (.[2] | tonumber)})' > "$rdir/scope.json"

if [ "$next" -ge 3 ]; then
  floor="In this round, report a finding outside the critical categories only if it is a BLOCKER."
else
  floor="In this round, report BLOCKER and MAJOR findings."
fi
{
  cat "$here/reviewer-prompt.md"
  printf '\n<round>\nRound %s of %s. %s\n</round>\n' "$next" $((limit + extra)) "$floor"
  printf '\n<request>\n%s\n</request>\n' "${request:-none}"
  printf '\n<open-findings>\n'
  jq '[.open[] | {id, severity, category, file, line, claim, repro_steps}]' "$state"
  printf '</open-findings>\n'
  if [ "$scope_from" != "$merge_base" ]; then
    printf '\nThe `<diff>` block holds only the changes since the last round. The `<full-diff>` block holds the whole change, for context.\n'
    printf '\n<full-diff>\n'
    cat "$rdir/full.patch"
    printf '</full-diff>\n'
  fi
  printf '\n<diff>\n'
  cat "$rdir/scope.patch"
  printf '</diff>\n'
} > "$rdir/prompt.md"

schema="$here/finding.schema.json"

if [ -z "$codex_model" ]; then
  codex_model=$(codex debug models 2>/dev/null | jq -r '.models[] | select(.visibility == "list") | .slug' |
    grep -E '^gpt-[0-9]+(\.[0-9]+)*-sol$' | sort -t- -k2,2V | tail -1) || true
fi

# --restricted ignores user settings, --tools removes the Agent tool, and --strict-mcp-config removes MCP servers.
# So the Claude reviewer can read files but cannot edit, run commands, or start a subagent.
claude -p --restricted --model "$claude_model" --effort medium --tools Read Grep Glob --strict-mcp-config \
  --output-format json --json-schema "$(cat "$schema")" \
  < "$rdir/prompt.md" > "$rdir/claude.raw.json" 2> "$rdir/claude.stderr" &
claude_pid=$!

# The read-only sandbox blocks writes and the network, and multi_agent=false removes Codex subagents.
if [ -n "$codex_model" ]; then
  codex exec -m "$codex_model" -c model_reasoning_effort=medium --disable multi_agent -s read-only --ephemeral \
    -C "$top" --output-schema "$schema" -o "$rdir/codex.json" - \
    < "$rdir/prompt.md" > "$rdir/codex.stderr" 2>&1 &
  codex_pid=$!
fi

if wait "$claude_pid"; then claude_exit=0; else claude_exit=$?; fi
claude_error=
if [ "$claude_exit" != 0 ]; then
  claude_error="claude exited with code $claude_exit"
elif ! jq -e '.is_error == false and (.structured_output | type == "object")' "$rdir/claude.raw.json" >/dev/null 2>&1; then
  claude_error="claude returned no structured output"
elif ! jq -e '(.subagent_stats.spawned // 0) == 0' "$rdir/claude.raw.json" >/dev/null; then
  claude_error="claude started a subagent"
else
  jq '.structured_output' "$rdir/claude.raw.json" > "$rdir/claude.json"
fi
# The alias, such as opus, resolves inside claude. Record the model that wrote the most output.
if [ -z "$claude_error" ]; then
  claude_model=$(jq -r '.modelUsage | to_entries | max_by(.value.outputTokens) | .key' "$rdir/claude.raw.json")
fi

codex_error=
if [ -z "$codex_model" ]; then
  codex_error="no gpt-*-sol model in the codex catalog"
else
  if wait "$codex_pid"; then codex_exit=0; else codex_exit=$?; fi
  if [ "$codex_exit" != 0 ]; then
    codex_error="codex exited with code $codex_exit"
  elif ! jq -e '(.findings | type == "array") and (.verdicts | type == "array")' "$rdir/codex.json" >/dev/null 2>&1; then
    codex_error="codex returned no structured output"
  fi
fi

reviews=$(jq -n \
  --arg cm "${claude_model:-opus}" --arg ce "$claude_error" \
  --arg xm "$codex_model" --arg xe "$codex_error" \
  --slurpfile c <([ -z "$claude_error" ] && cat "$rdir/claude.json" || echo null) \
  --slurpfile x <([ -z "$codex_error" ] && cat "$rdir/codex.json" || echo null) \
  '[{reviewer: "claude", model: $cm, error: (if $ce == "" then null else $ce end), output: $c[0]},
    {reviewer: "codex", model: $xm, error: (if $xe == "" then null else $xe end), output: $x[0]}]')

# Filter, sort, and number the findings. The script does not merge duplicates, because that takes judgment.
echo "$reviews" | jq --argjson round "$next" --arg request "$request" \
  --slurpfile scope "$rdir/scope.json" --slurpfile s "$state" \
  --arg base "$base" --arg mb "$merge_base" --arg dir "$state_dir" '
  def critical: .category as $c | ["security", "permissions", "auth", "data-loss", "state-concurrency"] | index($c) != null;
  def inscope($f; $l): $f != null and $l != null and any($scope[0][]; .file == $f and .start <= $l and $l <= .end);
  def rank: {"BLOCKER": 0, "MAJOR": 1}[.severity];
  . as $reviews
  | ($request != "") as $has_request
  | [.[] | select(.error == null)] as $ok
  | [$ok[] | .reviewer as $r | .output.findings[]
      | .reviewer = $r
      | .requested = (.requested and $has_request)
      | .critical = critical
      | .repro_steps = [.repro_steps[] | select(test("\\S"))]
      | .drop_reason = (
          if (.severity | IN("MINOR", "NIT")) then "severity below MAJOR"
          elif (.repro_steps | length) == 0 then "no repro_steps"
          elif $round >= 3 and (.critical | not) and .severity == "MAJOR" and (.requested | not)
            then "non-critical MAJOR finding in round 3 or later"
          elif (inscope(.file; .line) or inscope(.cause_file; .cause_line) or .requested) | not
            then "outside the scope of this round"
          else null end)] as $all
  | [$all[] | select(.drop_reason == null) | del(.drop_reason)]
    | sort_by(rank, .file, .line, .reviewer)
    | to_entries | map(.value + {id: "R\($round)-\(.key + 1)"} | {id} + .) as $new
  | [$s[0].open[] | .id as $id
      | .verdicts = [$ok[] | .reviewer as $r | .output.verdicts[] | select(.id == $id) | {reviewer: $r} + del(.id)]
      | .state = (if ($ok | length) > 0 and ([.verdicts[] | select(.verdict == "fixed")] | length) == ($ok | length)
          and ([.verdicts[].reviewer] | unique | length) == ($ok | length) then "fixed" else "open" end)
      | .disputed = ([.verdicts[].verdict] | unique | length) > 1] as $prior
  | ($new + [$prior[] | select(.state == "open")]) as $open
  | {status: (if ($ok | length) == 0 then "REVIEWER_FAILED"
              elif ($open | length) > 0 then "ISSUES"
              elif ($ok | length) < ($reviews | length) then "REVIEWER_FAILED"
              else "PASS" end),
     round: $round, limit: (($s[0].rounds // (if ($s[0].critical_seen or any($open[]; .critical)) then 5 else 3 end)) + $s[0].extra),
     base: $base, merge_base: $mb, state_dir: $dir, request: (if $has_request then $request else null end),
     reviewers: [$reviews[] | {reviewer, model, error}],
     findings: $new, prior: $prior,
     open: [$open[].id], open_critical: [$open[] | select(.critical) | .id],
     dropped: [$all[] | select(.drop_reason != null) | {reviewer, drop_reason, finding: del(.reviewer, .drop_reason)}]}
' > "$rdir/merged.json"

jq '.dropped' "$rdir/merged.json" > "$rdir/dropped.json"
jq 'del(.dropped) + {dropped_count: (.dropped | length)}' "$rdir/merged.json" > "$rdir/report.json"
rm "$rdir/merged.json"

# A round that no reviewer completed does not count against the budget.
if jq -e '[.reviewers[] | select(.error == null)] | length > 0' "$rdir/report.json" >/dev/null; then
  jq --argjson round "$next" --arg base "$base" --arg tree "$tree" --slurpfile r "$rdir/report.json" '
    ($r[0].findings + [$r[0].prior[] | select(.state == "open") | del(.verdicts, .state, .disputed)]) as $open
    | .round = $round | .base = $base | .tree = $tree | .open = $open
    | .critical_seen = (.critical_seen or any($open[]; .critical))' "$state" > "$state.tmp"
  mv "$state.tmp" "$state"
fi

cat "$rdir/report.json"
