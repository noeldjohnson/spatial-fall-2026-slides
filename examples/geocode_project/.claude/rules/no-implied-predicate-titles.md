# No Implied-Predicate Titles

Portable rule for all writing in this workflow. It governs section and
subsection headings, figure and table captions, panel labels, slide titles, and
any other display line. Copy this file into a new project's `.claude/rules/` and
reference it from that project's `CLAUDE.md`.

Added 18 September 2026 at Noel's direction.

---

## The device

A heading or caption built as a noun phrase that gestures at a claim without
stating it. The claim rides on a trailing participle, an appositive, or a second
noun phrase set beside the first, and the verb that would make the claim
assertable is left out.

Three shapes, all the same device.

- **Noun phrase, then a comma, then a participle or modifier.**
  "Four predictions, fixed in advance." "Witch print and executions, observed."
  "A false positive, removed." "The product plane, estimated."
- **Noun phrase with a bare participle attached.**
  "The puzzle resolved." "The valid measure applied."
- **Two noun phrases in apposition with no verb between them.**
  "One book, one hundred and thirty years." "One event, one summer."

Each implies a sentence it declines to write. The predictions *were* fixed in
advance. The puzzle *is* resolved. One book *stayed in print for* one hundred
and thirty years.

## Why it is barred

1. **It asserts without asserting.** A claim with no verb cannot be qualified,
   dated, sourced, or checked. "The puzzle resolved" commits the paper to a
   conclusion in a form that carries no evidence and admits no hedge, which is
   exactly the move a referee is entitled to object to.
2. **The compression buys style rather than information.** Each of these is
   slower to read and thinner in content than either honest alternative.
3. **The register is wrong.** This is the voice of the museum label, the
   magazine standfirst, and the exhibition catalog. A heading in a scientific
   paper should sound like the author, not the curator.
4. **It hides what the reader wants.** "One event, one summer" says nothing
   about what the section shows. "News of Münster reached seven cities within
   the year" says all of it.

## The rule

A title, heading, caption, or panel label is one of exactly two things.

- **A plain noun phrase that names its topic.** "Coercive news." "The codebook."
  "Reprint chains and surviving copies." "Persecutory titles by decade and
  target." These claim nothing and need no verb.
- **A complete sentence that states its finding.** "News crosses distance and
  stops at the language border." "Witch panics were regional waves that burned
  out." "Plague produced medicine, not persecution." These claim something and
  carry the verb that does it.

Nothing in between. If a heading needs a predicate to mean what you want it to
mean, write the predicate. If it does not, cut the participle and let the noun
phrase name the topic plainly.

The third sentence above needs a note, because `affirmative-prose.md` bars the
trailing "X, not Y" shape. It stands as a deliberate exception, approved by Noel
on 17 September 2026, under that rule's third exemption. The negated alternative
is the hypothesis this paper set out to test and failed to confirm, so naming it
corrects a stated claim rather than decorating one. No other trailing negation
inherits the exception.

## Wrong → right (from real edits in this repo)

- *wrong:* "Four predictions, fixed in advance"
  *right:* "Four predictions" — and the body says they were fixed before
  estimation, where the claim can be supported.
- *wrong:* "One book, one hundred and thirty years"
  *right:* "The reprint chain of the Malleus maleficarum"
- *wrong:* "One event, one summer"
  *right:* "The Münster news of 1535"
- *wrong:* "The valid measure applied"
  *right:* "Coercive news and subsequent trials"
- *wrong:* "The puzzle resolved"
  *right:* "What resolves the puzzle"
- *wrong:* "The product plane, estimated"
  *right:* "The estimated product plane"
  ("The product plane, with the estimates in place" fails the same test and is
  not a fix.)
- *wrong:* "The coercive-news registry, mapped"
  *right:* "The coercive-news registry on the map"
- *wrong:* "B. Witch print and executions, observed"
  *right:* "B. Witch print and executions in the data"

## What this does not forbid

1. **Coordinate lists of nouns.** "Durability, reach, and translation."
   "Durable products, hubs, and the puzzle." The commas separate topics rather
   than bolting a predicate onto one.
2. **A naming phrase with a date, a unit, or a source.** "Plague outbreaks,
   1450--1650." "Witch trials by town, from Leeson and Russ (2018)." The trailing
   element locates the object; it does not predicate anything of it.
3. **A caption that opens with a naming phrase and then explains in full
   sentences.** "The puzzle in one exhibit. Panel~A plots decade-level
   witch-hunting doctrine…" The opening names; the sentences assert.
4. **Genuine questions.** "Which firms?" "Who reported an event?" A question
   does its own work. Prefer the full interrogative where it is short.
5. **Specification and provenance notes in captions.** "City and year fixed
   effects, reference year $\tau = -1$, bands from the wider of the two standard
   errors. Estimates in Table 5." These record how an exhibit was made and where
   its numbers live. They predicate nothing of the finding, and rewriting them
   into sentences would bloat every caption in a paper for no gain. This is the
   most common trailing-participle form in an empirical manuscript, and it is
   permitted.

## How to check a heading

Ask whether the trailing element predicates something *about* the object or
merely locates it. Insert "is" or "was" in front of that element and read the
result.

- If the result is a substantive finding you would have to defend to a referee,
  the heading was making that claim silently. Write the predicate, or drop the
  claim.
- If the result only records a date, a source, a unit, a sample, or how the
  exhibit was drawn, the phrase is locating rather than asserting, and it stays.

"Four predictions *were* fixed in advance" is a claim about the research that a
referee could challenge, so the heading has to make it openly. "Witch trials by
town *are* from Leeson and Russ (2018)" only says where the data came from, so
the phrase may stand.
