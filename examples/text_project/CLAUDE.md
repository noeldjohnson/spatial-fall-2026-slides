# CLAUDE.MD -- Research Paper Project

**Paper:** Two preprocessing pipelines for early-modern English titles (ECON 895 teaching demo)
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

**Question.** How much of what a document-term matrix says about early-modern
English printing is decided by the preprocessing? Build two defensible pipelines on
the same corpus and compare what each one finds.

**Data.** Everything is in `Data/raw/`, described in `Data/raw/README.md`. Raw files
are never edited. Derived objects go to `output/` and derived CSVs to
`Data/processed/`. No scripts exist yet. Use the `quanteda` package (version 4),
`topicmodels`, `Matrix`, and the tidyverse.

**Construction.** Follow these exactly and state any departure.

1. **Corpus.** Read `ustc_english_titles.csv` with `id` as character and `year` as
   integer. One title is one document, with `id` as the document name. Add
   `decade = 10 * (year %/% 10)`.
2. **Tokens.** `tokens(corpus, remove_punct = TRUE, remove_numbers = TRUE,
   remove_symbols = TRUE)`, then `tokens_tolower()`. These are the raw tokens.
3. **Pipeline A, the default.** From the raw tokens: remove `stopwords("en")`; make
   a dfm; `dfm_trim(min_docfreq = 5)`. No stemming, unigrams only.
4. **Pipeline B, the early-modern pipeline.** From the raw tokens: apply the rules in
   `spelling_rules.csv` in order to every token type with `gsub(pattern,
   replacement, perl = TRUE)` and replace the changed types with
   `tokens_replace(..., valuetype = "fixed")`; remove the words in
   `stopwords_early_modern.txt` (skip lines starting with `#`);
   `tokens_wordstem(language = "english")`; `tokens_ngrams(n = 1:2, concatenator =
   "_")`; make a dfm; `dfm_trim(min_docfreq = 5)`.
5. **Matrix size.** For each pipeline report the number of documents, the number of
   terms, the number of nonzero cells, and the nonzero share.
6. **tf-idf by decade.** For each pipeline, keep decades from 1470 on, aggregate the
   counts to decades with `dfm_group(groups = decade)`, and apply `dfm_tfidf()` with
   its defaults. A decade is now the document. Report the ten terms with the highest
   tf-idf for the 1590s, the 1610s, and the 1640s.
7. **Cosine between decades.** On the decade tf-idf matrix, normalize each row to
   unit length and report the cosine between the 1590s and the 1600s, the 1590s and
   the 1640s, and the 1630s and the 1640s.
8. **Nearest titles.** On the title-level matrix, apply `dfm_tfidf()`, normalize each
   row to unit length, and report the five titles with the highest cosine to the
   title with `id` 642649 (A true relation of the taking of Newcastle by assault,
   1644), with their year and cosine, excluding the title itself.
9. **Dictionaries.** Two dictionaries, matched with `dfm_lookup(valuetype = "glob")`
   on the dfm of the raw tokens for pipeline A and of the spelling-normalized tokens
   (before stopword removal and stemming) for pipeline B:
   - religious conflict: heresy, heresie, heretic\*, heretick\*, papist\*, popish,
     popery, schism\*, sect, sects, blasphem\*, antichrist\*, idolatr\*
   - war and news: battle\*, battaile\*, siege, victory, victorie, relation, letter,
     letters, news, newes, army, armie, souldier\*, soldier\*
   Report, by decade from 1500, the share of titles with at least one match.
10. **Topics.** `set.seed(20261109)`, then draw 5,000 document names at random from
    pipeline A's dfm with `sample()`. For each pipeline, subset to those titles, drop
    titles with no tokens left, convert with `convert(to = "topicmodels")`, and fit
    `LDA(k = 8, method = "Gibbs", control = list(seed = 20261109, iter = 500,
    burnin = 100))`. Report the top eight terms of each topic.
11. **Output.** Print every table above, and save them in one list to
    `output/wk10_results.rds`.
