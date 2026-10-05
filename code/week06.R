# ==============================================================================
# ECON 895  Spatial Techniques in Empirical Economics
# Week 6, 5 October 2026.  Language Models as Data Constructors
#
# HOW TO USE THIS FILE
#   1. Open ECON895.Rproj first, so every path below starts from the repo root.
#   2. Work down the file in order. The second block uses objects the first one
#      builds.
#   3. Each block's heading gives its slide number in the deck.
#   4. Blocks marked PREDICT are the ones we voted on in class. The question is
#      in the comment and the answer is not. Commit to an answer, then run.
#
# Most of this week has no R. Slides 9-21 cover Claude Code, git, and the
# research template; the handout handouts/research_project_setup.pdf has the
# same material on one page. Slide 27 is a live demo in Claude Code, and the
# project it uses is in examples/geocode_project/ with instructions in
# examples/README.md.
#
# The model's answers are in data/wk06_llm_geocodes.csv. Its header records the
# model, the date, and the prompt, and is skipped by comment = "#" below.
# ==============================================================================

library(tidyverse)
library(sf)


# ---- SETUP -------------------------------------------------------------------
llm   <- read_csv("data/wk06_llm_geocodes.csv", comment = "#", show_col_types = FALSE)
truth <- read_csv("data/europe_cities_1801.csv", show_col_types = FALSE) %>%
  filter(!(is.na(longitude) | is.na(latitude)))

nrow(llm)      # twenty names, answered from the model's memory


# ---- Slide 24. PREDICT. Predict before you look ------------------------------
# PREDICT: twenty city names, no other context. How many of the model's answers
# land within 25 km of the gazetteer's coordinates?
check <- llm %>% inner_join(truth, by = c("name" = "city_jjk"))

km_apart <- function(d) as.numeric(st_distance(
  st_as_sf(d, coords = c("lon", "lat"),             crs = 4326),
  st_as_sf(d, coords = c("longitude", "latitude"),  crs = 4326),
  by_element = TRUE)) / 1000
check$err_km <- km_apart(check)

data.frame(rows = nrow(check), within_25km = sum(check$err_km < 25),
           median_km = round(median(check$err_km), 1))

# Each error is the great-circle distance in kilometers between the model's
# answer and the gazetteer. Look at the first column before the other two.


# ---- Slide 25. PREDICT. One answer is 546 kilometers off ---------------------
# PREDICT: whose error is the 546 kilometers, the model's or someone else's?
check %>% arrange(desc(err_km)) %>%
  mutate(err_km = round(err_km, 1)) %>%
  select(name, countryname, lat, lon, confidence, err_km) %>%
  head(3) %>% as.data.frame() %>% print(row.names = FALSE)


# ---- Slide 26. Twenty names went in and twenty-one rows came back ------------
c(names_sent = nrow(llm), rows_returned = nrow(check))

# The twenty names came from German and Austrian entries, so HALLE meant the
# German Halle, and the model placed it 1.9 km away. The join on the name alone
# matched it to the Belgian Halle as well, and that row carries the 546 km.
#
# Try it yourself. Add relationship = "one-to-one" to the inner_join above and
# rerun it. Then repair the join by keeping only the German and Austrian rows
# of truth before joining, and recompute the median.
