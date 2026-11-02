# CLAUDE.MD -- Research Paper Project

**Paper:** Spatial noise and the standard errors of a persistence regression (ECON 895 teaching demo)
**Author:** Noel D. Johnson
**Institution:** George Mason University
**Branch:** main

---

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** -- compile/render and confirm output at the end of every task
- **Single source of truth** -- LaTeX manuscript in `Paper/` is authoritative
- **Quality gates** -- nothing ships below 80/100
- **[LEARN] tags** -- when corrected, save `[LEARN:category] wrong -> right` to MEMORY.md

---

## Folder Structure

```
[YOUR_PROJECT]/
├── CLAUDE.md                    # This file
├── .claude/                     # Rules, skills, agents, hooks
├── Bibliography_base.bib        # Centralized bibliography
├── Paper/                       # LaTeX manuscript
│   ├── main.tex                 # Main document (inputs sections)
│   └── sections/                # Modular .tex sections
├── Preambles/                   # House-style preambles
│   ├── header.tex               # Paper preamble and custom commands
│   └── beamer-header.tex        # Beamer preamble for talks
├── Slides/                      # Slide decks (example_talk.tex shows each layout)
├── Figures/                     # Figures (TikZ, R output, external)
├── Tables/                      # .tex tables from R analysis
├── Data/                        # Research data
│   ├── raw/                     # Original source data
│   └── processed/               # Cleaned/transformed data
├── output/                      # R analysis output (RDS, diagnostics)
├── notes/                       # Research notes (Markdown)
├── scripts/                     # R scripts and utilities
├── explorations/                # Research sandbox
├── quality_reports/             # Plans, session logs, merge reports
├── templates/                   # Templates for notes, logs, reports
├── master_supporting_docs/      # Reference papers and materials
└── .archive/                    # Archived content
```

---

## Commands

```bash
# LaTeX compilation (3-pass, XeLaTeX)
cd Paper && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex
BIBINPUTS=..:$BIBINPUTS bibtex main
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex

# Slide deck (XeLaTeX, from Slides/)
cd Slides && xelatex -interaction=nonstopmode example_talk.tex

# Run R analysis
Rscript scripts/analysis_name.R

# Quality score
python3 scripts/quality_score.py Paper/main.tex
```

---

## Quality Thresholds

| Score | Gate | Meaning |
|-------|------|---------|
| 80 | Commit | Good enough to save |
| 90 | PR | Ready for review |
| 95 | Excellence | Submission-ready |

---

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| `/compile-latex [file]` | 3-pass XeLaTeX + bibtex |
| `/proofread [file]` | Grammar/typo/overflow review |
| `/validate-bib` | Cross-reference citations |
| `/review-paper [file]` | Manuscript review (argument, methods, citations) |
| `/pedagogy-review [file]` | Exposition & writing-flow review (narrative, motivation, notation) |
| `/lit-review [topic]` | Literature search + synthesis |
| `/research-ideation [topic]` | Research questions + strategies |
| `/interview-me [topic]` | Interactive research interview |
| `/data-analysis [dataset]` | End-to-end R analysis |
| `/review-r [file]` | R code quality review |
| `/devils-advocate` | Challenge methodology/arguments |
| `/commit [msg]` | Stage, commit, PR |
| `/visual-audit [file]` | Figure/table layout audit |
| `/extract-tikz [file]` | TikZ -> PDF for paper figures |

---

## Research Summary

**Question.** Week 2 regressed a city's adoption of the printing press by 1500
on its distance from Mainz and found a t statistic above 5. Both sides of that
regression are maps. Conley and Kelly (2025) show that regressing one smooth map
on another produces t statistics of that size from pure noise unless the
standard errors allow for spatial correlation. This project runs their
diagnostics on the Week 2 regression.

**Data.** Everything is in `Data/raw/`, described in `Data/raw/README.md`. Raw
files are never edited. Derived R objects go to `output/` and derived CSVs to
`Data/processed/`. No scripts exist yet.

**Construction.** Follow these exactly and state any departure.

1. **The Week 2 sample.** Read `europe_cities_1801.csv`, drop the cities named
   ALBA and HALLE (each name belongs to two cities), and join
   `europe_press_1500.csv` on `city_jjk` one to one. Keep cities with `pop1500`
   and `pop1600` both positive. That is 744 cities. Define `press1500` as 1 if
   `print_date` is not missing and is at most 1500, else 0.
2. **Projection and distance.** Make points from `longitude` and `latitude`
   (EPSG:4326) and transform to the equidistant conic for Europe,
   `+proj=eqdc +lat_0=0 +lon_0=0 +lat_1=43 +lat_2=62 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs`.
   `km_mainz` is the distance in kilometers from each city to the city named
   MAINZ. Keep the projected coordinates in kilometers as `x` and `y`.
3. **The regression.** `press1500 ~ km_mainz + log(pop1500)` by ordinary least
   squares. Report the coefficient on `km_mainz` and its t statistic under five
   standard errors:
   - HC1 (`sandwich::vcovHC`, type HC1);
   - Conley with a 300 km cutoff and a uniform kernel (`conleyreg::conleyreg`
     with `lat = "latitude"`, `lon = "longitude"`, `dist_cutoff = 300`,
     `kernel = "uniform"`);
   - clustered by `countryname` (`sandwich::vcovCL`, type HC1);
   - clustered by six and by four k-medoids clusters of the projected
     coordinates (`cluster::pam` on the `x`, `y` matrix, then `vcovCL`).
   Report the five t statistics in one row. Then add a quadratic in `x` and `y`
   (`poly(x, 2) + poly(y, 2)`) to the regression and report the same row again.
4. **The spatial-noise placebo.** Build the 744 by 744 matrix of distances
   between cities in kilometers. Set the seed to 20261102. Draw 500 synthetic
   treatments, each a vector of 744 values from a Gaussian process with
   covariance `0.9 * exp(-d / 150) + 0.1 * I`, where `d` is the distance matrix,
   using the Cholesky factor of that matrix times a standard normal vector. For
   each draw, replace `km_mainz` with the synthetic treatment in the regression
   of step 3 and record the five t statistics, with and without the quadratic
   trend. Do not alter the outcome.
5. **What to report from the placebo.** For the regression without the trend
   and HC1 standard errors: the share of the 500 draws with |t| above 1.96,
   above 3, and above 4, the largest |t|, the 95th percentile of |t|, and the
   share of draws whose |t| is at least the real one from step 3. Then a table
   of the share of draws rejecting at 5 percent under each of the five standard
   errors, with and without the trend. Use 1.96 for HC1 and Conley, and the t
   critical value with G minus 1 degrees of freedom for the clustered ones,
   where G is the number of clusters.
6. **Output.** `Data/processed/placebo_t.csv` with one row per draw and one
   column per standard error and specification, and the two summary tables
   printed to the console and saved as `output/wk09_summary.rds`.
