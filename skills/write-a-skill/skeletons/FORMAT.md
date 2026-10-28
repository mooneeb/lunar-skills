# Format file skeleton

A format file sets the shape of a document that the new skill writes. Name it `<ARTIFACT>-FORMAT.md`, such as `ADR-FORMAT.md`. Put a pointer to it in `SKILL.md` at the step that writes the document.

<format-template>

```markdown
# <Artifact> format

<Where the agent saves the document and what the document is for, in 1 or 2 sentences.>

## Template

<A fenced template in an `<artifact-template>` tag, with <placeholder> prose.>

## Rules

- **<Imperative rule>.** <The reason, in one sentence.>

## When to write one

1. <Condition. All conditions must be true.>

### What does not qualify

- <A case that looks like it qualifies but does not.>
```

</format-template>

## Completion rules

- Include only the fields that every document needs, because the agent completes each extra field with guesses.
- If the shape is hard to describe, add one example in an `<artifact-example>` tag. The agent copies the nearest example, so make the example correct.
