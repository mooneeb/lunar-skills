---
name: create-tickets
description: Split a spec into the fewest vertical-slice tickets that each fit one agent session, and publish them as GitHub sub-issues with native blocking links. Use it in place of `to-tickets`, which tends to split work by layer.
argument-hint: "Which spec issue, URL, or file do you want to split?"
disable-model-invocation: true
metadata:
  source: https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets
  owner: Matt Pocock
  repo: https://github.com/mattpocock/skills
---

A **vertical slice** is a ticket that makes one user flow work end to end, through every layer that the flow needs. A slice cuts across the layers, not along one layer. After a slice merges, a person can test its behavior in the product. A ticket that changes one layer, such as "add the table" or "build the API", is a horizontal slice. Nobody can test a horizontal slice until the last ticket merges.

## Start

Open a todolist with one entry per phase. If you skip a step, write `skip: <reason>` in its place.

1. Context
2. Slicing
3. Review
4. Publish

If the user passed arguments, treat them as the spec reference.

## Phases

### Context

1. Read the spec. If the user passed an issue number or a URL, run `gh issue view <number> --comments`. If the user passed a path, read the file. If the user passed nothing, use the spec in the conversation. If no spec exists, tell the user to run `/to-spec`, then stop.
2. If `GLOSSARY.md` or `docs/adr/` exists, read them. Use the glossary terms in each ticket.
3. Explore the code that the spec touches. Find the entry points, the layers, and the modules that each user story reaches. The Slicing phase uses these modules to find collisions.
4. List each behavior that the spec leaves undecided, such as a limit with no value. If the list is not empty, ask the user about each item. If an item is about the look or the feel of the product, suggest `/prototype`. A ticket with a guessed behavior sends an agent to build the wrong thing.
5. Choose the tracker. If `git remote -v` shows a GitHub remote, use GitHub. If not, use local files.
6. If you use GitHub, run `gh auth status`. If it fails, tell the user to run `! gh auth login`, then stop.

**Done when:** you read the spec and the code that it touches, the user answered each undecided behavior, and you chose the tracker.

### Slicing

1. Group the user stories by user flow. A **user flow** is a set of stories that share one entry point, the same main data, and one QA demo. Do not group by module or by the Implementation Decisions section of the spec. Each of those groups is a horizontal slice.
2. Make ticket 01 the walking skeleton. A **walking skeleton** is the thinnest version of the main flow that runs through every layer that the feature needs. Put the setup work, such as the schema and the routes, in the walking skeleton. Do not write a ticket for setup work alone, because it has no QA demo.
3. Put each prefactor in the first slice that needs it. Do not write a separate refactor ticket, because nobody can test it in the product.
4. If the spec has one mechanical change across the whole codebase, such as a rename of a shared column, read `WIDE-REFACTOR.md`.
5. Apply the size rules to each ticket.

   | Size      | Sign                                                                                       | Action                       |
   | --------- | ------------------------------------------------------------------------------------------ | ---------------------------- |
   | Too small | Its QA demo is a step in the demo of another ticket, or it has fewer than 3 acceptance criteria | Merge it into the other ticket |
   | Too big   | It has more than 8 acceptance criteria, 2 or more QA demos, or 2 or more new external services | Split it by flow             |
   | Medium    | 1 QA demo, 3 to 8 acceptance criteria, and 0 or 1 new external service                      | Keep it                      |

6. Count the tickets. If one agent can build the whole spec within the size rules, write 1 ticket. Most specs give 2 to 5 tickets. If you have more than 8, merge flows. If the count and the size rules disagree, the size rules win.
7. Add the blocking links. Ticket A is **blocked by** ticket B if A needs code that B writes. If two tickets with no link between them change the same module, add a link or merge them. Without a link, 2 agents edit the same code at the same time, and the merge fails.
8. Label each ticket. If an agent can do all of it, use `ready-for-agent`. If it needs a person, such as to create an API key or to make a design decision, use `ready-for-human`. A `ready-for-human` ticket with no product behavior does not need the size rules or the test.
9. Write the body of each ticket from `TICKET-FORMAT.md`.
10. Do the test on each ticket. Mark it `VERTICAL` or `REWRITE`. Rewrite or merge each `REWRITE` ticket, then do the test again.

**The test:** After this ticket merges, can a person do its QA demo in the product, with no other unmerged ticket?

**Done when:** every ticket is `VERTICAL`, every ticket is in the Medium row, and every pair of tickets that changes the same module has a link or is one ticket.

### Review

1. Show the user a numbered list of the tickets. For each ticket, show the title, the label, the tickets that block it, and the QA demo in one line.
2. Under the list, show the waves. A **wave** is a set of tickets whose blockers are all in earlier waves. Wave 1 has the tickets with no blocker.
3. Ask the user which tickets to merge, split, or change. Apply each change. Then do the test and the size rules again on each changed ticket.

**Done when:** the user approves the list.

**Stop:** Do not start the Publish phase before the user approves the list, because agents start work on each issue that you post.

### Publish

1. Choose the draft folder. If you use GitHub, run `mktemp -d`. If not, use `.scratch/<feature-slug>/issues/`.
2. Write each approved ticket to the draft folder from `TICKET-FORMAT.md`. Name each file `<NN>-<slug>.md`, and number the files from `01` in wave order.
3. If you use local files, write the spec to `.scratch/<feature-slug>/spec.md` if it is not a file in the repository. Then skip the other steps.
4. Find the parent issue. If the spec is a GitHub issue, use it. If not, post the spec as an issue with only the spec content, and use that issue.
5. Do not edit or close the parent issue, because the spec belongs to the user. The sub-issue list of the parent shows the progress.
6. Run `scripts/publish.sh <draft folder> <parent number>` from the folder of this skill. The script posts each draft, links it to the parent, and adds each blocking link.
7. If the script exits with code 2, it posted nothing. Fix each draft that it names, then run it again.

**Done when:** the script printed a row for every draft, or every draft is in `.scratch/<feature-slug>/issues/`.

**When it does not apply:** the work is a set of open decisions, not a build. Tell the user to run `/wayfinder`.

**Reply:**

- The URL of the parent issue, or the path of the `.scratch/` folder.
- A table of the waves, with the wave, the issue number, the title, and the label of each ticket.
- The `errors` column of each script row that is not `none`, or `none`.
