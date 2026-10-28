# Ticket format

Each ticket is one draft file. `scripts/publish.sh` turns the header into the title, the label, and the native blocking links, and posts the rest as the body. The body tells one agent which behavior to build, and tells a person how to test it.

## Template

<ticket-template>

```markdown
# <NN>: <Title>

Status: <ready-for-agent or ready-for-human>
Blocked by: <the NN of each blocking ticket, such as 01, 02, or none>

## What to build

<The behavior that this ticket makes work, from the view of the user, in 1 to 3 sentences.>

## Acceptance criteria

- [ ] <A result that a test or a person can see.>

## How to QA

1. <A step that a person does in the product, such as a click or a command.>
2. <The result that the person sees.>
```

</ticket-template>

## Rules

- **Describe the behavior, not the change to each layer.** A list of layer changes leads the agent to build one layer at a time.
- **Do not write file paths, line numbers, or code snippets.** Paths go stale, and the agent reads the code itself. A prototype can produce a schema, a type, or a state machine that prose cannot state as exactly. If so, paste the smallest part, and write that it came from a prototype.
- **Write the blocking tickets only in the `Blocked by:` line.** Do not write them in the body, and do not write which tickets this ticket unblocks. GitHub shows the native links, and a copy in the body goes stale when a ticket changes.

<ticket-example>

```markdown
# 01: Admin sends an invite and sees it as Pending

Status: ready-for-agent
Blocked by: none

## What to build

An admin enters an email address on the team page and sends an invite. The invite appears in the invite list of the team with the status Pending.

## Acceptance criteria

- [ ] An admin sees an email field and an Invite button on the team page.
- [ ] A valid email address creates an invite with the status Pending.
- [ ] An invalid email address shows an error and creates no invite.
- [ ] The invite list shows each pending invite with its email address and its date.
- [ ] A member who is not an admin does not see the Invite button.

## How to QA

1. Sign in as an admin and open the team page.
2. Enter `qa@example.com` and click Invite. The list shows `qa@example.com` as Pending.
3. Enter `not-an-email` and click Invite. An error appears, and the list does not change.
4. Sign in as a member who is not an admin. The Invite button does not appear.
```

</ticket-example>
