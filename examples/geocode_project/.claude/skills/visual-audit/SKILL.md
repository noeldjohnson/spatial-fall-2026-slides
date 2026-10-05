---
name: visual-audit
description: Perform an adversarial layout/typesetting audit of the LaTeX manuscript checking for overfull boxes, table/figure sizing, float placement, and page-break problems.
argument-hint: "[TEX filename, defaults to main]"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Bash", "Task"]
---

# Layout Audit of the Manuscript

Perform a thorough layout and typesetting audit of the compiled paper.

## Steps

1. **Identify the file** specified in `$ARGUMENTS` (defaults to `Paper/main.tex`).

2. **Compile so there is a fresh log to inspect** (see `/compile-latex`):
   ```bash
   cd Paper && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex >/dev/null 2>&1
   ```
   Then read `Paper/main.log` for concrete warnings.

3. **Launch the slide-auditor agent** (the layout/typesetting auditor) on the manuscript, or audit directly for:

   **OVERFULL / UNDERFULL BOXES:** `Overfull \hbox` (esp. > 5pt), display math that should break, un-hyphenatable terms
   **TABLE LAYOUT:** Tables wider than `\textwidth` (need `\resizebox`/`\small`/`booktabs`), rows split across pages, misaligned decimals
   **FIGURE LAYOUT:** Figures over-wide or scaled illegibly small, raster where vector (PDF) is expected, missing `\centering`, caption placement
   **FLOAT PLACEMENT:** Floats drifting far from their `\ref`, float clumps, rigid `[h]`/`[H]` causing whitespace gaps
   **PAGE BREAKS:** Widows/orphans, headings stranded at page bottom, equations split across pages
   **REFERENCES:** `??` from unresolved `\ref`, numbering gaps

4. **Produce a report** organized by issue with severity and a specific recommendation, citing the exact `main.log` line where one exists.

5. **Follow the fix-priority principle:**
   1. Fix the structure (break an equation, switch to `booktabs`, adjust the float specifier)
   2. Resize the table/figure to `\textwidth`/`\columnwidth`
   3. Prefer `[tbp]` float placement over forcing `[H]`
   4. Use `\resizebox` for a genuinely wide table
   5. Last resort: reduce font size (`\small`, within journal limits) or add manual spacing
