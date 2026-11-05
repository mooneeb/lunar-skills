# Change an existing skill

Change only the sentences that cause an observed failure. Add a sentence only where a missing sentence lets the failure occur. Keep the invocation, the skeleton, and each other sentence, unless the user approves a restructure.

**When it does not apply:** the user wants to replace the skill with a new skill. Read `NEW.md` instead.

After the Draft phase, run the shared phases in `SKILL.md`.

## Phases

### Capture

Pin each item in this table.

| Item     | Question it answers                                                                                                |
| -------- | ------------------------------------------------------------------------------------------------------------------ |
| Skill    | Which folder holds the existing skill?                                                                             |
| Failure  | What did the agent do, and what did the user expect?                                                               |
| Evidence | Where did the failure occur: a transcript, an output, a file, a review note from the user, or a gap from the test? |

1. Infer each item that you can from the requirements, the environment, and the repository.
2. Ask the user for the rest in one message. If you inferred each item, do not wait for a reply, because the first approval is at the Stop in the Cause phase.
3. Use the folder of the existing skill as the target folder. Use its files as the file list.
4. If the user names no observed failure, ask which failure they saw. Do not start the Cause phase before the user names it, because a change without a failure fixes nothing.

**Done when:** each item in the table has an answer that you show the user.

### Cause

1. Read each file in the target folder, and each skill and script that those files name.
2. Find each sentence that causes the failure. If no sentence causes it, find where a missing sentence lets it occur.
3. Compare the skill with its skeleton in `skeletons/` and the Structure rules in `RULES.md`. Show the user each gap in the message of step 5. Do not restructure without approval, because a restructure can lose a rule. A gap from this step is not a change until the user approves it.
4. For each sentence or gap, write the smallest change that prevents the failure. If a script can enforce the fix, plan the script. If you found a problem only by reading, reproduce it. If you cannot reproduce it, label it `unproven` and propose its change. A gap from step 3 needs neither, because the comparison proves it. If a change needs a file in another skill folder, add the file to the file list. Treat that folder as part of the target folder.
5. Show the user each sentence or gap, how it causes the failure, and the proposed change. For each new term, column, or rule, write its meaning in plain words and 1 example.
6. If one of these conditions is true, call the Skill tool with "grilling". Start the design tree with each open decision.
   - The proposed changes together edit more than 3 sentences, or add a phase, a file, or a script. Count a restructure only after the user approves it. If the user approves it, do this step again before the Draft phase. If a `grilling` session is open, add the restructure to that session.
   - The user asks for a discussion.
   - After the Capture questions and step 5, the user and you still disagree on the failure, the cause, or the change.
7. If you cannot tell whether a condition in step 6 is true, ask the user: "Do you want a grilling session?"
8. If the Skill tool does not list `grilling`, ask the user about each open decision. Put 5 questions or fewer in one message.

**Done when:** the user sees each sentence or gap, how it causes the failure, and its proposed change. If you used `grilling`, the user also confirms that each decision has an answer.

**Stop:** Do not start the Draft phase before the user approves the changes. If the user only answers questions or changes an item, ask for approval again.

### Draft

1. Make only the approved changes. Do not reword other sentences, because each change needs an observed failure.
2. Build each planned script. Delete each sentence that the script enforces.
3. If the user approved a restructure, list each deleted sentence and where its rule is now.
4. Write the failure in one sentence. Use it as the commit message in the Delivery phase.

**Done when:**

- Each approved change is in the target folder.
- No other sentence changed, unless the user approved a restructure.
- The failure sentence exists.

**Reply:** Add these items to the Reply in `SKILL.md`:

- The failure, in one sentence.
- Each changed sentence, before and after. After a restructure, give the list of deleted sentences in place of before and after.
