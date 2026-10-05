# CLAUDE.MD -- Research Paper Project

**Paper:** Can a language model geocode historical place names? (ECON 895 teaching demo)
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
├── Preambles/header.tex         # LaTeX preamble and custom commands
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

<!-- Fill this in with your research project details -->

**Question:** How close are a language model's remembered coordinates for twenty historical European city names to a gazetteer's coordinates?

**Hypotheses:**
- H1: Most of the twenty fall within a few kilometers of the gazetteer.
- H2: The model's own confidence label tracks its error.

**Data strategy:** `Data/raw/llm_geocodes.csv` holds the model's answers, with the model, date and prompt in its header. `Data/raw/europe_cities_1801.csv` is the gazetteer and the gold standard. `Data/raw/README.md` gives the provenance of both. Neither file is edited.

**Geography/Context:** Towns in present-day Germany and Austria, as named in a gazetteer of European cities around 1801.

---

## Current Project State

| Component | Status | Notes |
|-----------|--------|-------|
| Research idea | Done | Stated above |
| Data collection | Done | Both files in `Data/raw/`, provenance in `Data/raw/README.md` |
| Validation script | Not started | Next step: `scripts/01_validate.R` |
| Results | Not started | Median and worst error, by confidence label |
| Paper draft | Not needed | This is a teaching demo |
