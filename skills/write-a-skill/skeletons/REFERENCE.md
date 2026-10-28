# Reference skeleton

A reference holds a vocabulary that the agent and other skills use. It has no phases.

<reference-template>

```markdown
A **<core term>** is <genus> that <difference>. <The key constraint, as "X, not Y".>

## Glossary

**<Term>**: <What it is, in one sentence>. <Its boundary, in one sentence>. _Avoid_: <synonym>, <synonym>.

## Principles

- **<Imperative rule>.** <The reason, in one sentence.>

## Anti-patterns

- **<Name of the bad shape>.** <How to find it.> <What to do instead.>

## Rejected framings

- **<Framing>.** <Why it misleads.>
```

</reference-template>

## Completion rules

- Order the glossary so that each entry uses only terms defined above it.
- For a model-invoked reference, add this branch to the description: "or when another skill needs the <topic> vocabulary".
- If no wrong framing is likely, delete `Rejected framings`.
