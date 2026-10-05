# ==============================================================================
# ECON 895 -- Coding Exercise 1, audit half
#
# Below is an analysis script of the kind a language model will write when you
# describe a task to it in a sentence or two.
#
# It runs from start to finish in a fresh session without errors, and the
# numbers it prints look plausible.
#
# It contains FIVE errors. Some change the estimates and some change what the
# script reports. The handout says what the script is meant to do.
#
# For each one, write down:
#   1. the line, or lines,
#   2. what the code actually does, as against what it was meant to do,
#   3. why nothing complained,
#   4. the fix,
#   5. the check that would have caught it before it reached a table.
#
# Point five is worth as much as the other four together.
#
# Read the code. Running it will not tell you what is wrong, because none of
# the errors raises a message. Run it from the repository root, as you run the weekly
# scripts, so the data/ paths resolve.
# ==============================================================================

library(tidyverse)
library(sf)

# ------------------------------------------------------------------------------
# 1. Load the European city data and make it spatial.
# ------------------------------------------------------------------------------

cities <- read_csv("data/europe_cities_1801.csv", show_col_types = FALSE) %>%
  filter(!(is.na(longitude) | is.na(latitude)))

cities_sf <- st_as_sf(cities, coords = c("longitude", "latitude"), crs = 4326,
                      remove = FALSE)

cat("cities loaded:", nrow(cities_sf), "\n")

# ------------------------------------------------------------------------------
# 2. Project, so that distances come out in meters rather than degrees.
# ------------------------------------------------------------------------------

cities_proj <- st_transform(cities_sf, 3857)

# ------------------------------------------------------------------------------
# 3. Attach the printing and population data.
# ------------------------------------------------------------------------------

press <- read_csv("data/europe_press_1500.csv", show_col_types = FALSE)

panel <- cities_proj %>%
  inner_join(press, by = "city_jjk")

cat("cities with press and population data:", nrow(panel), "\n")

# ------------------------------------------------------------------------------
# 4. Distance from Mainz, the standard instrument for early adoption.
# ------------------------------------------------------------------------------

mainz <- panel %>% filter(city_jjk == "MAINZ")

panel$km_mainz <- as.numeric(st_distance(panel, mainz)) / 1000

cat("median distance from Mainz:", round(median(panel$km_mainz)), "km\n")

# ------------------------------------------------------------------------------
# 5. Treatment and outcome.
# ------------------------------------------------------------------------------

panel <- panel %>%
  mutate(press1500 = as.integer(!is.na(print_date) & print_date < 1500),
         growth    = log(pop1600) - log(pop1500))

analysis <- panel %>%
  filter(!is.na(growth), is.finite(growth))

cat("estimation sample:", nrow(analysis), "cities\n")
cat("adopted a press by 1500:", sum(analysis$press1500), "\n")

# ------------------------------------------------------------------------------
# 6. Country areas, as a size control.
# ------------------------------------------------------------------------------

countries <- st_read("data/europe_modern.shp", quiet = TRUE) %>%
  st_transform(3857)

countries$area_km2 <- as.numeric(st_area(countries)) / 1e6

cat("\nlargest countries by area:\n")
print(countries %>%
        st_drop_geometry() %>%
        arrange(desc(area_km2)) %>%
        select(CntryName, area_km2) %>%
        head(4))

# ------------------------------------------------------------------------------
# 7. First stage. Does distance from Mainz predict adoption?
# ------------------------------------------------------------------------------

first_stage <- lm(press1500 ~ km_mainz + log(pop1500), data = analysis)

cat("\nfirst stage, coefficient on distance:\n")
print(round(summary(first_stage)$coefficients["km_mainz", ], 6))

# ------------------------------------------------------------------------------
# 8. Reduced form.
# ------------------------------------------------------------------------------

reduced_form <- lm(growth ~ km_mainz + log(pop1500), data = analysis)

cat("\nreduced form, coefficient on distance:\n")
print(round(summary(reduced_form)$coefficients["km_mainz", ], 6))

cat("\nDone. Every number above is ready for the draft.\n")
