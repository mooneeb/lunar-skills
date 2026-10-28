#!/usr/bin/env bash
# Post ticket drafts as GitHub issues under a parent issue, with native blocking links.
#
# Usage: publish.sh <draft-folder> <parent-number> [<owner/repo>]
#
# Each draft is <NN>-<slug>.md in the shape of TICKET-FORMAT.md. Drafts post in NN order,
# so a draft can only be blocked by a lower NN. Prints one tab-separated row per draft.
#
# Exit codes: 0 posted, 1 usage, 2 a draft is malformed and nothing was posted.
set -euo pipefail

if [ $# -lt 2 ] || ! [[ $2 =~ ^[0-9]+$ ]]; then
  echo "usage: publish.sh <draft-folder> <parent-number> [<owner/repo>]" >&2
  exit 1
fi

dir=$1
parent=$2
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The header is every line before the first "## " heading. The body is the rest.
header() { awk '/^## /{exit} {print}' "$1"; }
body() { awk 'found || /^## /{found=1; print}' "$1"; }
field() { header "$1" | sed -n "s/^$2: //p"; }

# Check every draft before anything is posted, so a bad draft never leaves half the tickets on GitHub.
problems=()
seen=()
shopt -s nullglob
drafts=("$dir"/*.md)
[ ${#drafts[@]} -gt 0 ] || problems+=("$dir has no .md drafts")

for file in ${drafts[@]+"${drafts[@]}"}; do
  name=$(basename "$file")
  if ! [[ $name =~ ^([0-9]{2})-[a-z0-9-]+\.md$ ]]; then
    problems+=("$name: the file name is not <NN>-<slug>.md, with a lowercase slug")
    continue
  fi
  nn=$((10#${BASH_REMATCH[1]}))
  [ -z "${seen[$nn]:-}" ] || problems+=("$name: another draft also has the number ${BASH_REMATCH[1]}")
  seen[$nn]=$name
done

for file in ${drafts[@]+"${drafts[@]}"}; do
  name=$(basename "$file")
  [[ $name =~ ^([0-9]{2})- ]] || continue
  prefix=${BASH_REMATCH[1]}
  nn=$((10#$prefix))

  [[ $(head -1 "$file") =~ ^#\ $prefix:\ .+ ]] || problems+=("$name: the first line is not '# $prefix: <Title>'")

  statuses=$(field "$file" Status)
  case $statuses in
    ready-for-agent | ready-for-human) ;;
    "") problems+=("$name: the header has no 'Status:' line") ;;
    *) problems+=("$name: the Status is '${statuses//$'\n'/, }', not ready-for-agent or ready-for-human") ;;
  esac

  blocked=$(field "$file" "Blocked by")
  if [ -z "$blocked" ]; then
    problems+=("$name: the header has no 'Blocked by:' line")
  elif [ "$blocked" != "none" ]; then
    if ! [[ $blocked =~ ^[0-9]{2}(,\ ?[0-9]{2})*$ ]]; then
      problems+=("$name: 'Blocked by: $blocked' is not 'none' or a list such as '01, 02'")
    else
      for b in ${blocked//,/ }; do
        if [ -z "${seen[$((10#$b))]:-}" ]; then
          problems+=("$name: it is blocked by $b, but no draft has that number")
        elif [ $((10#$b)) -ge "$nn" ]; then
          problems+=("$name: it is blocked by $b, which posts later. Number the drafts in wave order")
        fi
      done
    fi
  fi

  for section in "What to build" "Acceptance criteria" "How to QA"; do
    body "$file" | grep -qx "## $section" || problems+=("$name: the body has no '## $section' section")
  done
done

if [ ${#problems[@]} -gt 0 ]; then
  echo "Nothing was posted. Fix these drafts, then run the script again:" >&2
  printf -- '- %s\n' "${problems[@]}" >&2
  exit 2
fi

repo=${3:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}

for label in ready-for-agent ready-for-human; do
  if ! gh label list --repo "$repo" --search "$label" --json name --jq '.[].name' | grep -qx "$label"; then
    gh label create "$label" --repo "$repo" >/dev/null
  fi
done

# Indexed by draft number. macOS ships bash 3.2, which has no associative arrays.
numbers=()
ids=()

printf 'draft\tissue\ttitle\turl\terrors\n'

for file in "${drafts[@]}"; do
  name=$(basename "$file")
  nn=$((10#${name%%-*}))
  title=$(head -1 "$file" | sed 's/^# [0-9]*: //')
  label=$(field "$file" Status)
  blocked=$(field "$file" "Blocked by")
  errors=""
  body "$file" >"$tmp/body.md"

  url=$(gh issue create --repo "$repo" --title "$title" --body-file "$tmp/body.md" --label "$label")
  number=${url##*/}
  id=$(gh api "repos/$repo/issues/$number" --jq .id)
  numbers[$nn]=$number
  ids[$nn]=$id

  if ! out=$(gh api --method POST "repos/$repo/issues/$parent/sub_issues" -F sub_issue_id="$id" 2>&1 >/dev/null); then
    errors+="sub-issue: ${out//$'\n'/ }. "
  fi

  fallback=()
  if [ "$blocked" != "none" ]; then
    for b in ${blocked//,/ }; do
      b=$((10#$b))
      if ! out=$(gh api --method POST "repos/$repo/issues/$number/dependencies/blocked_by" -F issue_id="${ids[$b]}" 2>&1 >/dev/null); then
        errors+="blocked_by #${numbers[$b]}: ${out//$'\n'/ }. "
        fallback+=("#${numbers[$b]}")
      fi
    done
  fi

  # Without a native link, a Blocked by line in the body is the only record of the block.
  if [ ${#fallback[@]} -gt 0 ]; then
    { printf 'Blocked by: %s\n\n' "$(IFS=,; echo "${fallback[*]}" | sed 's/,/, /g')"; cat "$tmp/body.md"; } >"$tmp/fallback.md"
    gh issue edit "$number" --repo "$repo" --body-file "$tmp/fallback.md" >/dev/null
  fi

  printf '%s\t#%s\t%s\t%s\t%s\n' "$name" "$number" "$title" "$url" "${errors:-none}"
done
