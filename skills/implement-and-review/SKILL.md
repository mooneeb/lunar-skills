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

If a ticket in the `Blocked by:` line of the ticket is not merged into the default branch, stop. Tell the user which blocker is open.

Before you write code, pick the branch:

1. If the current checkout is a linked worktree on a non-default branch with no commits past its merge-base, use it.
2. Otherwise, create the branch `implement/<ticket-id>-<slug>` from the default branch, in a new worktree at `../<repo>-<slug>`. If the work has no ticket ID, use `implement/<slug>`.
3. Record the merge-base of the branch and the default branch as the base commit.

The default branch is `origin/HEAD`, or `main` if `origin/HEAD` is not set. Run each later command in the worktree.

If the ticket has scenarios in `## How to QA`, write one test for each `automated` scenario. Name the test after the scenario. A **seam** is the point where a test drives the code and reads the result, such as the UI, the HTTP API, or one module. Write each scenario test at the seam that the Testing Decisions section of the spec names. If the spec names no seam, use the highest seam that the repository already tests at. Use /tdd, and make each scenario test the first failing test of its cycle.

If the ticket has no scenarios, use /tdd where possible, at pre-agreed seams.

If the `Setup:` line of a scenario names a command that does not exist, build the command in this branch.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

When the work is done, commit it to the branch. Then review the work in this order:

1. Call the Skill tool with "code-review". Give it the base commit as the fixed point, and the spec or tickets. Run it once.
2. Fix the findings, then commit the fixes.
3. Call the Skill tool with "pr-review-ensemble". If the first report shows `round` above 1 or the status `BUDGET_EXHAUSTED`, stop. Tell the user that the branch has an earlier review state.
4. Fix each `CONFIRMED` finding that is not a `NIT`. Commit the fixes, then call the Skill tool with "pr-review-ensemble" again.
5. Stop when the status is `PASS`, `NO_CHANGES`, `BUDGET_EXHAUSTED`, or `REVIEWER_FAILED`.

If the fix for a finding adds behavior that the spec or tickets do not ask for, do not make the fix.

After the review stops, if the ticket has scenarios, run each scenario test once more. Then read `EVIDENCE.md`, and write the results table with one row for each scenario:

<results-template>

| Scenario | Seam | Test | Status |
| -------- | ---- | ---- | ------ |

</results-template>

| Status        | When                                                                           |
| ------------- | ------------------------------------------------------------------------------ |
| `PASS`        | The test passes.                                                               |
| `FAIL`        | The test fails, or the evidence shows a result that differs from the scenario. |
| `BLOCKED`     | No test can run an `automated` scenario here. Write the reason.                |
| `NEEDS_HUMAN` | The scenario is `manual`. Write the device or the tool that it needs.          |

Add each `FAIL` scenario to `open_critical`.

Pick the pull request:

1. If the status is `NO_CHANGES`, or the run stopped for an earlier review state, open no pull request.
2. If the status is `PASS` and `open_critical` is `none`, open a ready pull request. Otherwise, open a draft.
3. Add the label of the status: `review:pass`, `review:budget-exhausted`, or `review:reviewer-failed`. If `open_critical` is not `none`, also add `review:open-critical`.

Call the Skill tool with "create-pr". Give it these inputs:

- The branch, and the default branch as the base.
- `Closes #<ticket>`, or no line if the work has no ticket.
- The head SHA of the branch at the last ensemble call.
- `ready` or `draft`, and the labels.
- For the description: the results table, each finding that you did not fix, and `open_critical`.
- The path of `.evidence/manifest.md`, if it exists.

If the Skill tool does not list `create-pr`, do not push the branch, because `create-pr` owns the push. Show the user the results table, and tell the user to open the pull request.

**The test:** Did each review call run after a commit, on a branch that this run created or reused, and does each `automated` scenario have a row in the results table?

**When it does not apply:**

- The user wants the work on the current branch. Tell the user to run `/implement`.
- The user names more than 1 ticket. Tell the user to run `/implement-and-review` once for each ticket.

**Reply:**

- The worktree path and the branch.
- The last ensemble status, and `round <round> of <limit>`.
- Each finding that you did not fix, with its reviewer, its severity, and the reason.
- Each item in `open_critical`, or `none`.
- The URL of the pull request, or `no PR` and the reason.
- The results table, or `no scenarios`.
