---
name: devils-advocate
description: Challenge the manuscript's argument and identification with 5-7 tough referee-style questions. Checks logic, assumptions, robustness, and framing.
disable-model-invocation: true
argument-hint: "[section filename or 'all']"
allowed-tools: ["Read", "Grep", "Glob"]
---

# Devil's Advocate Review

Critically examine the manuscript and challenge it with 5-7 specific, tough questions — the ones a skeptical referee or seminar attendee would raise.

**Philosophy:** "We arrive at the strongest possible paper through active dialogue."

---

## Setup

1. **Read the target** — the section named in `$ARGUMENTS`, or the whole manuscript (`Paper/main.tex` + `Paper/sections/`) if `all`
2. **Read the knowledge base** in `.claude/rules/` for notation conventions and the paper's claims
3. Read the relevant `Tables/` and `Figures/` so challenges reference the actual evidence

---

## Challenge Categories

Generate 5-7 challenges from these categories:

### 1. Identification Challenges
> "Why is this variation exogenous? What's the most plausible confounder you haven't ruled out?"

### 2. Assumption Challenges
> "This result leans on assumption X. What happens if it fails, and how would we know?"

### 3. Robustness Challenges
> "Would this survive a different sample, specification, or clustering choice? Where's the placebo/pre-trend test?"

### 4. Alternative-Explanation Challenges
> "Could mechanism Y produce the same pattern? How do you distinguish your story from it?"

### 5. Magnitude & Interpretation Challenges
> "Is the estimate economically/scientifically meaningful, or just significant? Does the magnitude pass a smell test?"

### 6. Framing & Contribution Challenges
> "What exactly is new here relative to [related work]? A referee will ask — is the answer convincing?"

### 7. External-Validity Challenges
> "To what population/setting does this generalize, and what in the design limits that?"

---

## Output Format

```markdown
# Devil's Advocate: [Paper / Section Title]

## Challenges

### Challenge 1: [Category] — [Short title]
**Question:** [The specific tough question]
**Why it matters:** [What could go wrong / why a referee cares]
**Suggested resolution:** [Specific analysis, test, or revision]
**Location:** [Section / table / figure affected]
**Severity:** [High / Medium / Low]

[Repeat for 5-7 challenges]

## Summary Verdict
**Strengths:** [2-3 things done well]
**Critical changes:** [0-2 changes needed before submission]
**Suggested improvements:** [2-3 nice-to-have changes]
```

---

## Principles

- **Be specific:** Reference exact sections, tables, and equations
- **Be constructive:** Every challenge has a suggested resolution
- **Be honest:** If the argument is strong, say so
- **Prioritize:** Identification threats > framing quibbles
- **Think like a referee at a top journal:** Where would they push hardest?
