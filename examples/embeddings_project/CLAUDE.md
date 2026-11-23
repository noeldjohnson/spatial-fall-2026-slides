# CLAUDE.MD -- Research Paper Project

**Paper:** Word embeddings of early-modern English titles (ECON 895 teaching demo)
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

**Question.** How much do the nearest neighbors of a word, and the nearest titles to a
title, depend on the choices behind a word embedding? Build one baseline embedding of
early-modern English book titles and six variants, each changing one choice, and
compare what each finds.

**Data.** Everything is in `Data/raw/`, described in `Data/raw/README.md`. Raw files
are never edited. Derived objects go to `output/`. No scripts exist yet. Use
`quanteda` (version 4), `Matrix`, `RSpectra`, `word2vec`, and the tidyverse.

**Construction.** Follow these exactly and state any departure.

1. **Corpus.** Read `ustc_english_titles.csv` with `id` as character and `year` as
   integer. One title is one document, with `id` as the document name.
2. **Tokens.** `tokens(corpus, remove_punct = TRUE, remove_numbers = TRUE)`, then
   `tokens_tolower()`. These are the raw tokens. The baseline tokens are the raw
   tokens with `tokens_remove(stopwords("en"), padding = FALSE)`.
3. **One embedding, given tokens, a window w, a floor f, and k dimensions.**
   - Keep the words that occur at least f times: the feature names of
     `dfm_trim(dfm(tokens), min_termfreq = f)`, kept with
     `tokens_keep(tokens, those_words, padding = FALSE)`.
   - Co-occurrence: `fcm(kept_tokens, context = "window", window = w, tri = FALSE)`.
   - PPMI: for every nonzero cell, `log(n_ij * N / (r_i * c_j))`, where N is the sum
     of the whole matrix and r and c are its row and column sums. Keep only the
     positive values, as a sparse matrix of the same dimensions.
   - SVD: `RSpectra::svds(PPMI, k)`. It returns the singular values unsorted, so
     order them from largest to smallest and order the columns of `u` the same way.
   - Word vectors: the rows of the ordered `u`, each normalized to length one.
4. **Baseline.** Baseline tokens, w = 5, f = 20, k = 200.
5. **Variants, each changing one thing.** Stop words kept (the raw tokens); w = 2;
   w = 10; k = 50; f = 5. Then word2vec twice: `set.seed(20261116)` and
   `set.seed(20261117)` before each run, with
   `word2vec(x, type = "skip-gram", dim = 200, window = 5, iter = 10,
   min_count = 20, threads = 4, split = c(" \n", "\n"))`, where x has one element
   per title, the baseline tokens pasted together with single spaces. Normalize its
   word vectors to length one.
6. **Neighbors.** For the seeds church, warre, plague, pope, and london, list the ten
   words with the highest cosine to the seed, excluding the seed, under every run.
   For each variant and seed, count how many of its ten are in the baseline's ten.
   Also count the overlap between the two word2vec runs.
7. **Title vectors.** From the dfm of the baseline tokens, keep the words in the
   embedding's vocabulary. Let p(w) be each word's share of all kept tokens and give
   it the weight `0.001 / (0.001 + p(w))`. A title's vector is the sum over its
   tokens of weight times the word's unit vector. Drop titles with no kept words.
   Remove the first principal direction, `svd(X, nu = 0, nv = 1)$v`, from every
   title vector.
8. **Nearest titles.** Normalize the title vectors to length one and report the five
   titles with the highest cosine to the title with `id` 89060 (Lord haue mercy vpon vs. A
   speciall remedy for the plague, London, 1636), with year, place, and cosine, excluding
   the title itself. Do this for the baseline and for the w = 2 embedding.
9. **Output.** Print every table above and save them in one list to
   `output/wk11_results.rds`.
