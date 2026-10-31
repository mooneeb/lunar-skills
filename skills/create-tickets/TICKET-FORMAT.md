# Ticket format

Each ticket is one draft file. `scripts/publish.sh` turns the header into the title, the label, and the native blocking links, and posts the rest as the body. The body tells one agent which behavior to build, and tells a person how to test it.

A **scenario** is one run through the product with one setup and ordered steps. It checks each result that shares that setup. Each `automated` scenario becomes one automated test. Each `manual` scenario is one run by a developer.

## Template

<ticket-template>

```markdown
# <NN>: <Title>

Status: <ready-for-agent or ready-for-human>
Blocked by: <the NN of each blocking ticket, such as 01, 02, or none>

## What to build

<The behavior that this ticket makes work, from the view of the user, in 1 to 3 sentences.>

## User stories

- <The number of the story in the spec, with the part if the ticket covers part of it>. <The story, quoted in full from the spec.>

## How to QA

### Scenario 1: <Name> (<automated, or manual, needs the device or tool>)

Covers: <the story numbers>
Setup: <The accounts, data, and commands, with literal values.>

Given <the state before the first step>
When <the actions>
Then <one result that a person sees>
And <one more result>

Steps:

1. <An action that a developer does in the product, with literal data.> <The result that the developer sees.>
```

</ticket-template>

## Rules

- **Describe the behavior, not the change to each layer.** A list of layer changes leads the agent to build one layer at a time.
- **Do not write file paths, line numbers, or code snippets.** Paths go stale, and the agent reads the code itself. A prototype can produce a schema, a type, or a state machine that prose cannot state as exactly. If so, paste the smallest part, and write that it came from a prototype.
- **Write the blocking tickets only in the `Blocked by:` line.** Do not write them in the body, and do not write which tickets this ticket unblocks. GitHub shows the native links, and a copy in the body goes stale when a ticket changes.
- **If the ticket covers part of a story, write the part after the number,** such as `17 (page turns only)`. Quote the full story.
- **Put each result that shares one setup in one scenario.** Each scenario costs one setup, one test, and one manual run.
- **Write one result in each `Then` or `And` line.** A line with two results hides a result that nobody tests.
- **Tag a scenario `manual` only if no automated test can run it,** such as a check with VoiceOver or on a physical device. Name the device or the tool after `needs`.
- **Write each step with literal data, and end it with the result that the developer sees.** A developer who has not read the code must be able to run each step.

<ticket-example>

```markdown
# 01: Admin sends an invite and sees it as Pending

Status: ready-for-agent
Blocked by: none

## What to build

An admin enters an email address on the team page and sends an invite. The invite appears in the invite list of the team with the status Pending.

## User stories

- 4. As an admin, I want to invite a person by email, so that they can join my team.
- 5 (the Pending status only). As an admin, I want to see the status of each invite, so that I know who has not joined yet.
- 9. As a member, I want only admins to send invites, so that strangers cannot join my team.

## How to QA

### Scenario 1: Admin sends a valid and an invalid invite (automated)

Covers: 4, 5
Setup: Run `pnpm seed:qa`. It creates the team `QA Team` and the admin `admin@example.com` with the password `admin-pass`.

Given I am signed in as `admin@example.com` on the page of `QA Team`
When I invite `qa@example.com`, then `not-an-email`
Then the invite list shows `qa@example.com` with the status Pending and the date of today
And `not-an-email` shows the error "Enter a valid email address"
And the invite list does not show `not-an-email`

Steps:

1. Sign in as `admin@example.com` with `admin-pass`, and open the page of `QA Team`. You see an email field and an Invite button.
2. Enter `qa@example.com` and click Invite. The list shows `qa@example.com`, Pending, and the date of today.
3. Enter `not-an-email` and click Invite. The error "Enter a valid email address" appears, and the list does not change.

### Scenario 2: A member who is not an admin cannot invite (automated)

Covers: 9
Setup: Run `pnpm seed:qa`. It creates the member `member@example.com` with the password `member-pass` in `QA Team`.

Given I am signed in as `member@example.com` on the page of `QA Team`
When the page loads
Then I do not see the Invite button

Steps:

1. Sign in as `member@example.com` with `member-pass`, and open the page of `QA Team`. You see the invite list, but no email field and no Invite button.
```

</ticket-example>
