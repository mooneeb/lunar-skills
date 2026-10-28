---
name: write-a-skill
description: Write a new agentic skill, or change an existing skill after an observed failure.
argument-hint: "Which skill do you want to write or change?"
disable-model-invocation: true
---

A **skill** is a folder of instructions that an agent loads on demand. The description in `SKILL.md` sets when the agent loads it. The body sets what the agent does. Write only sentences that change what the agent does, not an explanation of the task.

Read `RULES.md` and `UNSLOP.md` in this skill's folder before you start.

## Pick a branch

| The user wants to        | Read        |
| ------------------------ | ----------- |
| write a new skill        | `NEW.md`    |
| change an existing skill | `CHANGE.md` |

The file in that row is the branch file. Read only that file. If no row fits, ask the user which job they want.

## Start

Open a todolist with one entry per phase. List the phases of the branch file, then Wording, Check, and Delivery. If the user passed arguments, treat them as the requirements. If you skip a step, write `skip: <reason>` in its place.

## Shared phases

Run these phases after the phases of the branch file. Apply each rule only to the sentences that you wrote or changed.

### Wording

1. Read `UNSLOP.md` in this skill's folder.
2. Apply each rule to each prose file in the target folder. If `UNSLOP.md` and `RULES.md` conflict, `RULES.md` wins.

**Done when:** each sentence that you wrote or changed obeys each rule in `UNSLOP.md`.

### Check

1. Answer yes or no for each rule in `RULES.md`. Fix each no, or keep it and write the reason.
2. Delete each sentence in the target folder that changes no decision. A sentence changes no decision if the agent acts the same without it.
3. Show the user the path of each file.

**The test:** Does an agent that has only the new `SKILL.md` and a sample request take the same steps each time?

**Done when:**

- Each rule in `RULES.md` has a yes or a written reason.
- Each sentence changes a decision.
- The user has the path of each file.

**Stop:** Do not start the Delivery phase before the user reviews the files.

### Delivery

1. If the user asks, install, commit, or push the skill. Otherwise, leave the files in the target folder.
2. If the branch file gives a commit message, use it.

**Done when:**

- Each file from the file list is in the target folder.
- Each install, commit, or push that the user asked for is complete.

**Reply:**

- The path of each file that you wrote or changed, one per line.
- Each rule kept as a no, with its reason.
- Each item that the Reply of the branch file adds.
