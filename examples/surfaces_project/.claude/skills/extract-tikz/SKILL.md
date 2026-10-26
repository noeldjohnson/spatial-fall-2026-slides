---
name: extract-tikz
description: Compile TikZ diagrams to standalone, cropped PDF figures for inclusion in the LaTeX manuscript. Use when turning TikZ code into paper-ready figures.
argument-hint: "[figure name or path to the .tex file containing the TikZ]"
allowed-tools: ["Read", "Bash", "Glob"]
---

# Compile TikZ Diagrams to Paper-Ready PDF Figures

Compile a TikZ diagram into a tightly-cropped standalone PDF that the manuscript can include with `\includegraphics`. Vector PDF is the correct format for LaTeX inclusion — no SVG/raster conversion is needed.

## When to use this

- You maintain a diagram as a standalone `.tex` in `Figures/` and want a `.pdf` the paper inputs.
- You drafted TikZ inline and want to move it into `Figures/` as a reusable, cropped figure.

If the TikZ is defined inline in the manuscript and you are happy for it to compile in place, you do **not** need this skill — it just compiles with the paper.

## Steps

### Step 1: Locate or create the standalone figure source

Find the figure source: `ls Figures/$ARGUMENTS*.tex` (or use the path given in `$ARGUMENTS`).

If it does not exist, wrap the TikZ in the `standalone` class so it crops to the diagram:

```latex
\documentclass[tikz,border=2pt]{standalone}
% \input or \usepackage anything the diagram needs (colors, libraries)
\begin{document}
\begin{tikzpicture}
  % ... TikZ code ...
\end{tikzpicture}
\end{document}
```

Keep colors/macros consistent with the paper by sharing definitions from `Preambles/header.tex` where practical.

### Step 2: Compile to a cropped PDF

```bash
cd Figures
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode $ARGUMENTS.tex
```

The `standalone` class auto-crops. If the source is **not** standalone, crop afterward:

```bash
pdfcrop $ARGUMENTS.pdf $ARGUMENTS.pdf
```

### Step 3: Verify the output

```bash
pdfinfo Figures/$ARGUMENTS.pdf | grep -E "Pages:|Page size:"
ls -lh Figures/$ARGUMENTS.pdf   # sanity-check size > 0
open Figures/$ARGUMENTS.pdf     # visual check
```

### Step 4: Reference it from the manuscript

```latex
\begin{figure}[tbp]
  \centering
  \includegraphics[width=\columnwidth]{../Figures/$ARGUMENTS.pdf}
  \caption{...}
  \label{fig:$ARGUMENTS}
\end{figure}
```

### Step 5: Report results
- PDF created and cropped (page size ≈ diagram bounds)
- Figure referenced and resolves when the paper compiles

## Source of Truth Reminder
Keep one authoritative copy of each diagram's TikZ. If it lives both inline in the paper and as a standalone figure, edit one and copy it verbatim to the other. See `.claude/rules/tikz-visual-quality.md` and `.claude/rules/single-source-of-truth.md`.
