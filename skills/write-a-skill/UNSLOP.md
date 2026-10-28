---
source: https://github.com/cursor/plugins
path: pstack/skills/unslop/SKILL.md
commit: df58112
author: Lauren Tan
license: MIT, see UNSLOP-LICENSE
changes: The body is adapted from upstream but modified to include the rules ASD-STE100 Issue 9 and more rules for clear and concise use of English language.
---

# Unslop

This file holds every rule for the English of a skill. The rules follow **ASD-STE100 Simplified Technical English, Issue 9**. At some points, these rules are stricter than ASD-STE100. Apply the rules when you write a skill and when you edit a skill. Each pattern below is a sign of AI prose or of unclear English.

## Process

1. Scan the text for each pattern below.
2. Rewrite each match. Keep the meaning and the intended tone.
3. If a word-for-word replacement is not enough, change the construction of the sentence.

## Patterns to detect and fix

A quoted bad example in this file shows the bad form. Do not copy it.

### Content

- **Superficial -ing phrases.** The signs are "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete the phrase, or expand it with a real source.
- **Vague attributions.** The signs are "Experts believe", "Industry reports suggest", "Some critics argue". Name the source, or delete the claim.

### Language

- **AI vocabulary.** The words are additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape as an abstraction, pivotal, showcase, tapestry as an abstraction, testament, underscore, vibrant. Replace each one with a plain word.
- **Fancy ways to say "is".** The signs are "serves as", "stands as", "boasts", "features". Write "is" or "has".
- **"Not just X, but Y."** State the point. Additional emphasis is not required.
- **Rule of three.** Do not force ideas into groups of three. Use the natural number.
- **Synonym cycling.** "Protagonist", "main character", "central figure", and "hero" in one paragraph name one person. Give each concept one name, and repeat that name exactly. Do not use different technical nouns for the same item. If a synonym is likely, list it under `_Avoid_`. Use a consistent style for terms and wording.
- **False ranges.** Do not write "from X to Y" when X and Y are not on a meaningful scale. List the topics.

### Words

- **Approved words.** Use each word with one meaning only, and as one part of speech only. The table in Unapproved words lists the common words to replace.
- **Unapproved words.** Replace each word in this table.

| Do not write              | Write                                                |
| ------------------------- | ---------------------------------------------------- |
| "may"                     | "can" or "possibly"                                  |
| "might"                   | "can" or "possibly"                                  |
| "could" for a possibility | "can"                                                |
| "should"                  | "must" for a true invariant, or "if" for a condition |
| "shall"                   | "must"                                               |
| "would"                   | "can"                                                |
| "will"                    | the present tense or the imperative                  |
| "ensure"                  | "make sure"                                          |
| "verify"                  | "make sure"                                          |
| "check" as a verb         | "make sure", or "do a check of"                      |

- **Contractions.** Do not use contractions. Write "does not", not "doesn't".
- **Spelling.** Use American spelling: "organize", not "organise", and "color", not "colour".
- **Technical nouns.** Use a technical noun that the field approves. Choose a short, easy noun. Do not use a technical noun as a verb, or a verb as a noun.
- **Few terms.** Coin few terms. Define each term at its first use.
- **Noun clusters.** Do not stack more than 3 nouns: "the error report", not "the skill folder build error report". If a technical noun is longer, write it in full first. Then give a shorter form, or join the words with hyphens.
- **Numbers.** Use numbers, not adjectives: "2 to 4 questions", not "a few questions".
- **Real identifiers.** Use the real identifier: the command, the path, the key, or the flag.

### Jargon

- **Abstract metaphor nouns.** The nouns are substrate, wedge, vector, locus, vantage, nexus, primitive as a noun, harness as a metaphor, surface as in "API surface", and bedrock. Other nouns are scaffolding as a metaphor, modality, paradigm, gold-plating, ratchet as a metaphor, evacuate for moved code, endgame, north star, flywheel. These words look technical, but most of them have a plainer, concrete word. Pick the concrete word.
  - "Substrate" becomes "base". "Wedge in" becomes "add". "Vector" becomes "way" or "method". "Gold-plating" becomes "more than the job needs".
  - "Ratchet" becomes the real name of the mechanism, or "a limit that only tightens". "Evacuate" becomes "move out". "Endgame" becomes "the last phase".
  - A leading word that is a real term from a known field is allowed, such as _tracer bullet_ and _red-green-refactor_. Define it once. For other leading words, use the plain word.
- **Slang and jargon.** Do not use slang or jargon as a technical noun. The pattern Technical nouns says which noun to use.

### Verbs

- **Verb forms.** Use only the infinitive, the imperative, the simple present, the simple past, and the past participle as an adjective. For "will", use the row in the table in Unapproved words. Do not use complex forms with auxiliaries, such as "has been" or "is to be installed".
- **Tense and mood.** Use the imperative for steps and instructions. Use the present tense for facts. Do not use the imperative in descriptive text. Use "must" for a true invariant and nowhere else.
- **The -ing form.** Use the -ing form only as a technical noun, or as a modifier in a technical noun.
- **Concrete verbs.** Use a concrete verb that names an action you can see: pin, trace, write, run, delete.
- **Verbs for actions.** Use a verb, not a noun, for an action: "the loader parses the file", not "the loader does the parsing of the file".
- **Phrasal verbs.** Use a single verb, not a phrasal verb. Write "start", not "kick off". Write "complete", not "fill in".

### Sentences

- **Contrast.** Define a thing by contrast: "X, not Y".
- **Connecting words.** Use connecting words, such as "then", "but", and "because", to link sentences on related topics.
- **Lists and tables.** Use a numbered list for steps and a table for choices. Use a vertical list for complex text.

### Instructions

- **One instruction per sentence.** Write one instruction in each sentence. If two actions occur at the same time, write them in one sentence.
- **Condition first.** Put the condition before the instruction. Write the condition, then a comma, then the command: "If X, do Y."
- **Reasons.** Give a reason in one "because" clause only where the agent can misapply a step.
- **Notes.** A note gives information only. Do not put an instruction in a note.

### Descriptions

- **One subject per sentence.** Write about one subject in each sentence. Give the information step by step.
- **Key words.** Use key words to give the text a logical structure.
- **Paragraphs.** Write about one topic in each paragraph. Write at most 6 sentences in a paragraph.

### Punctuation

- **Semicolons.** Do not use a semicolon. Write two sentences.
- **Parentheses.** Do not use parentheses in prose. Write the aside as a sentence, or delete it. ASD-STE100 allows parentheses for some uses. These rules do not allow them.
- **Hyphens.** Use a hyphen to join words that have a direct relation, such as "one-word phases".

### Style

- **Em dash overuse.** Do not use em dashes. Rewrite the sentence, or end it. Do not swap the character for a comma, an en dash, a hyphen, or parentheses.
- **Colon overuse.** Use a colon to define a term, or before a list or an example. Do not use a colon to connect the parts of a sentence.
  - The colon in "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" adds nothing. Rewrite the point so that it stands alone, with no comparison frame. "Plain English works best to describe when the scheduler fires." The meaning stays the same, and the sentence needs no colon.
- **Boldface overuse.** Do not bold every proper noun or acronym.
- **Inline-header lists.** A bold label and a colon that restate the line are the sign: "**Performance:** Performance improved...". Convert those lines to prose. A bold lead-in is not a sign if it ends in a period, names the item, and comes before new detail. An example is "**Schema in TypeScript.** Tables live in one file."
- **Title case headings.** Use sentence case. Write headings as verb phrases or nouns. A rule can be a heading: `## Plan, do not build`.
- **Decorative emojis.** Remove emojis from headings and bullets.
- **Curly quotes.** Replace curly quotes with straight quotes.

### Communication artifacts

- **Chatbot phrases.** The phrases are "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove them.
- **Sycophantic tone.** An example is "Great question! You're absolutely right!" Give the answer with no praise.

### Voice

- **The agent and the user.** Address the agent as "you". Call the human "the user".
- **Persona.** If "I" or a persona changes no decision, delete it.
- **Two voices.** Do not mix the voice for humans with the voice for agents. A README for humans can be personal. A skill file for an agent uses the plain voice of these rules.

### Filler

- **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". Delete "It is important to note that".
- **Excessive hedging.** "could potentially possibly be argued that it might" becomes "can".
- **Generic conclusions.** An example is "The future looks bright." State specific plans or facts.

### Plain speech

- **Say what it does, not how it feels.** "the database stays close at hand", "SQL you can read", and "types that follow your schema" name a feeling. The fix names the mechanism or a number: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build".
  - Ask what the sentence tells the reader to do or know. Then write that. If you cannot restate the sentence as a concrete instruction, fact, or number, cut it.
  - Do one more check. If the sentence can appear unchanged in the docs of another project, it says nothing about this project. Cut it.
- **Shorten or split dense sentences.** If the reader has to reread a sentence to parse it, split it in two or drop clauses. Write short, clear sentences with one idea each. Aim for about 11 words. Write a longer sentence only for a condition or a consequence.
  - Write at most 20 words in an instruction and at most 25 words in a descriptive sentence. A hyphenated word counts as one word. Before a vertical list, the colon ends the sentence for the word count.
- **Active voice.** Use the active voice, and name the actor. Find "is", "are", "was", or "were" before a past participle. "queries are validated" becomes "the compiler validates queries". "the file is parsed by the loader" becomes "the loader parses the file". Use the passive only in a description, and only when the actor is unknown.
- **Cut adverbs, or use a stronger verb.** "runs quickly" becomes the number. "significantly improves" becomes the measured delta. If an adverb supports a weak verb, the verb is wrong.
- **Prefer the plain word.** "utilize" becomes "use", "leverage" becomes "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if". In most cases, the fancier synonym is not clearer.
- **Mannered prose.** Do not use a metaphor or a flourish where a literal phrase exists. Signs are aphorisms such as "wire it or delete it" and rhetorical fragments for effect. Other signs are personified code such as "the plan holds it", figurative verbs such as "rides along" and "stands on", and stock framing phrases. "A dial worth turning" becomes "a parameter worth varying". Say what you mean.
  - Do not use a figure of speech for decoration, because it hides the real term. A leading word that is a real term from a known field is allowed, such as _tracer bullet_ and _red-green-refactor_. Define it once. The pattern Abstract metaphor nouns lists the metaphor nouns.
- **Over-compression.** Dropped articles, verbless fragments, symbol-speak, and abbreviations make the reader decode the text. "Parser rejects bad date → exit 2, no write" becomes "The parser rejects a bad date, exits with code 2, and writes nothing."
  - Write whole sentences with their articles and verbs. Do not omit nouns, verbs, subjects, or articles. Keep "the" and "a". Put an article or a demonstrative, such as "this", before a noun where it applies. Write arrows and abbreviations as full words.
