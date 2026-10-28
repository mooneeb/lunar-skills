# Rules

These rules cover what a skill contains and how it is organized.

## Structure

- Use lowercase letters, numbers, and hyphens in the skill name, with at most 64 characters. Use the folder name as the skill name.
- Keep `SKILL.md` at 500 lines or fewer.
- Keep material that each use of the skill needs in `SKILL.md`. Move material that only some uses need to a sibling file. Write the load condition next to the pointer: "If <condition>, read `<FILE>.md`." Give each sibling file a pointer in `SKILL.md`, or in a file that `SKILL.md` points to.
- If a workflow has 2 or more phases, start it with a todolist of the phases. Name each phase with one noun. Use the same noun in the phase heading.
- End each phase with `**Done when:**` and a condition. The agent must be able to make sure that the condition is true. Make the condition cover each step in the phase. In a skill with one phase, end the steps with one `**Done when:**`. If the condition covers all the work, use "each" or "every".
- Find where a hidden error first reaches a write, a post, or a sub-agent. If no person reviews the work before that point, add `**Stop:**`. Put it after `**Done when:**` in the phase before that point. Name the condition that unblocks the next phase.
- End a skill that returns an answer with `**Reply:**`. List the exact contents of the final answer.
- Start the body of a principle, a reference, or a workflow with a bold definition or a thesis. Start a router with its first pointer. Write no preamble.
- In a reference skill, start with a bold definition: "A **term** is <genus> that <difference>."
- Give the agent a closed set of status words for each state it reports, such as `PASS`, `ISSUES`, and `BLOCKED`.
- Put each block that the agent copies inside a labeled tag. End the tag name with `-template` to complete, `-rules` to obey, or `-example` to copy. An example is `<spec-template>`. The agent copies the nearest example, so make each example correct.

## Description

- Write at most 1024 characters.
- Put the leading word or a verb first.
- For a model-invoked skill, write one trigger per branch. Quote the user's literal words. Do not repeat what the body says, because the description only routes. A principle is the exception. It uses `Apply when` and states its rule, as `skeletons/PRINCIPLE.md` shows.
- For a user-invoked skill, write one line for a human.
- If two skills overlap, name the other skill: "Use `<other-skill>` for <its job>."

## Guardrails

- Pair each "Do not" with the positive action or the reason.
- In a principle or a workflow, add one yes or no question as `**The test:** <question>`. In a principle, if a skip is visible in the output, also add `**You skipped this when:**` and the visible sign.
- In a principle or a workflow, name the failure that the skill prevents. Put it at the step where the failure occurs.
- In a principle or a workflow, say when the skill does not apply: `**When it does not apply:** <case>`. Require `skip: <reason>` for each skipped step.
- Put a reason that is longer than one clause under `**Why:**`, in 1 to 3 sentences.
- Give each parameter a default and a fallback.
- If one sub-agent fails, continue with the other sub-agents. Report the failure.

## Composition

- Call a model-invoked skill: `Call the Skill tool with "<name>".` For two skills, write "Call the Skill tool twice", because each call takes one skill.
- Point the user to a user-invoked skill: "tell the user to run `/<name>`". Do not call it with the Skill tool.
- If the output is wrong without a dependency, add a setup line for it. If the output is only worse without a dependency, name the dependency in a sentence.
- Point to the source. Do not restate it. Say which source wins a conflict.
- List the contents of each sub-agent brief. End the brief with a word limit, such as "Under 400 words." The sub-agent sees nothing else, so paste what it needs. If it can read files, give the path instead.

## Maintenance

- Delete each sentence that changes no decision. Delete the whole sentence, not words from it. A sentence changes no decision if the agent acts the same without it.
- Write only what the agent cannot find in the files or the environment. Do not write what the model does by default.
- In an existing skill, wait for an observed failure before you change the wording. Name the failure in the commit message.
- If a script, a type, or a lint can enforce a rule, build it. Then delete the sentence that states the rule.

## Labels

- Use a bold label with a colon only for these fixed labels: `**Done when:**`, `**Stop:**`, `**The test:**`, `**When it does not apply:**`, `**Reply:**`, `**Why:**`, `**Pattern:**`, and `**You skipped this when:**`. A glossary term in bold with a colon is also allowed.

## Terms in these rules

- A yes or no question is "the test".
- "Run" is a verb that means "execute".
- One start of a skill is "a use".
- A file next to `SKILL.md` is "a sibling file".
- A known term from a field that names the job, such as "test-driven development", is "the leading word".
