# CLAUDE.MD -- Research Paper Project

**Paper:** Surfaces from points and from satellites (ECON 895 teaching demo)
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

**Question.** Two ways to get a value for every place. First, from points you
observed: Black Death mortality is recorded for 274 European cities, and we want
a value for all 1,797 cities in the gazetteer. Second, from above: nighttime
lights measured by satellite for every square kilometer of Africa, summed by
country and divided by population.

**Data.** Everything is in `Data/raw/`, described in `Data/raw/README.md`. Raw
files are never edited. Derived R objects go to `output/` and derived CSVs to
`Data/processed/`. No scripts exist yet.

**Construction, part 1: interpolating mortality.** Follow these exactly and
state any departure.

1. **Points.** `mort274.csv` has 274 cities with `mortality`, the share of the
   population that died in the Black Death, in percent. Targets are the cities in
   `europe_cities_1801.csv` after dropping ALBA and HALLE, each of which names two
   different cities. Make points from `longitude` and `latitude` (EPSG:4326).
2. **Project CRS.** Distances are measured in the equidistant conic for Europe,
   `+proj=eqdc +lat_0=0 +lon_0=0 +lat_1=43 +lat_2=62 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs`.
   Transform both point sets to it before any distance is computed. Never
   interpolate on longitude and latitude.
3. **Inverse distance weighting.** Use `gstat::idw` with the formula
   `mortality ~ 1`. The power `idp` is chosen by leave-one-out cross-validation
   over the grid 0.5, 0.75, ..., 4: for each power, predict each of the 274
   cities from the other 273 and compute the root mean squared error. Report
   the whole curve and use the power with the smallest error.
4. **Nearest point.** As a comparison, assign each target the mortality of the
   nearest observed city (`sf::st_nearest_feature`). Compute its leave-one-out
   root mean squared error the same way, and the error of predicting the sample
   mean for every city.
5. **Output.** `Data/processed/mortality_interpolated.csv` with `city_jjk`,
   `countryname`, `longitude`, `latitude`, `mort_idw`, `mort_nearest`, and
   `observed` (TRUE for the 274 cities themselves). A city in the observed set
   gets its own value under both methods.

**Construction, part 2: night lights.**

6. **Rasters.** `africa_lights_2000.tif` is the DMSP-OLS stable lights composite
   for 2000 (satellite F15), 30 arc-second cells, digital number 0 to 63, where
   63 is the sensor's ceiling. `africa_popdens_2000.tif` is GPW v3 population
   density for 2000 in persons per square kilometer, 2.5 arc-minute cells. Both
   are in EPSG:4326 and both are used in that CRS.
7. **Countries.** `africa_scale.shp`, 51 countries, column `admin` for the name.
8. **Lights by country.** Sum the digital numbers of all cells in each country
   (`terra::extract` with `fun = "sum"`). Also report the share of each
   country's cells with a value above 0 and the share of its summed digital
   number that comes from cells at 63.
9. **Population by country.** Multiply density by the area of each cell in
   square kilometers (`terra::cellSize`) before summing. Density summed without
   the area is a count of nothing.
10. **Output.** `Data/processed/lights_by_country.csv` with `country`,
    `sum_dn`, `lit_share`, `top_coded_share`, `population`, and
    `dn_per_1000`, the summed digital number per thousand people.

**Geography/Context.** Europe 1347--1352 and Africa in 2000.

---

## Current Project State

| Component | Status | Notes |
|-----------|--------|-------|
| Data | done | `Data/raw/` |
| Mortality interpolation | open | |
| Lights by country | open | |
| Paper draft | not started | |
