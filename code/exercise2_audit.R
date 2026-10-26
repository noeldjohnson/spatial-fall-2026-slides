# ==============================================================================
# ECON 895 -- Coding Exercise 2, audit half
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
# the errors raises a message. Run it from the repository root, as you run the
# weekly scripts, so the data/ paths resolve. It needs the gstat package.
# ==============================================================================

library(tidyverse)
library(sf)
library(terra)
library(gstat)

# ------------------------------------------------------------------------------
# 1. Black Death mortality at 274 cities, and the 1,801 cities to predict.
# ------------------------------------------------------------------------------

mort <- read_csv("data/wk08/mort274.csv", show_col_types = FALSE) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)

cities <- read_csv("data/europe_cities_1801.csv", show_col_types = FALSE) %>%
  filter(!city_jjk %in% c("ALBA", "HALLE")) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)

cat("observed cities:", nrow(mort), "  target cities:", nrow(cities), "\n")

# ------------------------------------------------------------------------------
# 2. Choose the inverse-distance power by cross-validation.
#    Lower RMSE is better. We search a grid of powers.
# ------------------------------------------------------------------------------

powers <- seq(0.5, 4, by = 0.5)

cv_rmse <- function(p) {
  pred <- sapply(seq_len(nrow(mort)), function(i)
    gstat::idw(mortality ~ 1, mort[-i, ], mort[i, ], idp = p, debug.level = 0)$var1.pred)
  sqrt(mean((pred - mort$mortality)^2))
}

cv <- tibble(power = powers, rmse = sapply(powers, cv_rmse))
print(cv)
best_power <- cv$power[which.max(cv$rmse)]
cat("chosen power:", best_power, "\n")

# ------------------------------------------------------------------------------
# 3. Interpolate mortality to every city at the chosen power.
# ------------------------------------------------------------------------------

cities$mort_idw <- gstat::idw(mortality ~ 1, mort, cities, idp = best_power,
                              debug.level = 0)$var1.pred

cat("mean interpolated mortality across cities:",
    round(mean(cities$mort_idw), 1), "\n")

# ------------------------------------------------------------------------------
# 4. Average mortality by country, for a table.
# ------------------------------------------------------------------------------

by_country <- cities %>%
  st_drop_geometry() %>%
  group_by(countryname) %>%
  summarise(cities = n(), mortality = mean(mort_idw), .groups = "drop") %>%
  arrange(desc(mortality))

print(head(by_country, 8))

# ------------------------------------------------------------------------------
# 5. Night lights per person by African country, 2000.
# ------------------------------------------------------------------------------

lights  <- rast("data/wk08/africa_lights_2000.tif")
density <- rast("data/wk08/africa_popdens_2000.tif")     # persons per km2
africa  <- st_read("data/africa_scale.shp", quiet = TRUE)

# Put the population grid on the lights grid so the two line up cell for cell.
density_1km <- resample(density, lights, method = "bilinear")

# Light in each country and the people who live there.
light      <- terra::extract(lights, vect(africa), fun = "mean", na.rm = TRUE)[, 2]
population <- terra::extract(density_1km, vect(africa), fun = "sum", na.rm = TRUE)[, 2]

africa$light_pc <- light / population * 1e6

# ------------------------------------------------------------------------------
# 6. The brightest cities. Rank the 20 largest African cities by the light
#    in the cell they sit in.
# ------------------------------------------------------------------------------

big <- read_csv("data/africa_cities.csv", show_col_types = FALSE) %>%
  filter(!is.na(lon), !is.na(lat)) %>%
  arrange(desc(pop)) %>%
  slice_head(n = 20) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

big$dn <- terra::extract(lights, vect(big))[, 2]

ranking <- big %>% st_drop_geometry() %>%
  select(city = name, country, pop, dn) %>%
  arrange(desc(dn))
print(ranking, n = 20)
cat("brightest large city:", ranking$city[1], "\n")

# ------------------------------------------------------------------------------
# 7. Report.
# ------------------------------------------------------------------------------

out <- africa %>% st_drop_geometry() %>%
  select(country = admin, light_pc) %>%
  arrange(desc(light_pc))
print(head(out, 5)); print(tail(out, 5))
cat("mean across the 51 countries:", round(mean(africa$light_pc), 3), "\n")
