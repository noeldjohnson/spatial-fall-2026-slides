# Plain Statement (No Cutesy Prose)

Portable rule for all writing in this workflow. It governs slides, handouts,
syllabus and assignment prose, emails, and code comments a student or reader
sees. Copy this file into a new project's `.claude/rules/` and reference it from
that project's `CLAUDE.md`.

Added 4 October 2026 at Noel's direction, after he read the Week 6 deck and
called its prose "cutesy" and condescending.

---

## The device

A sentence that performs for the reader in place of informing them. It sounds
wise, wry, or knowing. Read it for content and little or nothing is left.

Noel's words on the Week 6 slides: "it's like you're telling the audience what
they should think/believe", "this is obvious, right?", and "what are you talking
about here? Just state plainly what you mean."

## Three species, all barred

### 1. Telling the reader what to think

The sentence instructs the audience in the attitude to take, or winks at a view
it assumes they hold.

"…with the exam at the end of it as the reason to bother." "From now on the
tools are permitted and expected on everything, which is what the syllabus has
said since August." "The grade is for the habit, which is the thing this course
is trying to install."

State the fact and stop. The reader forms the attitude.

### 2. Stating the obvious as an insight

The sentence restates what the room already knows, dressed as a conclusion.

"Everything you did in those five weeks was preparation for checking the tools."
"…and from tonight that ability is load bearing." "Anyone can fix an error once
someone points it out."

If every reader would nod before the sentence ends, cut it.

### 3. The flourish with nothing behind it

A phrase that sounds like a claim and has no content you could source, date, or
check, or a metaphor standing where the plain term would do.

"…measurement comes with obligations older than the tools by a century." (Which
obligations? Which century?) "Rules guide and hooks enforce." "…carrying weight
it has not earned." "Every placebo stayed quiet." "…a Belgian town nobody asked
about." Titles such as "The hinge", "The bargain", and "A join that refuses to
guess".

Say the specific thing. If there is no specific thing, the sentence goes.

## Three tests

Run them on every sentence a reader will see.

1. **The content test.** Write down the fact, instruction, or definition the
   sentence carries. If you cannot, cut the sentence.
2. **The nod test.** Would the whole audience agree before the sentence ends? If
   so it is telling them something they know, and it goes.
3. **The "what do you mean" test.** Imagine the reader asking "what are you
   talking about?" If the honest answer is a plainer sentence, write that one.

## Wrong → right (from real edits in this repo)

- *wrong:* "For five weeks you have written vector code, raster code, joins, and
  a georeference by hand, with the exam at the end of it as the reason to
  bother."
  *right:* "In Weeks 1--5 you wrote vector code, raster code, joins, and a
  georeference by hand. The lab exam covered that material."
- *wrong:* "That exam is over. From now on the tools are permitted and expected
  on everything, which is what the syllabus has said since August."
  *right:* "From tonight AI tools are permitted on all coursework, as the
  syllabus states."
- *wrong:* "Each of those is measurement, and measurement comes with obligations
  older than the tools by a century."
  *right:* "Each of these is a measurement, so the output has to be validated
  like any other measured variable."
- *wrong:* "Rules guide and hooks enforce."
  *right:* "The model can fail to follow a rule. It cannot skip a hook."
- *wrong:* "The flip warns that the exclusion restriction may be carrying weight
  it has not earned."
  *right:* "The flip suggests the exclusion restriction does not hold."
- *wrong:* "A model could write all three in seconds. … That part is yours."
  *right:* "A model can write the code for all three designs and run each
  diagnostic when asked. Choosing the diagnostic and deciding whether a failure
  matters require knowing the historical setting."
- *wrong (title):* "A join that refuses to guess"
  *right:* "Declaring the join one-to-one"
- *wrong:* "An exercise that rewards only a significant effect would teach the
  file-drawer problem."
  *right:* cut it. The instruction before it already said a failed instrument
  earns full marks.

## What this does not forbid

1. **Plain facts, instructions, and definitions,** however short. "A prompt is
   code. Without it nobody can reproduce the column."
2. **A stated consequence the reader needs.** "A unit within 2.7 kilometers of
   that edge could sit on either side of it." That is content.
3. **Questions put to the room and prediction prompts.** They ask; they do not
   instruct an attitude.
4. **Technical terms that began as metaphors.** "Sandbox", "pipeline", and
   "hook" are the names of things.

## Relation to the other writing rules

`state-it-plainly.md` bars the paper narrating itself. `affirmative-prose.md`
bars negation-first contrasts. `no-implied-predicate-titles.md` governs the
shape of headings. A sentence can pass all three and still fail this rule, as
most of the Week 6 examples did. Run this rule as its own pass, last, reading
only for whether each sentence informs.
