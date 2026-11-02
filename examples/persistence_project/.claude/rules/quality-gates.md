---
paths:
  - "Paper/**/*.tex"
  - "scripts/**/*.R"
---

# Quality Gates & Scoring Rubrics

## Thresholds

- **80/100 = Commit** -- good enough to save
- **90/100 = PR** -- ready for review
- **95/100 = Excellence** -- submission-ready

## LaTeX Manuscript (.tex)

| Severity | Issue | Deduction |
|----------|-------|-----------|
| Critical | XeLaTeX compilation failure | -100 |
| Critical | Undefined citation | -15 |
| Critical | Overfull hbox > 10pt | -10 |
| Critical | Typo in equation | -10 |
| Major | Broken cross-reference | -5 |
| Major | Notation inconsistency | -3 |
| Major | Missing figure/table reference | -5 |
| Minor | Long lines (>100 chars) | -1 (EXCEPT documented math formulas) |
| Minor | Inconsistent formatting | -1 |

## R Scripts (.R)

| Severity | Issue | Deduction |
|----------|-------|-----------|
| Critical | Syntax errors | -100 |
| Critical | Domain-specific bugs | -30 |
| Critical | Hardcoded absolute paths | -20 |
| Major | Missing set.seed() | -10 |
| Major | Missing figure generation | -5 |

## Enforcement

- **Score < 80:** Block commit. List blocking issues.
- **Score < 90:** Allow commit, warn. List recommendations.
- User can override with justification.

## Quality Reports

Generated **only at merge time**. Use `templates/quality-report.md` for format.
Save to `quality_reports/merges/YYYY-MM-DD_[branch-name].md`.

## Tolerance Thresholds (Econometric Research)

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| Point estimates | 1e-6 | Numerical precision |
| Standard errors | 1e-4 | MC variability |
| Coverage rates | +/- 0.02 | MC with B reps |
| Wage coefficients | Context-dependent | Compare to literature benchmarks |
