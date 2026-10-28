---
name: implement-and-review
description: "Implement a piece of work based on a spec or set of tickets on its own branch, then review it with code-review and pr-review-ensemble. Use `implement` to work on the current branch."
disable-model-invocation: true
metadata:
  source: https://github.com/mattpocock/skills/tree/main/skills/engineering/implement
  owner: Matt Pocock
  repo: https://github.com/mattpocock/skills
---

Implement the work described by the user in the spec or tickets.

Before you write code, pick the branch:

1. If the current checkout is a linked worktree on a non-default branch with no commits past its merge-base, use it.
2. Otherwise, create the branch `implement/<ticket-id>-<slug>` from the default branch, in a new worktree at `../<repo>-<slug>`. If the work has no ticket ID, use `implement/<slug>`.
3. Record the merge-base of the branch and the default branch as the base commit.

The default branch is `origin/HEAD`, or `main` if `origin/HEAD` is not set. Run each later command in the worktree.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

When the work is done, commit it to the branch. Then review the work in this order:

1. Call the Skill tool with "code-review". Give it the base commit as the fixed point, and the spec or tickets. Run it once.
2. Fix the findings, then commit the fixes.
3. Call the Skill tool with "pr-review-ensemble". If the first report shows `round` above 1 or the status `BUDGET_EXHAUSTED`, stop. Tell the user that the branch has an earlier review state.
4. Fix each `CONFIRMED` finding that is not a `NIT`. Commit the fixes, then call the Skill tool with "pr-review-ensemble" again.
5. Stop when the status is `PASS`, `NO_CHANGES`, `BUDGET_EXHAUSTED`, or `REVIEWER_FAILED`.

If the fix for a finding adds behavior that the spec or tickets do not ask for, do not make the fix.

Do not push the branch or open a pull request, because the user decides when the work leaves the branch.

**The test:** Did each review call run after a commit, on a branch that this run created or reused?

**When it does not apply:** the user wants the work on the current branch. Tell the user to run `/implement`.

**Reply:**

- The worktree path and the branch.
- The last ensemble status, and `round <round> of <limit>`.
- Each finding that you did not fix, with its reviewer, its severity, and the reason.
- Each item in `open_critical`, or `none`.
