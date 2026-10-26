# Research Workflow Template

A Claude Code-powered workflow for academic research papers. Clone this repo to start a new project with a full suite of AI-assisted tools for writing, analysis, and quality control.

---

## Quick Start

### 1. Clone for a new project

```bash
git clone https://github.com/noeldjohnson/research-workflow-template_shared.git my-new-paper
cd my-new-paper
rm -rf .git && git init  # fresh git history
```

Claude Code runs the hooks in `.claude/hooks/` on your machine, so read `.claude/settings.json` and the hooks before the first session.

### 2. Fill in CLAUDE.md

Open `CLAUDE.md` and replace all `[PLACEHOLDERS]`:
- Paper title, author, institution
- Research summary (question, hypotheses, data strategy)
- Update the project state table as you work

### 3. Set up your LaTeX preamble

Edit `Preambles/header.tex`:
- Add project-specific notation (e.g., `\newcommand{\treat}{T}`)
- Adjust font if needed (default: Times New Roman, requires XeLaTeX)

The preamble implements the house style documented in `.claude/rules/latex-formatting.md`. That is 12pt Times New Roman, one-inch margins, 1.5 line spacing, AER author-year citations, and booktabs tables. For talks, `Preambles/beamer-header.tex` is the matching Beamer preamble, and `Slides/example_talk.tex` (compiled as `Slides/example_talk.pdf`) shows each slide layout.

### 4. Add bibliography entries

Edit `Bibliography_base.bib` with your references. Follow the naming convention: `AuthorYear_keyword`.

### 5. Compile to verify

```bash
cd Paper
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex
```

You should get a clean PDF with placeholder section headings.

### 6. Start working

Open Claude Code in the project directory and begin. The workflow, skills, and agents are ready to go.

---

## What's Included

### Folder Structure

| Directory | Purpose |
|-----------|---------|
| `Paper/` | LaTeX manuscript (`main.tex` + modular `sections/`) |
| `Preambles/` | House-style preambles for the paper (`header.tex`) and for talks (`beamer-header.tex`) |
| `Slides/` | Slide decks, with `example_talk.tex` as a worked example of the deck style |
| `Figures/` | Figures (TikZ, R output, external) |
| `Tables/` | `.tex` tables from R analysis |
| `Data/raw/` | Original source data (never modify) |
| `Data/processed/` | Cleaned/transformed data |
| `output/` | R analysis output (RDS, diagnostics) |
| `scripts/` | R scripts, Python utilities |
| `notes/` | Research notes (Markdown) |
| `explorations/` | Research sandbox (lower quality bar) |
| `quality_reports/` | Plans, session logs, specs, merge reports |
| `templates/` | Templates for notes, logs, reports |
| `master_supporting_docs/` | Reference papers and slides |

### Skills (Slash Commands)

| Command | What It Does |
|---------|-------------|
| `/compile-latex` | 3-pass XeLaTeX + bibtex |
| `/proofread` | Grammar, typos, overflow review |
| `/validate-bib` | Cross-reference citations |
| `/review-paper` | Manuscript review (argument, methods, citations) |
| `/lit-review` | Literature search and synthesis |
| `/research-ideation` | Research questions and strategies |
| `/interview-me` | Interactive research interview |
| `/data-analysis` | End-to-end R analysis |
| `/review-r` | R code quality review |
| `/devils-advocate` | Challenge methodology and arguments |
| `/commit` | Stage, commit, PR |
| `/visual-audit` | Figure/table layout audit |

### Agents (Run Automatically)

| Agent | Role |
|-------|------|
| Proofreader | Grammar, typos, academic writing quality |
| Domain Reviewer | Substantive review (customize for your field) |
| R Reviewer | R code quality and reproducibility |
| TikZ Reviewer | Diagram quality and consistency |
| Verifier | End-to-end compilation and rendering |

### Rules (Always Active)

- **Plan-first workflow** -- plan before non-trivial tasks
- **Orchestrator protocol** -- autonomous implement-verify-review-fix loop
- **Quality gates** -- 80/90/95 scoring thresholds
- **Session logging** -- capture decisions and context for continuity
- **Single source of truth** -- LaTeX manuscript is authoritative

### Hooks (Lifecycle Automation)

- **Pre-compact** -- saves context before auto-compression
- **Post-compact** -- restores context after compression
- **Context monitor** -- warns at 40/55/65/80/90% context usage
- **Protect files** -- prevents accidental edits to bibliography, settings
- **Verify reminder** -- prompts verification after file edits

### Templates

| Template | Purpose |
|----------|---------|
| `session-log.md` | Structured session documentation |
| `quality-report.md` | Merge-time quality assessment |
| `requirements-spec.md` | MUST/SHOULD/MAY requirements |
| `literature-note.md` | Paper reading notes |
| `research-log.md` | Research progress tracking |
| `constitutional-governance.md` | Define project non-negotiables |
| `skill-template.md` | Create new domain-specific skills |
| `exploration-readme.md` | Document experimental work |

---

## Workflow Overview

```
1. PLAN    -- Enter plan mode for non-trivial tasks
2. EXECUTE -- Orchestrator implements, verifies, reviews
3. FIX     -- Address issues found in review (up to 5 rounds)
4. SCORE   -- Quality gates: >= 80 to commit, >= 90 for PR
5. REPORT  -- Summary of what was done and what's next
```

### Quality Gates

| Score | Meaning |
|-------|---------|
| 80 | Good enough to commit |
| 90 | Ready for review / PR |
| 95 | Submission-ready |

### Key Principles

- **Plan first** -- enter plan mode before multi-file or ambiguous tasks
- **Verify after** -- compile and check output at the end of every task
- **Single source of truth** -- the LaTeX manuscript in `Paper/` is authoritative
- **Context survival** -- plans, logs, and learnings are saved to disk, not just conversation

---

## Customization

### For your field

1. Edit `.claude/agents/domain-reviewer.md` to customize the 5 review lenses for your discipline
2. Edit `.claude/rules/knowledge-base-template.md` to define notation and terminology
3. Add field-specific skills using `templates/skill-template.md`

### For your preferences

1. Edit `.claude/WORKFLOW_QUICK_REF.md` to set your color palette and visual preferences
2. Edit `CLAUDE.md` to add project-specific commands or quality thresholds
3. Add entries to `MEMORY.md` as you learn what works for your workflow

---

## Requirements

- **Claude Code** (CLI, desktop, or IDE extension)
- **XeLaTeX** (TeX Live 2024+ recommended)
- **R** (optional, for data analysis)
- **Python 3** (optional, for quality scoring)

---

## License

Use this template freely for your research projects.
