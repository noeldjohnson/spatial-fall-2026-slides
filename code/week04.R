# ==============================================================================
# ECON 895  Spatial Techniques in Empirical Economics
# Week 4, 21 September 2026.  Rasters and Difference-in-Differences
#
# HOW TO USE THIS FILE
#   1. Open ECON895.Rproj first. That sets the working directory to the repo
#      root, which is why every path below starts with data/ and not a path
#      from someone else's machine.
#   2. Work DOWN the file, in order. Objects built in one block are used by the
#      next, so skipping around will produce "object not found".
#   3. The heading on each block gives the slide it goes with, so you can read
#      the deck and the code side by side.
#   4. Blocks marked PREDICT are the ones we voted on in class. The question is
#      in the comment and the answer is not. Commit to an answer, then run.
#      Being wrong is the point, and it is also the assignment.
#   5. The last three blocks are an APPENDIX. We did not run them in class.
#      They are here because they answer questions that came up, and because
#      each one is a trap worth meeting once.
#
# One new package this week, for raster data:
#   install.packages("terra")
#
# ONE NAMESPACE WARNING that will cost you twenty minutes if you skip it.
# terra and tidyr both export a function called extract(). Whichever package
# you attached last wins, and the error you get talks about arguments rather
# than namespaces. Every call below says terra::extract() on purpose.
#
# ------------------------------------------------------------------------------
# THE SUITABILITY SCALE RUNS DOWNWARD. Read this before you read any number.
#
#   1 very high   4 medium     7 very marginal
#   2 high        5 moderate   8 not suitable
#   3 good        6 marginal   9 INLAND WATER
#
# LOW NUMBERS ARE GOOD LAND, and 9 is not a suitability at all. Nunn and Qian
# call land suitable at class 4 or better. Two rules follow from this and both
# matter more than they look:
#   (1) drop water before ANY arithmetic on the raw layer
#   (2) from the extract onward, work from
#         suit_r <- ifel(europe == 9, NA, 9 - europe)
#       so water is gone and a high number means good land.
#
# The direction is an inference. The legend of the paper's Figure II gives the
# class NAMES, not the integer codes. What pins it down is the data itself:
# Flanders 3, Ireland 4, the Sahara 8, Lake Titicaca 9, and class 1 holding
# 520 cells in the whole world against 1.46 million for class 8. A top band
# looks like that. A bottom band cannot.
# ------------------------------------------------------------------------------
#
# The raster is the FAO/IIASA Global Agro-Ecological Zones potato suitability
# surface. The cities and press dates are the same files as Weeks 2 and 3, and
# the Peruvian districts are Dell's. See DATA_SOURCES.md.
# ==============================================================================

library(tidyverse)
library(sf)
library(terra)
library(sandwich)
library(lmtest)

potato <- rast("data/gaez_potato_suitability.tif")
eu_box <- ext(-11, 31, 35, 71)   # NOT `box`: base R has a box() we call below
europe <- crop(potato, eu_box)

cities <- read_csv("data/europe_cities_1801.csv", show_col_types = FALSE) %>%
  filter(!(is.na(longitude) | is.na(latitude)))
press  <- read_csv("data/europe_press_1500.csv", show_col_types = FALSE)

# ALBA and HALLE are one name for two cities each, as Week 2 found. The inner
# join then restricts us to Dittmar's press-city frame, 1,017 of 1,801, which
# is close in construction to Nunn and Qian's European city sample.
cty <- cities %>% filter(!city_jjk %in% c("ALBA", "HALLE")) %>%
  inner_join(press, by = "city_jjk")
pts <- st_as_sf(cty, coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)

lbl <- c("very high", "high", "good", "medium", "moderate",
         "marginal", "very marginal", "not suitable", "inland water")


# ---- Slide 11. A raster stores its geometry once -----------------------------
potato <- rast("data/gaez_potato_suitability.tif")
potato

plot(potato)

# CRS line is still the one people skip. Note what is NOT here: a list of
# coordinates. Week 3's 299 districts each dragged thousands of vertices. This
# holds 9.3 million values and stores the geometry once.
#
# Note also what else is not here. No units, no codebook, no direction. Slide
# 12 is their published map and slide 13 is what the numbers mean.


# ---- Slide 13. What one cell holds -------------------------------------------
f <- freq(europe)
cbind(f[, c("value", "count")], label = lbl[f$value])

n_good <- global(europe <= 4, "sum", na.rm = TRUE)[1, 1]
n_land <- global(!is.na(europe) & europe != 9, "sum", na.rm = TRUE)[1, 1]
c(good = n_good, land = n_land, share = round(100 * n_good / n_land, 1))

freq(potato)$count[1]                         # class 1, worldwide

# runs downward, and the counts prove it: 520 cells worldwide in class 1
# against 1.46 million in class 8. That is what a top band looks like and it is
# impossible for a bottom one.
#
# Note the denominator. Class 9 is water and is non-NA, so leaving it in makes
# the share 19.9 rather than 20.2. Small here, and the habit is the point.


# ---- Slide 15. PREDICT. How big is a cell? -----------------------------------
# PREDICT: the resolution is 0.0833 degrees. How many square kilometers is
# one cell? And is it the same in Sicily and in northern Norway?
res(potato)                                  # degrees, not meters

km2 <- cellSize(potato, unit = "km")
terra::extract(km2, cbind(10, c(0, 30, 50, 60)))[, 1]

# 85.5 at the equator, 43.2 at sixty north. A factor of two. A degree grid is
# not an equal-area grid, and averaging one over a continent weights the
# tropics. Same lesson as Week 2's Mercator areas, wearing a new hat.


# ---- Slide 16. PREDICT. Crop changes the extent, mask changes the values -----
# PREDICT: we crop to Europe, then mask to the same box. Which one changes
# the number of cells, and by how much?
cropped <- crop(potato, eu_box)
masked  <- mask(potato, vect(st_as_sfc(st_bbox(
             c(xmin = -11, ymin = 35, xmax = 31, ymax = 71), crs = 4326))))

c(original = ncell(potato), cropped = ncell(cropped), masked = ncell(masked))

# crop() cuts the extent. mask() keeps the extent and NAs everything outside.
# Mask when the grid has to keep lining up with something else.


# ---- Slide 17. FIGURE, baked. What crop and mask left behind -----------------
pal9 <- grey.colors(9, start = 0.18, end = 0.94)
par(mfrow = c(1, 2), mar = c(0.4, 0.4, 1.6, 0.4))
cropped2 <- cropped; coltab(cropped2) <- NULL
masked2  <- masked;  coltab(masked2)  <- NULL
plot(cropped2, col = pal9, legend = FALSE, axes = FALSE, maxcell = 4e5,
     main = "crop(): a smaller object")
box(col = "grey70")
plot(masked2, col = pal9, legend = FALSE, axes = FALSE, maxcell = 8e5,
     main = "mask(): the same object, mostly NA")
rect(-11, 35, 31, 71, border = "#b40000", lwd = 1.6)
box(col = "grey70")
par(mfrow = c(1, 1))

# The red rectangle is where Europe is. Everything else in that frame is NA and
# the object still carries all 9.3 million cells.


# ---- Slide 18. Map algebra, and reclassifying --------------------------------
europe <- crop(potato, eu_box)

good <- europe <= 4                          # the Nunn and Qian threshold
global(good, "mean", na.rm = TRUE)           # share of cells, water included

rcl <- matrix(c(0,4,1, 4,7,2, 7,8,3, 8,9,NA), ncol = 3, byrow = TRUE)
terra::freq(classify(europe, rcl))           # water became NA and drops out

# Four kinds of map algebra. Local is per cell, which is this. Focal uses a
# neighborhood, slide 21. Zonal uses a shape, slide 34. Global reduces the
# whole layer to a number, which is what global() just did.
#
# Note the last row of rcl sends water to NA. Doing that in the reclassify is
# cheaper than remembering it in every regression afterwards.


# ---- Slide 19. PREDICT. A plot is a sample of the data -----------------------
# PREDICT: this layer has 9.3 million cells. Your screen has about two
# million pixels. When you call plot(), how many cells does terra actually
# draw? Write the number down.
drawn <- spatSample(potato, 5e5, method = "regular", as.raster = TRUE)
c(in_the_layer = ncell(potato), on_the_screen = ncell(drawn))

f2  <- merge(as.data.frame(freq(potato)), as.data.frame(freq(drawn)),
             by = "value", suffixes = c("_all", "_drawn"))
pct <- function(x) round(100 * x / sum(x), 2)
head(data.frame(value = f2$value, all = pct(f2$count_all),
                drawn = pct(f2$count_drawn)), 4)

# Compare the SHARES, not the counts. Taking [, 1:3] off that merge silently
# drops count_drawn and prints a column of 1s instead, which is the same class
# of error as everything else tonight.
# The class shares survive the sample to within 0.14 of a percentage point.
# That is the trap: any summary you compute off the picture is right, so
# nothing feels wrong, while every feature smaller than the sampling step is
# gone. Pass maxcell yourself when detail matters.


# ---- Slide 20. Resolution is a choice you are making -------------------------
coarse <- aggregate(europe, fact = 10, fun = "modal", na.rm = TRUE)

rbind(fine   = c(res(europe),  ncell = ncell(europe)),
      coarse = c(res(coarse), ncell = ncell(coarse)))

ext(europe); ext(coarse)                     # they are NOT the same

# A hundred times fewer cells and a hundred times faster. The VERB matters as
# much as the factor. fun = "modal" keeps the commonest class, which is still a
# class. fun = "mean" would hand you the average of a hundred category codes,
# and the object would not remind you that no such thing exists.
#
# And neither 504 nor 432 divides by ten, so aggregate PADS the extent to make
# it fit. The trailing row and column are built from fewer than 100 cells each.


# ---- Slide 21. Focal operations use a neighborhood ---------------------------
w   <- matrix(1, nrow = 5, ncol = 5)         # a 5 by 5 window
dry <- ifel(europe == 9, NA, europe)         # WATER OUT BEFORE ANY AVERAGING
sm  <- focal(dry, w = w, fun = mean, na.rm = TRUE)

c(original_sd = sd(values(dry), na.rm = TRUE),
  focal_sd    = sd(values(sm),  na.rm = TRUE))

# That ifel() line is the whole lesson repeating. A neighborhood mean that
# includes a 9 returns a number no class ever had. Any window touching the
# Zuiderzee, Lake Constance or a fjord is pulled toward "not suitable" by a
# code that means water. Same error as averaging a category, one slide later.
#
# Smoothing then lowers the variance, which is the point and the danger
# together. It is a DIFFERENT treatment variable from the one under the city:
pt_v <- terra::extract(dry, vect(pts))[, 2]
fo_v <- terra::extract(sm,  vect(pts))[, 2]
c(correlation = cor(pt_v, fo_v, use = "complete.obs"),
  mean_gap    = mean(abs(pt_v - fo_v), na.rm = TRUE))

# Focal windows do the real work in Week 7, where a cost surface has to know
# about its neighbors to accumulate anything.


# ---- Slide 22. FIGURE, baked. The same map, coarsened and smoothed -----------
e2 <- ifel(europe == 9, NA, europe); coltab(e2) <- NULL   # water out again
c2 <- aggregate(e2, fact = 10, fun = "modal", na.rm = TRUE)
s2 <- focal(e2, w = matrix(1, 5, 5), fun = mean, na.rm = TRUE)
par(mfrow = c(1, 3), mar = c(0.3, 0.3, 1.5, 0.3))
for (i in seq_len(3)) {
  plot(list(e2, c2, s2)[[i]], col = grey.colors(30, start = 0.15, end = 0.97),
       legend = FALSE, axes = FALSE, maxcell = 4e5,
       main = c("the file, 5 arc-minute", "aggregate(fact = 10), modal",
                "focal(5 by 5), mean")[i])
  box(col = "grey70")
}
par(mfrow = c(1, 1))

# Middle panel: whole classes, and the Alps are gone. Right panel: the shape of
# everything survives and the nine classes have become about a thousand values,
# so it is no longer a classification of anything.


# ---- Slide 23. PREDICT. Never interpolate a category -------------------------
# PREDICT: this layer holds nine classes, 1 to 9. We reproject it with the
# default bilinear method. How many distinct values come out the other side?
moll <- "+proj=moll +datum=WGS84"   # ESRI:54009; Mollweide has no EPSG code
bad  <- project(europe, moll, method = "bilinear")
nearest <- project(europe, moll, method = "near")   # NOT named `good`: that
                                                    # name is taken, slide 18

c(classes_in   = length(unique(values(europe,  na.rm = TRUE))),
  bilinear_out = length(unique(values(bad,     na.rm = TRUE))),
  nearest_out  = length(unique(values(nearest, na.rm = TRUE))))

# Suitability class 8.04 does not exist. Bilinear averages the four nearest
# cells, which is right for temperature and meaningless for a category.
head(sort(unique(values(bad, na.rm = TRUE))), 4)


# ---- Slide 24. FIGURE, baked. What bilinear did to the Alps ------------------
alp <- crop(europe, ext(6, 10, 45, 48)); coltab(alp) <- NULL
n_alp <- length(unique(values(alp, na.rm = TRUE)))        # 8, not 9
ab  <- project(alp, moll, method = "bilinear")
an  <- project(alp, moll, method = "near")
par(mfrow = c(1, 2), mar = c(0.3, 0.3, 3.0, 0.3))
plot(an, col = grey.colors(9, start = 0.12, end = 0.97), legend = FALSE,
     axes = FALSE, main = "")
mtext(paste0('method = "near", still ', n_alp, " classes"), side = 3, line = 0.4)
box(col = "grey70")
plot(ab, col = grey.colors(120, start = 0.12, end = 0.97), legend = FALSE,
     axes = FALSE, main = "")
mtext('method = "bilinear", now a gradient', side = 3, line = 0.4)
box(col = "grey70")
par(mfrow = c(1, 1))


# ---- Slide 25. Rasters lose something every time you move them ---------------
there_and_back <- project(project(europe, moll, method = "near"),
                          europe, method = "near")

mean(values(europe) != values(there_and_back), na.rm = TRUE)

# 3.9 percent of cells come back different. A vector round trip moves
# coordinates and is reversible. A raster round trip RESAMPLES, twice, and
# resampling is lossy. Project once, from the original, and never chain.

# The same applies to writing. INT1U on a layer holding halves truncates:
half <- europe / 2
f2 <- tempfile(fileext = ".tif")
writeRaster(half, f2, datatype = "INT1U", overwrite = TRUE)
c(before = length(unique(values(half, na.rm = TRUE))),
  after  = length(unique(values(rast(f2), na.rm = TRUE))))
unlink(f2)


# ---- Slide 26. Two grids that do not line up ---------------------------------
rough <- aggregate(europe, fact = 4, fun = "modal", na.rm = TRUE)

rbind(europe = c(res(europe), dim(europe)[1:2]),   # map algebra needs these
      rough  = c(res(rough),  dim(rough)[1:2]))    # four numbers to agree

aligned <- resample(rough, europe, method = "near")
both    <- c(europe, aligned)                      # one object, two layers
names(both) <- c("fine", "coarse"); nlyr(both)

# try(europe + rough)

# Two surfaces can only meet in an expression when they share an origin, a
# resolution, and a CRS. resample() puts one onto the other's grid and is the
# same lossy business as projecting, so choose the method by what the values
# mean. A multi-layer object is how a stack travels together, and it is how
# Week 8's monthly climate data arrives.
#
# If someone asks what happens without the resample, show them:
#   try(europe + rough)


# ---- Slide 27. PREDICT. Rasterize and vectorize ------------------------------
# PREDICT: we burn 1,017 city points onto this grid and count how many cells
# end up holding a city. How many? The number is not 1,017.
grid <- rasterize(vect(pts), europe, fun = "length")     # shapes to surface
poly <- st_as_sf(as.polygons(ifel(europe <= 4, 1, NA)))  # surface to shapes

c(cities  = nrow(pts),
  cells   = sum(!is.na(values(grid))),
  busiest = max(values(grid), na.rm = TRUE),
  parts   = nrow(poly))

plot(grid)
grid

plot(poly[2])
poly

# A cell here is about seven kilometers across, so the grid cannot tell Hamburg
# from Altona four kilometers away. The seven colliding pairs are all within
# six kilometers of each other, most of them in Sicily.
#
# Going the other way, as.polygons() dissolves the suitable cells into ONE
# shape sf will accept, which is what Week 7 needs when a cost surface has to
# meet a road network. Note the ifel(): on a bare 0/1 layer as.polygons returns
# TWO features, the suitable and the unsuitable, and nobody would notice.


# ================================ BREAK, slide 28 ==============================


# ---- Slide 30. The verb the whole week is about ------------------------------
cty$raw  <- terra::extract(europe, vect(pts))[, 2]      # as the file ships

suit_r   <- ifel(europe == 9, NA, 9 - europe)           # water out, high = good
cty$suit <- terra::extract(suit_r, vect(pts))[, 2]

c(cities = nrow(cty), on_water = sum(cty$raw == 9, na.rm = TRUE),
  usable = sum(!is.na(cty$suit)), median = median(cty$suit, na.rm = TRUE))

# Recode the SURFACE once, before anything touches it, rather than patching the
# extract() too, whichever package attached last wins, and the error talks
# about arguments rather than namespaces.


# ---- Slide 31. Seven cities sit on water -------------------------------------
cty %>% filter(raw == 9) %>%
  select(city_jjk, countryname) %>% print(n = 7)

# Four are Zuiderzee ports, Konstanz is on the Bodensee, Aalborg is on the
# Limfjord and Trondheim on its fjord. The cell underneath each of them is
# WATER, and the code for water is 9, which is also the largest number on the
# scale. Take the file at face value and these seven become the most
# potato-suitable cities in Europe. A value that is present, plausible, and
# means something else does not announce itself.


# ---- Slide 32. PREDICT. A point, or a neighborhood? --------------------------
# PREDICT: a city is a dot, but nobody farms a dot. If we take mean
# suitability within 10, 25, 50 and 100 km instead, how correlated will those
# four be with the single pixel under the city? Guess all four.
for (km in c(10, 25, 50, 100)) {
  buf <- st_buffer(st_transform(pts, 3035), km * 1000) %>% st_transform(4326)
  cty[[paste0("suit", km)]] <-                       # exact: a 10 km buffer is
    terra::extract(suit_r, vect(buf), fun = mean,    # only a few cells wide,
                   na.rm = TRUE, exact = TRUE)[, 2]  # the regime slide 34 warns of
}
sapply(cty[, paste0("suit", c(10, 25, 50, 100))],
       function(v) cor(v, cty$suit, use = "complete.obs"))

# A city of ten thousand fed itself from a few kilometers. One of two hundred
# thousand did not. You are choosing a measurement and there is no default.
# Nunn and Qian choose one hundred kilometers, and their footnote 40 reports
# fifty and two hundred as well. Slide 43 checks that claim on our cities.
#
# 3035 is ETRS89 Lambert azimuthal EQUAL-AREA for Europe, used here because
# st_buffer wants meters. An equal-area projection doing a distance job, worth
# about one percent at the edges of this map. Also a choice.


# ---- Slide 33. FIGURE, baked. One city and four radii ------------------------
mun <- pts[pts$city_jjk == "MUENCHEN", ]
win <- st_buffer(st_transform(mun, 3035), 150000) %>% st_transform(4326)
loc <- crop(suit_r, ext(st_bbox(win)[c(1, 3, 2, 4)]))
par(mar = c(0.3, 0.3, 0.3, 0.3))
plot(loc, col = grey.colors(8, start = 0.97, end = 0.12), legend = FALSE,
     axes = FALSE, maxcell = 2e5)
rings <- c(10, 25, 50, 100); cols <- c("#2f6fa8", "#15803d", "#f2a900", "#b40000")
for (i in seq_along(rings)) {
  b <- st_buffer(st_transform(mun, 3035), rings[i] * 1000) %>% st_transform(4326)
  plot(st_geometry(b), border = cols[i], lwd = 2.6, add = TRUE)
}
plot(st_geometry(mun), pch = 21, bg = "white", cex = 1.3, add = TRUE)
ex <- as.vector(ext(loc))
legend(x = ex[1] + 0.02 * diff(ex[1:2]), y = ex[4] - 0.02 * diff(ex[3:4]),
       bty = "o", box.col = "grey80", bg = "white", cex = 0.80,
       lty = 1, lwd = 2.6, col = cols, legend = paste0(rings, " km"))


# ---- Slide 34. Zonal statistics, and the cells on the edge -------------------
peru <- st_transform(st_read("data/peru_districts.shp", quiet = TRUE), 4326)
pr   <- crop(potato, ext(st_bbox(peru)[c(1, 3, 2, 4)]))

plain <- terra::extract(pr, vect(peru), fun = mean, na.rm = TRUE)[, 2]
exact <- terra::extract(pr, vect(peru), fun = mean, na.rm = TRUE, exact = TRUE)[, 2]

max(abs(plain - exact), na.rm = TRUE)

# By default a cell counts if its center is inside. exact = TRUE weights each
# cell by the fraction covered. Worth up to a full suitability class on Peru's
# districts, which are close in size to a cell, and 0.014 on whole countries.
#
# GET THE DIRECTION RIGHT. The error GROWS as polygons SHRINK toward the size
# of a cell, because it lives on the perimeter. Biggest for the smallest
# units, negligible for countries. That is why every buffer tonight uses
# exact = TRUE.


# ---- Slide 35. Building the dose their way -----------------------------------
suitable <- ifel(potato == 9, NA, potato <= 4)     # classes 1 to 4, water out
km2_ok   <- cellSize(potato, unit = "km") * suitable

b100 <- st_buffer(st_transform(pts, 3035), 100000) %>% st_transform(4326)
area <- terra::extract(km2_ok, vect(b100), fun = sum,
                       na.rm = TRUE, exact = TRUE)[, 2]
cty$lnarea <- log(area + 1)                       # the +1 is a choice too

c(cities = sum(!is.na(cty$lnarea)), median_km2 = median(area, na.rm = TRUE))

# THIS IS THE TREATMENT. Nunn and Qian do not use the cell under the city.
# Their dose is the log of suitable land AREA within 100 km, where suitable
# means classes 1 to 4. A threshold, a buffer, a sum and a log. Every one of
# those is a verb from the last hour.
#
# land shares inside each cell from the FAO's five categories; we hold one
# class per cell. The two line up at the 40 cut.


# ---- Slide 36. The dose on the map -------------------------------------------
par(mar = c(0, 0, 0, 0))
plot(suit_r, col = grey.colors(8, start = 0.97, end = 0.12),
     legend = FALSE, axes = FALSE, maxcell = 5e5)
keepc <- !is.na(cty$lnarea)
ter   <- cut(cty$lnarea[keepc],
             quantile(cty$lnarea[keepc], c(0, 1/3, 2/3, 1)),
             include.lowest = TRUE, labels = FALSE)
pal3  <- c("#2f6fa8", "#f0a000", "#b40000")
plot(st_geometry(pts[keepc, ]), add = TRUE, pch = 20,
     cex = c(0.40, 0.50, 0.70)[ter], col = pal3[ter])
legend(x = -10.8, y = 70.5, bty = "n", cex = 0.78, pch = 20, pt.cex = 1.1,
       col = pal3, text.col = "grey20", title = "suitable land within 100 km",
       legend = c("lowest third", "middle third", "highest third"))

cor(cty$lnarea, cty$suit, use = "complete.obs")   # dot vs the grey beneath it

# The dot and the grey beneath it agree only loosely, r = 0.34. A city on poor
# ground with good ground around it is a high-dose city. That is what the
# buffer is for, and it is why slide 48 goes wrong.


# ---- Slide 39. Build the panel -----------------------------------------------
panel <- cty %>%
  select(city_jjk, dose = lnarea, pop1500, pop1600, pop1700, pop1800) %>%
  pivot_longer(starts_with("pop"), names_to = "year", values_to = "pop",
               names_prefix = "pop", names_transform = as.integer) %>%
  filter(pop > 0, !is.na(dose)) %>%
  mutate(lpop = log(pop), post = as.integer(year >= 1700))

c(rows = nrow(panel), cities = n_distinct(panel$city_jjk))
panel %>% count(year) %>% pull(n)            # cities observed in each year

# Four population columns become one column and a year. pivot_longer from
# Week 2 doing the job it exists for. The panel is UNBALANCED: 748 cities in
# 1500 and 1,013 in 1800, because a city enters in the first year it has a
# recorded population. Entry is an outcome. Nunn and Qian carry the same


# ---- Slide 40. The estimate --------------------------------------------------
m <- lm(lpop ~ dose:post + factor(city_jjk) + factor(year), data = panel)

round(coeftest(m, vcov. = vcovCL(m, cluster = panel$city_jjk))["dose:post", ], 4)

# +0.0211 (0.0079), t = 2.66. A one percent increase in suitable land within
# 100 km is worth about 0.021 percent higher city population after 1700. THE
# SIGN IS THEIRS. The next slide puts the size beside theirs.
#
# Read the standard error with one eye closed. Clustering by city assumes
# cities are independent of one another, and suitability is about as
# spatially autocorrelated as a variable gets. Week 9.

# Helpers used from here on. did_at() runs the DiD on any column of cty at
# any cutoff; pl_at() runs its pre-trend placebo on the 1500-1600 years.
did_at <- function(col, cut = 1700) {
  p <- cty %>% select(city_jjk, dose = all_of(col),
                      pop1500, pop1600, pop1700, pop1800) %>%
    pivot_longer(starts_with("pop"), names_to = "year", values_to = "pop",
                 names_prefix = "pop", names_transform = as.integer) %>%
    filter(pop > 0, !is.na(dose)) %>%
    mutate(lpop = log(pop), post = as.integer(year >= cut))
  mm <- lm(lpop ~ dose:post + factor(city_jjk) + factor(year), data = p)
  cc <- coeftest(mm, vcov. = vcovCL(mm, cluster = p$city_jjk))["dose:post", ]
  c(estimate = unname(cc[1]), se = unname(cc[2]), t = unname(cc[3]),
    cities = n_distinct(p$city_jjk))
}
pl_at <- function(col) {
  p <- cty %>% select(city_jjk, dose = all_of(col),
                      pop1500, pop1600, pop1700, pop1800) %>%
    pivot_longer(starts_with("pop"), names_to = "year", values_to = "pop",
                 names_prefix = "pop", names_transform = as.integer) %>%
    filter(pop > 0, !is.na(dose), year < 1700) %>%
    mutate(lpop = log(pop), fp = as.integer(year >= 1600))
  mm <- lm(lpop ~ dose:fp + factor(city_jjk) + factor(year), data = p)
  cc <- coeftest(mm, vcov. = vcovCL(mm, cluster = p$city_jjk))["dose:fp", ]
  c(estimate = unname(cc[1]), se = unname(cc[2]), t = unname(cc[3]))
}
nq_e <- did_at("lnarea")


# ---- Slide 41. Their city-level estimates. No code. --------------------------
# Table VIII, Europe-only columns: (6) 0.042 (0.025) [0.023] on towns of 1,000
# or more; (7) 0.029 (0.015) [0.019] adding country-year effects. Ours: 0.021
# (0.008). Same sign, same order of magnitude, from a shapefile, a GeoTIFF and
# a dozen lines of R. Their controls: Old World crop suitability, log
# elevation, log ruggedness, log tropical area, each x year. Ten periods to
# our four. Brackets are Conley SEs with a five-degree cutoff, which is Week 9.


# ---- Slide 42. PREDICT. The test the design owes you -------------------------
# PREDICT: throw away everything after 1700. On the pre-potato years alone,
# put a fake Post at 1600 and run the identical regression. If parallel
# trends holds, what should beta be?
pre <- panel %>% filter(year < 1700) %>%
  mutate(fake_post = as.integer(year >= 1600))

mp <- lm(lpop ~ dose:fake_post + factor(city_jjk) + factor(year), data = pre)
round(coeftest(mp, vcov. = vcovCL(mp, cluster = pre$city_jjk))["dose:fake_post", ], 4)

# QUIET. High-dose and low-dose cities were on the same path from 1500 to
# 1600. That is the assumption the design rests on, and on this test it
# holds. Nunn and Qian run the same check across six pre-periods and it holds
# for them too. First diagnostic passed.


# ---- Slide 43. PREDICT. Three radii -----------------------------------------
# PREDICT: their footnote 40 says the result survives at 50 and 200 km as
# well as at 100. Does ours? Say what you expect to happen to the estimate
# as the catchment widens.
for (km in c(50, 200)) {
  b <- st_buffer(st_transform(pts, 3035), km * 1000) %>% st_transform(4326)
  cty[[paste0("lna", km)]] <- log(terra::extract(km2_ok, vect(b), fun = sum,
                                    na.rm = TRUE, exact = TRUE)[, 2] + 1)
}
round(rbind(`50 km`  = c(did_at("lna50"),  placebo_t = pl_at("lna50")[3]),
            `100 km` = c(did_at("lnarea"), placebo_t = pl_at("lnarea")[3]),
            `200 km` = c(did_at("lna200"), placebo_t = pl_at("lna200")[3])), 3)

# The radius was a choice and their footnote says it does not matter. Here it
# does not matter either. The estimate rises gently with the catchment and
# every placebo stays quiet. Second diagnostic passed.


# ---- Slide 44. Estimate a coefficient for every year -------------------------
yrs <- sort(unique(panel$year))
D   <- sapply(yrs, function(y) panel$dose * (panel$year == y))
colnames(D) <- paste0("d", yrs)
keep <- setdiff(colnames(D), "d1700")        # 1700 is the reference year

es <- lm(reformulate(c(keep, "factor(city_jjk)", "factor(year)"), "lpop"),
         data = cbind(panel, as.data.frame(D[, keep])))
round(coeftest(es, vcov. = vcovCL(es, cluster = panel$city_jjk))[keep, ], 4)

# One interaction per year in place of one interaction with post. Every
# coefficient is RELATIVE TO 1700, so the level of any one carries no
# information. The shape does. This is the test the placebo could not run,
# because the placebo only looked backward.


# ---- Slide 45. FIGURE, baked. The rise comes a century early -----------------
ctes <- coeftest(es, vcov. = vcovCL(es, cluster = panel$city_jjk))[keep, ]
b   <- c(ctes[1:2, 1], 0, ctes[3, 1]);  s <- c(ctes[1:2, 2], 0, ctes[3, 2])
bar <- s > 0
par(mar = c(3.6, 4.2, 0.6, 0.6))
plot(yrs, b, type = "n", xlab = "", ylab = "suitable land interacted with year",
     ylim = range(c(b - 2*s, b + 2*s)) + c(-0.005, 0.005), xaxt = "n")
axis(1, at = yrs, labels = yrs)
abline(h = 0, col = "grey55"); abline(v = 1700, lty = 2, col = "grey55")
arrows(yrs[bar], (b - 1.96*s)[bar], yrs[bar], (b + 1.96*s)[bar], angle = 90,
       code = 3, length = 0.04, col = "grey35")
lines(yrs, b, col = "#b40000", lwd = 2)
points(yrs, b, pch = 21, bg = c("#b40000", "#b40000", "white", "#b40000"), cex = 1.2)

# READ THE SHAPE. Relative to 1700, high-dose cities were 0.037 lower in 1600
# and 0.019 lower in 1800. The ONLY rise in the series is the step from 1600
# into 1700, and by their own dating the potato is not a field crop until
# after it. The positive estimate on slide 40 IS that step.
#
# With one period on each side of 1700 this panel cannot tell an early potato
# from something else entirely. That is why they need twelve periods, and it
# is the honest limit of what we can say. Slide 46 is what theirs looks like:
# a level for six centuries, then a turn after 1750.


# ---- Slide 47. PREDICT. The date was a choice too ----------------------------
# PREDICT: their post period starts at 1750, so 1700 is a PRE year for them
# and a POST year for us. Move our cutoff to 1800 and rerun. What happens?
round(rbind(`post from 1700, ours`   = did_at("lnarea", cut = 1700),
            `post from 1800, theirs` = did_at("lnarea", cut = 1800)), 4)

# The event study already told you this. The whole effect was the step into
# 1700. Date the treatment after that step, as they do, and there is nothing
# left. Two diagnostics passed and the third, the one that reads the paper's
# own chronology, did not. That is a fair summary of what a four-period panel
# can say about a twelve-period claim.


# ---- Slide 48. PREDICT. The shortcut -----------------------------------------
# PREDICT: skip the buffer. Extract the single cell under each city and run
# the same regression. What SIGN do you get, and does its placebo stay quiet?
round(rbind(`buffer, 100 km`   = c(did_at("lnarea"), placebo_t = pl_at("lnarea")[3]),
            `pixel under city` = c(did_at("suit"),   placebo_t = pl_at("suit")[3])), 3)

# WRONG SIGN, AND ITS PLACEBO FIRES. Replace the buffer with the pixel and the
# same regression says better potato land grew SLOWER. Nothing about the
# potato changed. One column did.
#
# If anyone asks whether the minus is just the file's coding (high = bad in
# the raw file), it is not: suit is already flipped so high = good, and running
# the raw scale gives +0.0886, an exact mirror. Same sentence twice, both
# contradicting the paper.
#
cty %>% filter(countryname == "Ireland") %>%
  transmute(city = city_jjk, raw, suit, mean100 = round(suit100, 2)) %>%
  arrange(suit) %>% print(n = 5)

# Dublin sits on a cell the FAO rates VERY MARGINAL, with only 7 of our 1,010
# cities on worse ground, while the land within 100 km of it averages 3.8.
# A model writes the pixel version instantly, because it is one line. It is
# not Ireland's potato ground. That is the two-line version, and it failed.


# ---- Slide 49. So what do you do about it? No code. --------------------------
# Twelve periods, other-crop and geography controls x year, Old World only,
# and pages defending the timing. Two of their diagnostics we could run
# passed; the third, their own chronology, removed the result. Callaway,
# Goodman-Bacon and Sant'Anna (2024) on continuous doses: TWFE needs STRONG
# parallel trends, parallel at every dose, not on average. Roth et al. (2023)
# for the rest.


# ============================ APPENDIX, off the main path ====================
# Three blocks kept for questions. None is needed for the lecture to work.


# ---- Appendix, slide 56. PREDICT. Reading a reclassify matrix --------------------------
# PREDICT: row one of that matrix was 0, 4, 1. Why does it start at zero
# rather than at one? And what breaks if you write 1 instead?
#
probe <- rast(nrows = 1, ncols = 9)          # nine cells, one per class
values(probe) <- 1:9
cl <- function(v) values(classify(probe, matrix(v, ncol = 3,
                                                byrow = TRUE)))[, 1]

rbind(class   = 1:9,
      from_0  = cl(c(0,4,1,  4,7,2,  7,8,3,  8,9,NA)),
      from_1  = cl(c(1,4,1,  4,7,2,  7,8,3,  8,9,NA)),
      relabel = cl(c(1,4,10, 4,7,20, 7,8,30, 8,9,NA)))

#
#   1. Every interval is (from, to], OPEN ON THE LEFT. So (1,4] misses class 1.
#   2. No other row covers class 1 either.
#   3. classify() leaves an uncovered value UNCHANGED. It does not NA it.
#   4. Class 1 therefore comes back as 1, which is also the code the first bin
#      uses. The two tables are byte-identical.
#
# The relabel row is the reveal. Give the bins codes of 10, 20, 30 and class 1
# still comes out as 1 while 2, 3 and 4 come out as 10. Now you can see it.
#
# Cost of the typo: 20 cells in this crop and 520 worldwide. Latent today,
# live the moment someone changes the bin codes or reuses the pattern.
#
# One more thing worth knowing: right = FALSE flips every interval to
# [from, to), which moves class 4 into the second bin and class 8 into NA.
# Three of the four rows change meaning and nothing warns you.
classify(probe, matrix(c(0,4,1, 4,7,2, 7,8,3, 8,9,NA), ncol = 3,
                       byrow = TRUE), right = FALSE) |> values() |> as.vector()


# ---- Appendix, slide 57. What the sample throws away -----------------------------------
eu <- crop(potato, eu_box); ed <- crop(drawn, eu_box)
lake <- function(r) patches(ifel(r == 9, 1, NA), directions = 8)

round(c(step      = res(drawn)[1] / res(potato)[1],
        pct_full  = 100 * mean(values(eu) == 9, na.rm = TRUE),
        pct_drawn = 100 * mean(values(ed) == 9, na.rm = TRUE),
        n_full    = length(unique(values(lake(eu), na.rm = TRUE))),
        n_drawn   = length(unique(values(lake(ed), na.rm = TRUE)))), 2)

# THIS IS THE PAIR THAT MATTERS. The water SHARE is 1.70 percent at full
# resolution and 1.83 percent in the picture, so the histogram is fine. The
# number of separate bodies of inland water falls from 412 to 63.
#
# Why: a regular sample is a fair draw from the marginal distribution, so any
# summary over cells comes back almost right. What it cannot preserve is a
# feature narrower than its own step, and the step here is 4.3 cells, about
# 26 km at fifty north. Anything thinner falls between the samples or merges
# into a neighbour.
#
# Now the plant for after the break. Of the seven cities in tonight's sample
# standing on a water cell, three read a LAND class once the layer is drawn:
w_raw <- terra::extract(potato, vect(pts))[, 2]
w_drw <- terra::extract(drawn,  vect(pts))[, 2]
cbind(city = cty$city_jjk, full = w_raw, drawn = w_drw)[which(w_raw == 9), ]

# Enkhuizen, Harderwijk and Medemblik lose the Zuiderzee and come out on
# farmland. Slide 31 is where that paid off.


# ---- Appendix, slide 58. PREDICT. A dose that should do nothing --------------
# PREDICT: same buffer, but the dose is now the log of ALL land within 100 km,
# suitable or not. Potatoes have nothing to do with it. What do we get?
land    <- ifel(is.na(potato) | potato == 9, NA, 1)
all_km2 <- terra::extract(cellSize(potato, unit = "km") * land,
                          vect(b100), fun = sum, na.rm = TRUE, exact = TRUE)[, 2]
cty$lnland <- log(all_km2 + 1)

round(rbind(`ln ALL land within 100 km` = did_at("lnland")), 4)
cor(cty$lnarea, cty$lnland, use = "complete.obs")

# t = -4.38 on a variable with no potatoes in it: a city with more land around
# it grew more slowly after 1700, which is mostly a statement about ports.
# The omitted dose enters NEGATIVE and correlates POSITIVE (0.39) with the one
# we kept, so leaving it out pushed the estimate DOWN. Put both in:
pj <- cty %>% select(city_jjk, lnarea, lnland,
                     pop1500, pop1600, pop1700, pop1800) %>%
  pivot_longer(starts_with("pop"), names_to = "year", values_to = "pop",
               names_prefix = "pop", names_transform = as.integer) %>%
  filter(pop > 0, !is.na(lnarea), !is.na(lnland)) %>%
  mutate(lpop = log(pop), post = as.integer(year >= 1700))
mj <- lm(lpop ~ lnarea:post + lnland:post + factor(city_jjk) + factor(year),
         data = pj)
round(coeftest(mj, vcov. = vcovCL(mj, cluster = pj$city_jjk))[
        c("lnarea:post", "post:lnland"), ], 4)

# 0.0211 becomes 0.0448. Controlling for the confound makes their variable
# BIGGER. A confound does not always flatter you, and which way it pushes is
# arithmetic rather than intuition.
