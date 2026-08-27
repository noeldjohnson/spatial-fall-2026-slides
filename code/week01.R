# ==============================================================================
# ECON 895  Spatial Techniques in Empirical Economics
# Week 1, 24 August 2026.  Introduction and the Verification Frame
#
# HOW TO USE THIS FILE
#   1. Open ECON895.Rproj first. That sets the working directory to the repo
#      root, which is why every path below starts with data/ and not ../data/
#      or a path from your own machine.
#   2. Work down the file. The heading on each block gives the slide it goes
#      with, so you can read the deck and the code side by side.
#   3. Blocks marked PREDICT are the ones we voted on in class. Commit to an
#      answer before you run them. Being wrong is the point.
# ==============================================================================

library(tidyverse)
library(sf)
library(s2)

africa  <- st_read("data/africa_scale.shp", quiet = TRUE) %>%
  select(admin, region_wb)
cities  <- read_csv("data/africa_cities.csv", show_col_types = FALSE) %>%
  filter(!(is.na(lon) | is.na(lat))) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326)
fairfax <- st_as_sf(data.frame(lon = -77.3064, lat = 38.8462),
                    coords = c("lon", "lat"), crs = 4326)


# ---- Slide 22. How a CRS is written down -------------------------------------
st_crs(4326)$input      # what you asked for
st_crs(32632)$units     # what you will be measuring in


# ---- Slide 23. Real data is not always tidy ----------------------------------
eur <- st_read("data/europe_modern.shp", quiet = TRUE)
st_crs(eur)$epsg                           # NA. That does not mean broken.
substr(st_crs(eur)$proj4string, 1, 46)     # there IS a definition, just no code


# ---- Slide 26. The same four corners, written two ways -----------------------
ccw <- "POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))"   # counterclockwise
cw  <- "POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))"   # same corners, reversed
a <- function(w) s2_area(as_s2_geography(w, oriented = TRUE)) / 1e6
a(ccw)                 # the small patch
a(cw)                  # everything else
a(ccw) + a(cw)         # the two sum to ...
4 * pi * 6371^2        # ... the surface of the earth


# ---- Slide 27. Why you have probably never hit this --------------------------
b <- function(w) s2_area(as_s2_geography(w, oriented = FALSE)) / 1e6
b(ccw); b(cw)          # sf's default. Both give the small patch.


# ---- Slide 33. The setup -----------------------------------------------------
africa
cities


# ---- Slide 34. PREDICT. What will st_crs give us? ----------------------------
class(africa)
st_crs(africa)$epsg


# ---- Slide 35. PREDICT. Is this code correct? True or false? -----------------
fx_sp <- st_transform(fairfax, 2283)      # Virginia State Plane North
buf   <- st_buffer(fx_sp, dist = 10000)   # "10 km". Yes?


# ---- Slide 36. What we actually built ----------------------------------------
buf_bad  <- st_buffer(fx_sp, dist = 10000) %>% st_transform(5070)
buf_good <- st_transform(fairfax, 5070) %>% st_buffer(dist = 10000)
par(mar = c(0, 0, 1.2, 0))
plot(st_geometry(buf_good), col = "#dcebfa", border = "#005293", lwd = 2,
     main = "Intended 10 km (blue) vs what the code produced (red)")
plot(st_geometry(buf_bad), col = "#ffe9e9", border = "#b40000", lwd = 2, add = TRUE)
plot(st_geometry(st_transform(fairfax, 5070)), add = TRUE, pch = 20)

r <- as.numeric(sqrt(st_area(buf_bad) / pi))
cat("asked for :", 10000, "m\n")
cat("received  :", round(r), "m\n")
cat("ratio     :", round(r / 10000, 4), "\n")


# ---- Slides 37 and 38. Why, and the one line that catches it -----------------
st_crs(2283)$units      # us-ft. That is the whole answer.
st_crs(fx_sp)$units     # run this BEFORE you measure, not after


# ---- Slide 39. PREDICT. How many rows come back? -----------------------------
keep <- tibble(admin = c("Kenya", "Uganda", "Tanzania"))
nrow(cities)
joined <- suppressWarnings(st_join(cities, africa)) %>%
  st_drop_geometry() %>% inner_join(keep, by = "admin")
nrow(joined)
nrow(cities) - nrow(joined)


# ---- Slide 41. PREDICT. Draw it. Count the shaded countries with cities ------
# joined has no geometry, because st_drop_geometry() above threw it away.
# Redo the join keeping it.
kept  <- suppressWarnings(st_join(cities, africa)) %>%
  filter(admin %in% keep$admin)
asked <- africa %>%
  filter(admin %in% c("Kenya", "Uganda", "United Republic of Tanzania"))
bb <- st_bbox(asked)
par(mar = c(0, 0, 0.4, 0))
plot(st_geometry(africa), col = "grey94", border = "grey72",
     xlim = bb[c(1, 3)] + c(-1.5, 1.5), ylim = bb[c(2, 4)] + c(-1, 1))
plot(st_geometry(asked), col = "#dcebfa", border = "#005293", lwd = 1.8, add = TRUE)
plot(st_geometry(kept), add = TRUE, pch = 20, cex = 0.7, col = "#b40000")


# ---- Slide 42. Why Tanzania is empty -----------------------------------------
grep("Tanz", africa$admin, value = TRUE)      # the shapefile's name for it
kept %>% st_drop_geometry() %>% count(admin)  # Kenya and Uganda only

# The join matched on a string. Two of the three names matched, one did not,
# and nothing warned. The row count looked reasonable, which is exactly why it
# survived. Count rows on both sides of every join, and then look at what you
# kept.
