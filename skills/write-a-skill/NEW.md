# Write a new skill

**When it does not apply:** the user wants a job done once, not on each use. Do the job without a skill.

After the Draft phase, run the shared phases in `SKILL.md`.

## Phases

### Capture

Pin each item in this table.

| Item         | Question it answers                                           |
| ------------ | ------------------------------------------------------------- |
| Job          | What does the agent do, in one sentence?                      |
| Input        | Which arguments, files, or context does the skill read?       |
| Output       | Which files, changes, or final answer does it produce?        |
| Overlaps     | Which other skills in the repository overlap with this skill? |
| Dependencies | Without which tools, scripts, or skills is the output wrong?  |
| Failure      | Which failure does the skill prevent?                         |

1. Infer each item that you can from the requirements, the environment, and the repository.
2. Call the Skill tool with "grilling". Start the design tree with each item that you cannot infer. Do not ask about the invocation, the skeleton, the file list, or the target folder. The Choice phase chooses them.
3. If the Skill tool does not list `grilling`, ask the user about each item that you cannot infer. Put 5 questions or fewer in one message. Choose a default for each item that the user does not answer.
4. Show the user each answer and each default.

Write no skill file in this phase, because without the pinned items, a file contains guesses.

**Done when:** each item in the table has an answer or a default that you show the user. If you used `grilling`, the user also confirms that each decision has an answer.

### Choice

1. Choose the invocation.

   | If the skill                                            | Invocation |
   | ------------------------------------------------------- | ---------- |
   | has side effects, is a routine, or runs only on request | User       |
   | fits a situation that the agent can detect alone        | Model      |

   The Draft phase completes the template below for that invocation. Write the description last, in the Draft phase.

   <frontmatter-template>

   ```markdown
   ---
   name: <folder-name>
   description: <User: one line for a human, with no triggers. Model: leading word, then one "Use when" trigger per branch, in the user's words. Principle: the shape in skeletons/PRINCIPLE.md. If another skill overlaps, name it.>
   argument-hint: "<User only: a question that invites the argument>"
   disable-model-invocation: true   # User only. If model-invoked, delete this line.
   ---
   ```

   </frontmatter-template>

   If the skill is user-invoked, use this template for `agents/openai.yaml`. It makes Codex wait for the user.

   <openai-yaml-template>

   ```yaml
   interface:
     display_name: "<Title>"
     short_description: "<Under 50 characters>"
   policy:
     allow_implicit_invocation: false
   ```

   </openai-yaml-template>

2. Choose the skeleton from the job. Read the file in that row and no other file in the table.

   | The skill                                                                    | Skeleton  | File                     |
   | ---------------------------------------------------------------------------- | --------- | ------------------------ |
   | Does no work, and only sends the agent to other skills or files              | Router    | `skeletons/ROUTER.md`    |
   | Holds one rule of judgment that the agent applies during other tasks         | Principle | `skeletons/PRINCIPLE.md` |
   | Holds a vocabulary of 2 or more terms that the agent and other skills use    | Reference | `skeletons/REFERENCE.md` |
   | Does a job that the user or the agent starts, in 1 or more phases            | Workflow  | `skeletons/WORKFLOW.md`  |

   Use the first row that fits. If the new skill writes a document with a fixed shape, also read `skeletons/FORMAT.md`. It shapes a sibling file, not `SKILL.md`.

3. List each file for the target folder. If the skill is user-invoked, add `agents/openai.yaml`. Put material that only some uses need in a sibling `<BRANCH>.md`. Put a document shape in `<ARTIFACT>-FORMAT.md`. If a script can enforce a rule, plan the script.
4. Choose the target folder. If the user names no folder, use `<name>/` next to the other skills in the repository. If the repository has no skills, ask the user.
5. Show the user the invocation, the skeleton, the file list, and the target folder.

**Done when:** the user approves the invocation, the skeleton, the file list, and the target folder.

**Stop:** Do not start the Draft phase before the user approves the invocation, the skeleton, the file list, and the target folder.

### Draft

1. Write the frontmatter from the template in the Choice phase, except the description. Complete the skeleton. Replace each `<placeholder>` in prose. Delete each section that has no content.
2. Write each other file from the file list in the target folder.
3. Write the description last, because the body sets the branches that the description names.
4. Build each script. Delete each sentence that the script enforces.

**Done when:**

- Every file in the file list exists.
- No section in a new file is empty.
- The description starts with the leading word or a verb, and matches the frontmatter template for its invocation.
- No sentence restates what a script enforces.
- No `<placeholder>` remains in prose. A `<placeholder>` inside a template block or a command, such as `git log <tag>..HEAD`, can stay.

**Reply:** Add these items to the Reply in `SKILL.md`:

- The invocation: `User` or `Model`.
- The skeleton: `Router`, `Principle`, `Reference`, or `Workflow`.
- Each default that you chose without the user, one line each.
- How to start it: `/<name>` for a user-invoked skill, or a trigger phrase for a model-invoked skill.
