# Workflow skeleton

A workflow does a job from start to end, in 1 or more phases.

<workflow-template>

```markdown
A **<term>** is <genus> that <difference>. <The key constraint, as "X, not Y".>

<A setup line for each dependency without which the output is wrong.>

## Start

Open a todolist with one entry per phase. If you skip a step, write `skip: <reason>` in its place.

1. <Phase>
2. <Phase>

## Phases

### <Phase>

1. <If condition,> <imperative verb> <object>. <The failure that this step prevents, in one sentence.>
2. Call the Skill tool with "<other-skill>".

**Done when:** <A condition that uses "each" or "every". The agent must be able to make sure that it is true.>

**Stop:** Do not start the <next phase> phase before <condition>.

### <Phase>

1. <Imperative verb> <object>. Default: <value>. If <value> fails, use <fallback>.

**Done when:** <condition>.

**The test:** <A yes or no question.>

**When it does not apply:** <case>. <What to do instead.>

**Reply:** <The exact contents of the final answer, with a closed set of status words.>
```

</workflow-template>

## Completion rules

- If the job has one phase, delete `## Start`, `## Phases`, and the phase heading. Write the numbered steps under the opening line. Keep `**Done when:**` and `**Reply:**`.
- Name each phase with one noun. Use the same noun in the todolist and the heading.
- Find the first point where a hidden error reaches a write, a post, or a sub-agent. If no person reviews the work before that point, add `**Stop:**` in the phase before it.
- If the skill takes arguments, add a step: "If the user passed arguments, treat them as <what>."
- If a phase starts a sub-agent, add the brief below. The sub-agent sees only the brief.

<sub-agent-brief-template>

```markdown
For the <role> sub-agent brief, include:

- <Input 1, pasted in full.>
- <Input 2, as a path.>

The brief: "<Task>. Report <item 1> and <item 2>. Quote <evidence> for each finding. Under 400 words."

If a sub-agent fails, continue with the other sub-agents. Report the failure.
```

</sub-agent-brief-template>
