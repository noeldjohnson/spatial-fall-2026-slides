# Affirmative Prose (No Negation-First Contrasts)

Portable rule for all writing in this workflow. It applies to slides, syllabus
and assignment prose, emails, documentation, commit messages, and code comments,
in both registers, manuscript and terse. Copy this file into a new project's
`.claude/rules/` and reference it from that project's `CLAUDE.md`.

Added 14 September 2026 at Noel's direction.

---

## The rule

Avoid contrastive constructions that introduce an idea by first negating another
idea, especially formulations such as "It's not X, it's Y," "This isn't about X;
it's about Y," or "The goal is not X but Y." State the intended point directly
and affirmatively instead.

More generally, avoid setting up unnecessary binary contrasts as a rhetorical
device. When revising, check for sentences that define a point by saying what it
is not before saying what it is, and rewrite them to lead with the substantive
claim.

## Wrong → right (from real edits in this repo)

- *wrong:* "There the boundary is not the design. It is the dependent variable."
  *right:* "There the boundary is the dependent variable."
- *wrong:* "You did not want the region. You wanted its edge."
  *right:* "The object you wanted is the edge."
- *wrong:* "This is not a style preference; absolute paths are the most common
  reason code fails on another machine."
  *right:* "Absolute paths are the most common reason code fails on another
  machine."
- *wrong (trailing appositive):* "That is a claim about what you are estimating,
  not a technicality."
  *right:* "That is a claim about what you are estimating."

The trailing form ("X, not Y") is the same device turned around. If the sentence
already makes the affirmative claim, the appended negation is decoration; cut it.

## What this rule does not forbid

Three kinds of negation carry content rather than rhetoric and stay.

1. **Negative facts.** When the absence is the point, the sentence is
   affirmatively about that absence. "Anything you compute per area afterwards
   is wrong for that district, and nothing warned you." "The assumption itself
   is not testable." "sf prints a message, not a warning, and it scrolls past."
2. **Safety and workflow instructions.** "Do not rerun this block after slide
   22." "Never hand-edit generated artifacts." An instruction against an action
   is the instruction.
3. **Correcting a stated claim.** When a specific belief has actually been
   voiced — a student's prediction, a published error, a claim being refereed —
   name it and correct it. Even then, lead with the true claim where the
   sentence allows: "Zero, and zero is correct," rather than "Zero, and it is
   not a bug."

When a contrast is genuinely load-bearing (two estimators, two projections, two
samples), state both sides affirmatively and lead with the one you are
asserting. "Weighted estimates the effect on the average child; unweighted, on
the average district" needs no negation at all.
