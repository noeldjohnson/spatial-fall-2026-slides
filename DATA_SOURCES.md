# Where the data came from

A course that argues you should know the provenance of every number owes you this
page. Each dataset below says what it is, where it came from, and what it is doing
in the course.

If you spot an attribution here that is wrong or incomplete, tell me. That is a
contribution, not a nuisance.

---

### `africa_scale.shp` — African country polygons

Natural Earth, small-scale (1:110m) admin-0 boundaries, in WGS84 (EPSG:4326).
Natural Earth is in the public domain. https://www.naturalearthdata.com/

Used in Week 1 for the opening map, the CRS checks, and the spatial join.

### `africa_cities.csv` — African city points

A gazetteer of African cities with coordinates and population. Used in Week 1 as
the points side of the spatial join, and as the source of the Tanzania name
mismatch we walked through in class.

### `europe_cities_1801.csv` — European cities circa 1801

From the Johnson and Koyama city-growth data, built for research on European city
growth. `city_jjk` is the city identifier in that dataset. Mainz is in here, which
is the point: it is where Week 2 ends up.

See Johnson and Koyama (2017), "Jewish communities and city growth in preindustrial
Europe", *Journal of Development Economics* 127, 339–354.

### `europe_modern.shp` — modern European country polygons

A shapefile from a published replication package, kept deliberately in the state it
arrived in. It carries a custom equidistant conic projection with **no EPSG code**,
which is exactly why it is in Week 1. `NA` from `st_crs()$epsg` does not mean the
file is broken. It means somebody built a projection the registry does not name.

### `europe_press_1500.csv` — press adoption dates and city populations

Printing press adoption dates, 1450--1500, and city populations at 1500, 1600,
1700 and 1800, for 1,019 European cities. Keyed on `city_jjk` so it joins to
`europe_cities_1801.csv`. Four extra columns carry rivers, Roman roads, capital
status and communal government, which the Week 2 replication attempt uses.

Extracted from Noel's work in progress on plague, print, and persecution.
Population is Bairoch and Chandler as assembled in the Johnson and Koyama city
data, which is the same source Dittmar (2011) uses. The adoption dates descend
from the standard incunabula lists.

Used in Week 2 for the first stage, the IV estimate, and the attempt to
reproduce Dittmar's Table VII.

Two names in this file, ALBA and HALLE, each denote two different cities. Week 2
drops them by hand rather than let a one-to-many join duplicate rows silently.

### `cps08.csv` — Current Population Survey extract, 2008

The teaching extract distributed with Stock and Watson, *Introduction to
Econometrics*. Hourly earnings, education, sex, and age. Used in Week 2 only, as a
plain rectangular dataset for the tidyverse material, before any geometry appears.

---

## Reusing any of this

The R code in `code/` is mine and you may reuse it freely, with attribution.

The datasets are not all mine, as the entries above make clear. They are here as
teaching extracts. If you want to build a paper on one of them, go to the original
source, read its terms, and cite it properly rather than citing this repository.
