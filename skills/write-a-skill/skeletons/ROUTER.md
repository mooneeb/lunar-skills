# Router skeleton

A router sends the agent to other skills or files, and gives no explanation. An alias is a router with one target.

<alias-template>

```markdown
Call the Skill tool with "<target>".
```

</alias-template>

<router-template>

```markdown
<What the router chooses, in one sentence.>

| The user wants to | Skill |
| --- | --- |
| <Situation, in the user's words> | `<skill>` |
| <Situation, in the user's words> | `<skill>` |

If no row matches, <default action>.
```

</router-template>

## Completion rules

- Write one row per target. If 2 branches share a target, list both situations in that row.
- If a target is user-invoked, write "tell the user to run `/<target>`" in its row or the alias. Do not call a user-invoked skill with the Skill tool.
