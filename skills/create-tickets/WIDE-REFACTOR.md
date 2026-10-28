# Wide refactor

A **wide refactor** is one mechanical change that breaks many call sites across the codebase at once, such as a rename of a shared column. It has no user behavior, so it cannot be a vertical slice. Split it with **expand–contract**, also called parallel change.

1. Write an expand ticket. It adds the new form next to the old form, so that every caller still works.
2. Write one migrate ticket for each batch of callers, such as one for each package. Each migrate ticket is blocked by the expand ticket. The tests pass after each batch, because the old form still exists.
3. Write a contract ticket. It deletes the old form, and it is blocked by every migrate ticket.
4. In each of these tickets, replace the QA demo with the test command and its result. In the contract ticket, add a search that shows no caller of the old form.
5. If a vertical slice needs the new form, block it on the expand ticket, not on the contract ticket.

These tickets do not need the size rules or the test in `SKILL.md`, because they have no product behavior.
