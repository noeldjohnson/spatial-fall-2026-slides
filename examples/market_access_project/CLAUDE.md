# CLAUDE.MD -- Research Paper Project

**Paper:** Market access in early modern Europe from a cost surface (ECON 895 teaching demo)
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

**Question:** How much market access did each of about a thousand European cities
have in 1500 and in 1800, when distance is measured as the least-cost route over
roads, rivers, and seas?

**Data.** Everything is in `Data/raw/`, described in `Data/raw/README.md`. Raw files
are never edited. Derived R objects go to `output/` and derived CSVs to
`Data/processed/`. No scripts exist yet.

**Construction.** These choices fix the numbers. Follow them exactly and state any
departure.

1. **Cities.** Read `europe_cities_1801.csv` and drop ALBA and HALLE, each of which
   names two different cities. Join `europe_press_1500.csv` on `city_jjk`, keeping
   cities in both, and declare the join one-to-one. Make points from `longitude` and
   `latitude` (EPSG:4326) and transform to the project CRS.
2. **Project CRS.** The equidistant conic for Europe,
   `+proj=eqdc +lat_0=0 +lon_0=0 +lat_1=43 +lat_2=62 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs`.
   The four GeoPackages are already in it.
3. **Grid.** 50 km cells covering the cities' bounding box plus one cell on every
   side, with cell edges on multiples of 50,000 m.
4. **Cost of each cell.** Overland is 1. A cell crossed by a Roman road or medieval
   route costs 0.81, by a river 0.21, and by sea 0.08. A cell counts as crossed if the
   line or polygon touches it at all. Each cell takes the cheapest mode that crosses it.
5. **Least-cost distance.** Use `gdistance`. Each cell connects to its eight
   neighbors, the conductance of a step is 1 over the mean of the two cells' costs,
   corrected for the distance between cell centers (`geoCorrection(type = "c")`).
   Report distances in km-equivalents, the cost divided by 1,000.
6. **Cities in the same cell** have a least-cost distance of zero. Set each such pair
   to half a cell at that cell's own cost, so 25 on land and 2 at sea. A city's
   distance to itself stays zero.
7. **Market access.** MA_i is the sum over every other city j of pop_j / tau_ij^theta,
   with theta = 1 as in Johnson and Koyama (2017). Cities with a missing or zero
   population in that year contribute nothing but still get a value. Populations are
   `pop1500` to `pop1800`.

**Geography/Context:** Europe, 1,017 cities with populations in 1500 to 1800.

---

## Current Project State

| Component | Status | Notes |
|-----------|--------|-------|
| Data | done | four network layers, gazetteer, populations in `Data/raw/` |
| Cost surface and least-cost matrix | open | |
| Market access 1500, 1800 | open | |
| Counterfactuals | open | |
| Paper draft | not started | |
