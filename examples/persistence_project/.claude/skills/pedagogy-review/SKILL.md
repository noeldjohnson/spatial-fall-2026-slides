---
name: pedagogy-review
description: Run holistic exposition and writing-flow review on the manuscript. Checks narrative arc, motivation, notation clarity, section pacing, and reader onboarding.
argument-hint: "[TEX filename, defaults to the whole manuscript]"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Task"]
---

# Exposition Review of the Manuscript

Perform a comprehensive exposition and writing-flow review — does the paper motivate, signpost, and read clearly?

## Steps

1. **Identify the file(s)** specified in `$ARGUMENTS`
   - If no argument, review the whole manuscript: `Paper/main.tex` and every section it inputs from `Paper/sections/`
   - If a specific section file is named, review that section in the context of the whole

2. **Launch the pedagogy-reviewer agent** with the file path(s)
   - The agent checks 12 exposition patterns (motivation-before-formalism, roadmap/signposting, results-framed-not-dumped, anticipating objections, notation consistency, conclusion-closes-the-loop, etc.)
   - Performs manuscript-level analysis (narrative arc, pacing/balance, flow between sections, reader onboarding)

3. **The agent produces a report** saved to:
   `quality_reports/[FILENAME_WITHOUT_EXT]_pedagogy_report.md`

4. **Present summary to user:**
   - Patterns followed vs violated (out of 12)
   - Manuscript-level assessments
   - Critical recommendations (top 3-5)

## Important Notes

- This is a **read-only review** — no files are edited
- Focuses on **exposition and clarity**, not correctness (use `/review-paper` or the domain-reviewer for substance) or layout (use `/visual-audit`)
