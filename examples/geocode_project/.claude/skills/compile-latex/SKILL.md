---
name: compile-latex
description: Compile the LaTeX research manuscript with XeLaTeX (3 passes + bibtex). Use when compiling the paper.
argument-hint: "[filename without .tex extension, defaults to main]"
allowed-tools: ["Read", "Bash", "Glob"]
---

# Compile the LaTeX Manuscript

Compile the research paper using XeLaTeX with full citation resolution.

The target defaults to `main` if `$ARGUMENTS` is empty.

## Steps

1. **Navigate to Paper/ directory** and compile with the 3-pass sequence:

```bash
cd Paper
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode ${ARGUMENTS:-main}.tex
BIBINPUTS=..:$BIBINPUTS bibtex ${ARGUMENTS:-main}
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode ${ARGUMENTS:-main}.tex
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode ${ARGUMENTS:-main}.tex
```

**Alternative (latexmk):**
```bash
cd Paper
TEXINPUTS=../Preambles:$TEXINPUTS BIBINPUTS=..:$BIBINPUTS latexmk -xelatex -interaction=nonstopmode ${ARGUMENTS:-main}.tex
```

2. **Check for warnings:**
   - Grep the `.log` for `Overfull \\hbox` warnings
   - Grep for `Citation ... undefined`, `Reference ... undefined`, or `Label(s) may have changed`
   - Report any issues found

3. **Open the PDF** for visual verification:
   ```bash
   open Paper/${ARGUMENTS:-main}.pdf
   ```

4. **Report results:**
   - Compilation success/failure
   - Number of overfull hbox warnings
   - Any undefined citations or unresolved references (`??` in the PDF)
   - PDF page count

## Why 3 passes?
1. First xelatex: Creates `.aux` file with citation keys and labels
2. bibtex: Reads `.aux`, generates `.bbl` with formatted references
3. Second xelatex: Incorporates the bibliography
4. Third xelatex: Resolves all cross-references with final page numbers

## Important
- **Always use XeLaTeX**, never pdflatex (the preamble assumes it)
- **TEXINPUTS** is required: your preamble/header lives in `Preambles/`
- **BIBINPUTS** is required: your `.bib` file lives in the repo root
- If R scripts feeding `Tables/` or `Figures/` changed, re-run them BEFORE compiling so the paper picks up fresh output
