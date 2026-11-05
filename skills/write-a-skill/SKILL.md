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

Open a todolist with one entry per phase. List the phases of the branch file, then Wording, Check, and Delivery. If the user passed arguments, treat them as the requirements. If you skip a step, write `skip: <reason>` in its place. If you have no todolist tool, write the phases and their status in each reply.

## Shared phases

Run these phases after the phases of the branch file. Apply each rule only to the sentences that you wrote or changed. If a file in the target folder changes after the Wording phase, run Wording and Check again before you reply.

### Wording

1. Read `UNSLOP.md` in this skill's folder.
2. Apply each rule to each prose file in the target folder. If `UNSLOP.md` and `RULES.md` conflict, `RULES.md` wins.

**Done when:** each sentence that you wrote or changed obeys each rule in `UNSLOP.md`.

### Check

1. Answer yes or no for each rule in `RULES.md`. Fix each no, or keep it and write the reason.
2. If a fix changes what the skill does, show the user the gap and the proposed change. Apply the fix only after the user approves it. A fix that changes only the wording needs no approval.
3. If a sentence that you wrote or changed changes no decision, delete it. A sentence changes no decision if the agent acts the same without it.
4. Run the test. If the change is only wording, write `skip: wording only`. If you have no sub-agent tool, write `skip: no sub-agent tool`. Otherwise, start 2 new sub-agents with the same sample request. Choose a request that reaches the changed sentences.
5. Make sure that each quoted sentence is in the files and settles the guess. If it is not or does not, treat the guess as `none`. Mark the test `PASS` if the 2 lists of steps match and no `none` guess changes a step. Otherwise, mark it `ISSUES`. If a sub-agent fails, mark the test `ISSUES` and report the failure.
6. If the test is `ISSUES`, follow step 2 for each fix. Then run the test again. After 2 runs, show the user each remaining gap. If the user approves a fix for a remaining gap, run the test 1 more time.
7. Show the user the path of each file.

<trace-brief-template>
Read each file at these paths: <path of each file in the file list>. Trace the steps for this request: <sample request>. Run no commands, and change no files. List each step in order. List each guess that you made. For each guess, quote the sentence that settles it, or write `none`. If you write `none`, say if another answer changes a step. Under 400 words.
</trace-brief-template>

**The test:** Does an agent that has only the files in the file list and a sample request take the same steps each time?

**Done when:**

- Each rule in `RULES.md` has a yes or a written reason.
- Each sentence changes a decision.
- The test has `PASS`, `ISSUES` with each gap shown to the user, or a `skip:` reason.
- The user has the path of each file.

**Stop:** Do not start the Delivery phase before the user reviews the files. A request to deliver covers only files that did not change after the request. If a file changed, show the user the change and ask again.

### Delivery

1. If the user asks, install, commit, or push the skill. Otherwise, leave the files in the target folder.
2. If the branch file gives a commit message, use it.

**Done when:**

- Each file from the file list is in the target folder.
- Each install, commit, or push that the user asked for is complete.

**Reply:**

- The path of each file that you wrote or changed, one per line.
- Each rule kept as a no for a sentence that you wrote or changed, with its reason.
- The result of the test.
- Each item that the Reply of the branch file adds.
