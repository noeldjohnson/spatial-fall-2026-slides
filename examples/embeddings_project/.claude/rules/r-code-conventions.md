---
paths:
  - "**/*.R"
  - "Figures/**/*.R"
  - "scripts/**/*.R"
---

# R Code Standards

**Standard:** Senior Principal Data Engineer + PhD researcher quality

---

## 1. Reproducibility

- `set.seed()` called ONCE at top (YYYYMMDD format)
- All packages loaded at top via `library()` (not `require()`)
- All paths relative to repository root
- `dir.create(..., recursive = TRUE)` for output directories

## 2. Function Design

- `snake_case` naming, verb-noun pattern
- Roxygen-style documentation
- Default parameters, no magic numbers
- Named return values (lists or tibbles)

## 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator implementations match the formulas in the manuscript
- Ensure numbers written to `Tables/`/`Figures/` match what the text reports
- Check known package bugs (document below in Common Pitfalls)

## 4. Visual Identity

```r
# --- Neutral academic palette ---
primary_navy   <- "#1B2A4A"
steel_blue     <- "#4682B4"
warm_gray      <- "#808080"
forest_green   <- "#2D6A4F"
rust_accent    <- "#C75B12"
```

### Custom Theme
```r
theme_custom <- function(base_size = 14) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", color = primary_navy),
      legend.position = "bottom"
    )
}
```

### Figure Dimensions for Paper
```r
# Vector PDF sized to the paper's text/column width; cairo_pdf embeds fonts cleanly
ggsave(filepath, width = 6.5, height = 4, device = cairo_pdf)
```

## 5. RDS Data Pattern

**Heavy computations saved as RDS; table/figure scripts load the pre-computed data instead of recomputing.**

```r
saveRDS(result, file.path(out_dir, "descriptive_name.rds"))
```

## 6. Common Pitfalls

<!-- Add your field-specific pitfalls here -->
| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Raster output (`.png`) for the paper | Blurry figures in print | Save vector PDF via `device = cairo_pdf` |
| Figure sized without regard to text width | Illegible labels when scaled down | Set `ggsave()` width/height to the on-page size |
| Hardcoded paths | Breaks on other machines | Use relative paths |

## 7. Line Length & Mathematical Exceptions

**Standard:** Keep lines <= 100 characters.

**Exception: Mathematical Formulas** -- lines may exceed 100 chars **if and only if:**

1. Breaking the line would harm readability of the math (influence functions, matrix ops, finite-difference approximations, formula implementations matching paper equations)
2. An inline comment explains the mathematical operation:
   ```r
   # Sieve projection: inner product of residuals onto basis functions P_k
   alpha_k <- sum(r_i * basis[, k]) / sum(basis[, k]^2)
   ```
3. The line is in a numerically intensive section (simulation loops, estimation routines, inference calculations)

**Quality Gate Impact:**
- Long lines in non-mathematical code: minor penalty (-1 to -2 per line)
- Long lines in documented mathematical sections: no penalty

## 8. Code Quality Checklist

```
[ ] Packages at top via library()
[ ] set.seed() once at top
[ ] All paths relative
[ ] Functions documented (Roxygen)
[ ] Figures: transparent bg, explicit dimensions
[ ] RDS: every computed object saved
[ ] Comments explain WHY not WHAT
```
