---
paths:
  - "Paper/**/*.tex"
  - "scripts/**/*.R"
  - "Figures/**/*"
  - "Tables/**/*"
---

# Task Completion Verification Protocol

**At the end of EVERY task, Claude MUST verify the output works correctly.** This is non-negotiable.

## For LaTeX Manuscript:
1. Compile with xelatex (3-pass + bibtex) and check for errors
2. Open the PDF to verify figures and tables render
3. Check for overfull hbox warnings
4. Verify all citations resolve (no "?" in output)
5. Report verification results

## For R Scripts:
1. Run `Rscript scripts/filename.R`
2. Verify output files (PDF, RDS, .tex tables) were created with non-zero size
3. Spot-check estimates for reasonable magnitude
4. Verify figures have correct dimensions and transparent backgrounds

## For TikZ Diagrams:
1. Compile TikZ source to PDF
2. Verify PDF contains expected diagram
3. Check labels, positioning, and visual clarity

## Common Pitfalls:
- **Missing packages**: Ensure all LaTeX packages are in preamble
- **Relative paths**: `../Figures/` works from `Paper/` -- verify paths resolve
- **Assuming success**: Always verify output files exist AND contain correct content
- **Stale outputs**: If R script changed, re-run before compiling paper

## Verification Checklist:
```
[ ] Output file created successfully
[ ] No compilation/render errors
[ ] Figures/tables display correctly
[ ] Citations resolve (no undefined references)
[ ] Reported results to user
```
