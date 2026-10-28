#!/usr/bin/env bash
# Copy published skills from lunar-skills-private into this repo.
#
#   ./sync-repos.bash              refresh every skill already in skills/
#   ./sync-repos.bash NAME...      add or refresh only these skills
#
# Copies the committed files at PRIVATE_REF, never the working tree, so
# untracked secrets and uncommitted edits stay private. The private repo
# keeps skills under skills/<author>/<name>; this repo flattens them to
# skills/<name>. Nothing is committed: review `git diff`, then commit.
#
# Env: PRIVATE_REPO (default ~/repos/lunar-skills-private)
#      PRIVATE_REF  (default main)
set -euo pipefail

public=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
private=${PRIVATE_REPO:-$HOME/repos/lunar-skills-private}
ref=${PRIVATE_REF:-main}

git -C "$private" rev-parse --verify --quiet "$ref^{commit}" >/dev/null ||
  { echo "error: $ref is not a commit in $private" >&2; exit 1; }

if (($#)); then
  names=("$@")
else
  names=()
  for dir in "$public"/skills/*/; do
    [[ -d $dir ]] && names+=("$(basename "$dir")")
  done
  ((${#names[@]})) || { echo "error: skills/ is empty; name the skills to add" >&2; exit 1; }
fi

failed=0
for name in "${names[@]}"; do
  # Find skills/<author>/<name> at the ref.
  matches=$(git -C "$private" ls-tree -d --name-only "$ref" skills/ |
    while IFS= read -r author; do
      git -C "$private" ls-tree -d --name-only "$ref" "$author/$name"
    done)
  count=$(grep -c . <<<"$matches" || true)
  if ((count != 1)); then
    echo "skip  $name: found $count matches for skills/*/$name at $ref" >&2
    failed=1
    continue
  fi

  rm -rf "${public:?}/skills/$name"
  mkdir -p "$public/skills/$name"
  git -C "$private" archive "$ref" "$matches" |
    tar -x -C "$public/skills/$name" --strip-components=3
  echo "sync  $name  <- $matches"
done

echo
echo "Private $ref is at $(git -C "$private" rev-parse --short "$ref")."
git -C "$public" status --short -- skills
exit "$failed"
