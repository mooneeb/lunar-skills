# Change an existing skill

Change only the sentences that cause an observed failure. Add a sentence only where a missing sentence lets the failure occur. Keep the invocation, the skeleton, and each other sentence.

**When it does not apply:** the user wants to replace the skill with a new skill. Read `NEW.md` instead.

After the Draft phase, run the shared phases in `SKILL.md`.

## Phases

### Capture

Pin each item in this table.

| Item     | Question it answers                                                   |
| -------- | --------------------------------------------------------------------- |
| Skill    | Which folder holds the existing skill?                                |
| Failure  | What did the agent do, and what did the user expect?                  |
| Evidence | Where did the failure occur: a transcript, an output, or a file?      |

1. Infer each item that you can from the requirements, the environment, and the repository.
2. Ask the user for the rest in one message.
3. Use the folder of the existing skill as the target folder. Use its files as the file list.
4. If the user names no observed failure, ask which failure they saw. Do not start the Cause phase before the user names it, because a change without a failure fixes nothing.

**Done when:** each item in the table has an answer that you show the user.

### Cause

1. Read each file in the target folder.
2. Find each sentence that causes the failure. If no sentence causes it, find where a missing sentence lets it occur.
3. For each sentence or gap, write the smallest change that prevents the failure. If a script can enforce the fix, plan the script.
4. Show the user each sentence or gap, how it causes the failure, and the proposed change.
5. If one of these conditions is true, call the Skill tool with "grilling". Start the design tree with each open decision.
   - The change edits more than 3 sentences, or adds a phase, a file, or a script.
   - The user asks for a discussion.
   - After the Capture questions and step 4, the user and you still disagree on the failure, the cause, or the change.
6. If you cannot tell whether a condition in step 5 is true, ask the user: "Do you want a grilling session?"
7. If the Skill tool does not list `grilling`, ask the user about each open decision. Put 5 questions or fewer in one message.

**Done when:** the user sees each sentence or gap, how it causes the failure, and its proposed change. If you used `grilling`, the user also confirms that each decision has an answer.

**Stop:** Do not start the Draft phase before the user approves the changes.

### Draft

1. Make only the approved changes. Do not reword other sentences, because each change needs an observed failure.
2. Build each planned script. Delete each sentence that the script enforces.
3. Write the failure in one sentence. Use it as the commit message in the Delivery phase.

**Done when:**

- Each approved change is in the target folder.
- No other sentence changed.
- The failure sentence exists.

**Reply:** Add these items to the Reply in `SKILL.md`:

- The failure, in one sentence.
- Each changed sentence, before and after.
