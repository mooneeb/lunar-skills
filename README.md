# lunar-skills

Agent skills I've written, or reworked from other people's skills.

| Skill | What it does |
|---|---|
| [write-a-skill](skills/write-a-skill) | Write a new agentic skill, or change an existing skill after an observed failure. |
| [create-tickets](skills/create-tickets) | Split a spec into the fewest vertical-slice tickets that each fit one agent session, and publish them as GitHub sub-issues with native blocking links. |
| [teach](skills/teach) | Teach the user a new skill or concept, within this workspace. |
| [pr-review-ensemble](skills/pr-review-ensemble) | Before a PR exists, review the change with the latest Claude Opus and GPT Sol in a budget of rounds, keeping only blockers and major defects with repro steps. |
| [implement-and-review](skills/implement-and-review) | Implement a spec or tickets on a fresh branch and worktree, then review it with `code-review` and `pr-review-ensemble` without fixes that add behavior the spec does not ask for. |

## Install

Clone the repo and link the skills you want into your agent's skills folder:

```sh
git clone https://github.com/mooneeb/lunar-skills.git
ln -s "$PWD/lunar-skills/skills/write-a-skill" ~/.claude/skills/write-a-skill
```

Some skills mention [Matt Pocock's](https://github.com/mattpocock/skills) `grilling`, `to-tickets`, `tdd`, and `code-review` skills. Install those from his repo if you want them.

## Credits

- `teach` is reworked from [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/productivity/teach) (MIT, © Matt Pocock). His license is in [skills/teach/LICENSE](skills/teach/LICENSE).
- `create-tickets` is reworked from Matt Pocock's [to-tickets](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets) (MIT, © Matt Pocock). His license is in [skills/create-tickets/LICENSE](skills/create-tickets/LICENSE).
- `implement-and-review` is reworked from Matt Pocock's [implement](https://github.com/mattpocock/skills/tree/main/skills/engineering/implement) (MIT, © Matt Pocock). His license is in [skills/implement-and-review/LICENSE](skills/implement-and-review/LICENSE).
- `write-a-skill` includes `UNSLOP.md` by Lauren Tan (MIT). Her license is in [skills/write-a-skill/UNSLOP-LICENSE](skills/write-a-skill/UNSLOP-LICENSE).

## License

[MIT](LICENSE), except where a skill folder has its own license file.
