---
paths:
  - "Paper/**/*.tex"
  - "Figures/**/*.tex"
---

# TikZ Visual Quality Standards

**Every TikZ diagram used as a figure in the paper must be visually polished before it is considered complete.**

## Label Positioning

- Labels must NEVER overlap with curves, lines, dots, braces, or other labels
- When two labels are near the same vertical position, stagger them
- Group labels: right of final data point
- Axis labels: at arrow tips
- Annotation labels: adjacent to braces/arrows, outside data area
- Use consistent font size

## Visual Semantics

- **Solid dots/lines** = observed outcomes, realized paths
- **Hollow circles/dashed lines** = counterfactual outcomes, unrealized paths
- Use consistent colors for semantic meaning (positive, negative, neutral)
- Define colors in your LaTeX preamble (`Preambles/header.tex`) for reuse

### Line Weights
- Axes: `thick`
- Data lines: `thick`
- Annotation arrows: `thick` (NOT `very thick`)
- Grid/reference lines: `dashed, gray!40`

## Spacing and Proportions

- Standard scale: `[scale=1.1]` for text-width diagrams (size to `\textwidth`/`\columnwidth`)
- Dot radius: `4pt` for data points
- Minimum 0.2 units between any label and nearest graphical element
- Axes extend beyond all data points

## Checklist

```
[ ] No label-label overlaps
[ ] No label-curve overlaps
[ ] Consistent dot style (solid=observed, hollow=counterfactual)
[ ] Consistent line style (solid=observed, dashed=counterfactual)
[ ] Color semantics correct
[ ] Arrow annotations point FROM label TO feature
[ ] Axes extend beyond all data points
[ ] Labels legible at final print size (column/text width in the compiled PDF)
```

## Single Source of Truth

**The manuscript `.tex` source (or a standalone figure `.tex` in `Figures/`) is the authoritative source for each TikZ diagram.**
If a diagram is maintained both inline and as a standalone figure, edit one copy FIRST, then copy it verbatim to the other.
