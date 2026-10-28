# Principle skeleton

A principle holds one rule of judgment that the agent applies during other tasks. Keep it under 400 words. Keep the sections in the template order.

<principle-template>

```markdown
# <Name in sentence case>

<Thesis in one sentence: "When <situation>, <action>.">

**Why:** <The cost when the agent skips the rule, in 1 to 3 sentences.>

**Pattern:**

- **<Bold imperative sentence.>** <How to do it, in 1 or 2 sentences.>
- **<Bold imperative sentence.>** <How to do it, in 1 or 2 sentences.>

**The test:** <A yes or no question that the agent answers after the work.>

**You skipped this when:** <The sign in the output that shows the agent did not apply the rule.>

**When it does not apply:** <The case where the rule costs more than it saves.>

This skill is different from `<other-skill>`, which <its job>. This skill <its job>.
```

</principle-template>

## Completion rules

- For a model-invoked principle, put the rule in the description, because an agent that reads only the description then gets the rule. Use this shape: `Apply when <situation>. <The rule in one sentence>.`
- If no installed skill overlaps, delete the line that names `<other-skill>`.
- If no sign in the output shows the skip, delete `**You skipped this when:**`.
