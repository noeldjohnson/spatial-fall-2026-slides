# ==============================================================================
# ma_counterfactual_checks.R -- checks on a rivers-as-land counterfactual
#
# Sits outside examples/market_access_project/ so a model working in that
# project cannot read or edit the checks before it runs.
#
# Usage, after Claude Code has written the file:
#   Rscript examples/ma_counterfactual_checks.R ~/ma-demo
#   Rscript examples/ma_counterfactual_checks.R ~/ma-demo ~/ma-demo-baseline-tau.rds
#
# The second argument is a copy of output/tau.rds taken before the model ran.
# It has to live outside the project, because output/*.rds is gitignored there
# and a rerun of script 01 overwrites the file without a trace.
#
# Rivers as land removes the cheapest inland mode, so
#   1. no pairwise cost falls (needs the baseline matrix and the model's matrix),
#   2. no city's market access rises,
#   3. nothing is Inf or NA, which a dropped same-cell convention produces,
#   4. the baseline column equals what script 02 wrote, else the grid changed.
# The largest falls should be river cities away from the sea. That one is an
# expectation and is printed for the eye rather than tested.
# ==============================================================================

suppressPackageStartupMessages(library(tidyverse))

args <- commandArgs(trailingOnly = TRUE)
proj <- if (length(args) >= 1) args[1] else "."
base_tau_file <- if (length(args) >= 2) args[2] else NA_character_

f <- file.path(proj, "Data/processed/ma_rivers_as_land.csv")
stopifnot(file.exists(f))
cf <- read_csv(f, show_col_types = FALSE)
stopifnot(all(c("city_jjk", "ma_1800", "ma_1800_cf") %in% names(cf)))
cf <- cf %>% mutate(change = ma_1800_cf / ma_1800 - 1)

cat("rows:", nrow(cf), "\n")
cat("any market access rises:", any(cf$change > 1e-9, na.rm = TRUE), "\n")
cat("any Inf or NA:", any(!is.finite(cf$ma_1800_cf)), "\n")
cat("mean change:", round(100 * mean(cf$change, na.rm = TRUE), 1), "percent\n")
cat("share of cities falling:", round(mean(cf$change < -1e-9, na.rm = TRUE), 3), "\n")

# 4. the baseline column against script 02's file
f02 <- file.path(proj, "Data/processed/market_access.csv")
if (file.exists(f02)) {
  base <- read_csv(f02, show_col_types = FALSE) %>% select(city_jjk, ma_1800_02 = ma_1800)
  j <- inner_join(cf, base, by = "city_jjk")
  cat("baseline column matches script 02:",
      nrow(j) == nrow(cf) && isTRUE(all.equal(j$ma_1800, j$ma_1800_02)), "\n")
} else {
  cat("baseline column matches script 02: not checked,", f02, "is missing\n")
}

# 1. the matrices, when both are available
tau_new <- setdiff(list.files(file.path(proj, "output"), pattern = "tau.*\\.rds$", full.names = TRUE),
                   file.path(proj, "output/tau.rds"))
if (is.na(base_tau_file)) {
  cat("any pairwise cost falls: not checked, no baseline matrix given\n")
} else if (length(tau_new) != 1) {
  cat("any pairwise cost falls: not checked, candidate matrices in output/:",
      if (length(tau_new)) paste(basename(tau_new), collapse = ", ") else "none", "\n")
} else {
  t0 <- readRDS(base_tau_file); t1 <- readRDS(tau_new)
  ok <- is.matrix(t1) && identical(dim(t0), dim(t1)) && identical(dimnames(t0), dimnames(t1))
  if (!ok) {
    cat("any pairwise cost falls: not checked,", basename(tau_new), "is not the same shape as the baseline\n")
  } else {
    cat("non-finite entries in the model's matrix:", sum(!is.finite(t1)), "\n")
    cat("any pairwise cost falls:", any(t1 < t0 - 1e-6, na.rm = TRUE), "\n")
  }
}

cat("\nlargest falls:\n")
print(cf %>% arrange(change) %>% select(city_jjk, ma_1800, ma_1800_cf, change) %>% head(10))

# Expected from the build on 10 October 2026: 1,017 rows, no rise, no Inf, the
# baseline matching, every city falling, mean change -36.5 percent, and Dijon,
# Belfort, Mulhouse, Besancon, and Salins at the top of the losers.
