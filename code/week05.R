# ==============================================================================
# ECON 895  Spatial Techniques in Empirical Economics
# Week 5, 28 September 2026.  Making Data
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
#
# THIS WEEK HAS THREE TRACKS, and only one of them is R.
#   Slide 6 is a click path in a browser, at gaez.fao.org.
#   Slides 20, 21 and 24 are done in QGIS. Slides 22 and 25 are the tables of
#   what goes wrong there and what to do about it.
#   Everything else is below.
#
# No new packages this week. You need tidyverse, sf and terra, which you have.
#
# THE FILE NAMES MATTER. The QGIS slides tell you to save two things:
#   data/wk05/gold_coast_1911_georef.tif   your georeferenced map
#   data/wk05/my_rail.gpkg                 your railway trace
# The SETUP block builds the first one for you if it is missing, so the R half
# works whether or not your QGIS session did. If you saved your own warp under
# that name, the blocks from slide 27 on read yours instead.
#
# The data are described in DATA_SOURCES.md, under data/wk05/.
# ==============================================================================

library(tidyverse)
library(sf)
library(terra)


# ---- SETUP -------------------------------------------------------------------
W        <- "data/wk05"
scan_png <- file.path(W, "gold_coast_1911.png")
gcp      <- read_csv(file.path(W, "gold_coast_1911_gcps.csv"), show_col_types = FALSE)
georef   <- file.path(W, "gold_coast_1911_georef.tif")

# Build the georeferenced map from the scan and the six control points, the
# same order-1 fit QGIS does. It takes about a minute and only runs once. The
# warp writes to a temporary file first, so stopping it halfway leaves nothing
# broken behind.
if (!file.exists(georef)) {
  message("building the georeferenced raster, about a minute...")
  a <- character(0)
  for (i in seq_len(nrow(gcp)))
    a <- c(a, "-gcp", sprintf("%.6f", gcp$pixelX[i]), sprintf("%.6f", -gcp$pixelY[i]),
           sprintf("%.6f", gcp$mapX[i]),  sprintf("%.6f", gcp$mapY[i]))
  vrt <- tempfile(fileext = ".vrt"); out <- tempfile(fileext = ".tif")
  gdal_utils("translate", scan_png, vrt,
             options = c("-of", "VRT", a, "-a_srs", "EPSG:4326"))
  gdal_utils("warp", vrt, out,
             options = c("-t_srs", "EPSG:4326", "-order", "1", "-r", "near",
                         "-co", "COMPRESS=DEFLATE", "-co", "TILED=YES"))
  file.copy(out, georef); unlink(c(vrt, out))
}

africa <- st_read("data/africa_scale.shp", quiet = TRUE)
ghana  <- africa %>% filter(grepl("Ghana", admin, ignore.case = TRUE))

# Week 4's cities. ALBA and HALLE are one name for two cities each, as Week 2
# found, so they come out.
cities <- read_csv("data/europe_cities_1801.csv", show_col_types = FALSE)
cty <- cities %>% filter(!city_jjk %in% c("ALBA", "HALLE"))
pts <- st_as_sf(cty, coords = c("longitude", "latitude"), crs = 4326)


# ---- Slide 7. The same download in R -----------------------------------------
url <- paste0("https://s3.eu-west-1.amazonaws.com/",
              "data.gaezdev.aws.fao.org/",
              "res05/CRUTS32/Hist/8110H/", "siHr_wpo.tif")
f <- "data/wk05/siHr_wpo.tif"
if (!file.exists(f)) download.file(url, f, mode = "wb")

potato_v4 <- rast(f)
potato_v3 <- rast("data/gaez_potato_suitability.tif")
compareGeom(potato_v4, potato_v3)

# The URL is the Data Viewer's filter panel written out. res05 is the
# suitability module, CRUTS32/Hist is the historical climate, 8110H is
# 1981-2010 at high input, si is the suitability class variable, Hr is high
# input and rain-fed, and wpo is white potato. Change wpo to whe for wheat.
# The file is already in data/wk05, so the download only runs if you delete it.


# ---- Slide 8. PREDICT. New numbers on the same grid -------------------------
# PREDICT: the classes run from 1 to 9. What is the global mean of this file?
freq(potato_v4)[1:3, ]

global(potato_v4, "mean")
global(classify(potato_v4, cbind(0, NA)), "mean", na.rm = TRUE)

# Look at the first row of freq() before you look at the means. The portal's
# legend says what 0 means. The file does not.
#
# The version matters as much as the zeros. Week 4's file is an older release
# on the same grid, and Nunn and Qian used the 2002 release. Most land cells
# keep their class between versions, and a real share do not. Whatever you
# download for your paper, record the version and the date.


# ---- Slide 9. Four crops as one object ---------------------------------------
crops <- c(potato = "wpo", wheat = "whe", barley = "brl", maize = "mze")
files <- paste0("data/wk05/siHr_", crops, ".tif")

suit <- rast(files); names(suit) <- names(crops)
dim(suit)                              # rows, columns, layers
names(suit)

at_city <- terra::extract(suit, vect(pts))[, -1]
sapply(at_city, function(v) mean(v %in% 1:4))

# rast() stacks the four files because their grids match. Give it two files on
# different grids and it refuses, which is the check you want. One extract()
# then returns one column per layer. terra::extract() is spelled out because
# tidyr has an extract() too, as Week 4 warned.


# ---- Slide 14. Georeferencing is a regression --------------------------------
fit1 <- lm(cbind(mapX, mapY) ~ pixelX + pixelY, data = gcp)

sqrt(mean(rowSums(residuals(fit1)^2)))   # RMS miss per point, degrees

# World coordinate on the left, pixel position on the right. This is the
# order-1, or affine, transformation that QGIS calls Polynomial 1.


# ---- Slide 15. Two regressions in one call ----------------------------------
coef(fit1)                                   # one column per equation

coef(lm(mapX ~ pixelX + pixelY, data = gcp)) # the first column, alone

# cbind() on the left fits one regression for longitude and one for latitude,
# on the same regressors. Each column is ordinary OLS, and the two columns
# together are the six parameters of the affine transformation. The equations
# meet only in rowSums() on slide 14, which adds each point's two misses.


# ---- Slide 16. PREDICT. Does a more flexible transformation fit better? -----
# PREDICT: six control points, and we fit the order-2 polynomial, which has
# six coefficients per equation. What residual does it report?
fit2 <- lm(cbind(mapX, mapY) ~ poly(pixelX, 2, raw = TRUE) +
             poly(pixelY, 2, raw = TRUE) + pixelX:pixelY, data = gcp)

c(order1 = sqrt(mean(rowSums(residuals(fit1)^2))),
  order2 = sqrt(mean(rowSums(residuals(fit2)^2))))

# Count the numbers the fit has to match and the coefficients it has to match
# them with. A residual measures fit at the points you chose.


# ---- Slide 17. Hold a point out ----------------------------------------------
loo <- sapply(seq_len(nrow(gcp)), function(i) {
  m <- lm(cbind(mapX, mapY) ~ pixelX + pixelY, data = gcp[-i, ])
  p <- predict(m, newdata = gcp[i, ])
  sqrt(sum((as.numeric(p) - as.numeric(gcp[i, c("mapX", "mapY")]))^2))
})
c(in_sample = sqrt(mean(rowSums(residuals(fit1)^2))) * 111,
  held_out  = sqrt(mean(loo^2)) * 111)   # km, at about 111 km a degree

# Fit on five points, predict the sixth, six times over. Both numbers are RMS
# misses per point, so they compare directly. The held-out one is the map's
# accuracy budget, which slide 18 unpacks. Multiplying degrees by 111 is close
# enough here: between 5N and 10N a degree of longitude is within 2 percent of
# a degree of latitude.
#
# Try it yourself: run the same leave-one-out loop with the order-2 formula
# from slide 16, and compare. lm() will drop a term when five points have to
# support six coefficients, so read what it prints.


# ---- Slide 27. The warped raster in R ----------------------------------------
sheet <- rast("data/wk05/gold_coast_1911_georef.tif")

c(rows = nrow(sheet), cols = ncol(sheet), bands = nlyr(sheet))
crs(sheet, describe = TRUE)$name
round(as.vector(ext(sheet)), 2)

# If this is your own QGIS warp, check the extent before anything else. The
# sheet runs from about 4.4 W to 1.5 E. If your xmin and xmax come out
# positive, a longitude lost its minus sign, as on the slide 22 table.


# ---- Slide 28. Does it land where it should? ---------------------------------
par(mar = c(0, 0, 0, 0))
plotRGB(sheet, stretch = "lin", maxcell = 8e5, ext = ext(-3.6, 1.4, 4.4, 11.3))
plot(st_geometry(ghana), border = "#b40000", lwd = 2.2, add = TRUE)

# The heavy red line is the modern boundary. Look at the coast, the western
# frontier, and then the east, before you read the slide's caption.


# ---- Slide 29. The Sekondi-Kumasi railway, traced ----------------------------
rail <- st_read("data/wk05/sekondi_kumasi_trace.gpkg", quiet = TRUE)
par(mar = c(0, 0, 0, 0))
plotRGB(sheet, maxcell = 4e6, ext = ext(-2.3, -1.0, 4.8, 6.85))
plot(st_geometry(rail), col = "#2f6fa8", lwd = 3, add = TRUE)

# One trace in 67 clicks, from Sekondi on the coast to Kumasi, which the sheet
# spells Coomassie. It was first digitized on a warp whose western longitudes
# had lost their minus signs, and the copy here has them restored.


# ---- Slide 30. Measuring the trace -------------------------------------------
rail <- st_read("data/wk05/sekondi_kumasi_trace.gpkg", quiet = TRUE)

round(c(km       = as.numeric(st_length(rail)) / 1000,
        vertices = nrow(st_coordinates(rail))), 1)

# The line as built ran 168 miles, or 269 km. st_length() returns meters on
# EPSG:4326 because sf measures on the sphere.


# ---- Slide 31. Your own trace ------------------------------------------------
# Runs only if you saved a trace under the name the digitizing slide gave. If
# QGIS also saved a project inside the GeoPackage, st_read() warns that it
# picked the first layer. The layer argument below settles it.
if (file.exists("data/wk05/my_rail.gpkg")) {
  mine <- st_read("data/wk05/my_rail.gpkg", layer = "my_rail", quiet = TRUE)
  print(round(c(km = sum(as.numeric(st_length(mine))) / 1000,
                vertices = nrow(st_coordinates(mine))), 1))
  print(st_bbox(mine))
}

# Compare your length with slide 30 and with the person next to you. A trace
# cuts every curve it does not follow. The bounding box is the quick check that
# your trace is where the railway is, between about 1.6 W and 2.0 W.


# ---- Slide 32. PREDICT. Shapefiles abbreviate field names --------------------
# PREDICT: we write a column called a_very_long_field_name to a shapefile and
# read it straight back. What is the column called?
demo <- st_sf(
  a_very_long_field_name = 1:2,
  another_long_one = c("x", "y"),
  geometry = st_sfc(st_point(c(0, 0)), st_point(c(1, 1)),
                    crs = 4326))
f <- tempfile(fileext = ".shp");  st_write(demo, f, quiet = TRUE)
g <- tempfile(fileext = ".gpkg"); st_write(demo, g, quiet = TRUE)

names(st_read(f, quiet = TRUE))
names(st_read(g, quiet = TRUE))

# Read the console carefully, including anything printed between the lines of
# output. That is the whole lesson of this block.
