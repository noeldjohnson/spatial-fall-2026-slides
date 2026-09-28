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
which is exactly why it is in Week 1. `NA` from `st_crs()$epsg` means
somebody built a projection the registry does not name; the file itself is complete.

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

### `mita_boundary.shp` — the boundary of the Peruvian mita

Two linestrings in WGS84 (EPSG:4326), cut from the replication package for Melissa
Dell (2010), "The Persistent Effects of Peru's Mining Mita", *Econometrica* 78(6),
1863--1903. This is the line the colonial state drew in 1573 to mark which districts
owed forced labor to the mines at Potosi and Huancavelica. It stopped binding in 1812.

Used in Week 3 to build the running variable. The whole design turns on the fact that
`st_distance()` from a district to the mita *polygon* returns zero, because a polygon
contains its own interior, so you need `st_boundary()` and a sign.

### `peru_districts.shp` — district polygons for the study region

299 district polygons keyed on `ubigeo`, from the same replication package. These are
the units Dell georeferences and the ones the running variable is measured from.

### `peru_mita_districts.csv` — the district-level analysis file

299 rows carrying the mita dummy, childhood stunting, the number of children, elevation,
slope, the boundary-segment fixed effects, and Dell's own `d_bnd` so you can check your
running variable against hers rather than take mine on faith.

**The latitudes and longitudes in this file are stored unsigned.** Peru is south and
west, so every one of them has the wrong sign until you fix it. That is how Dell stores
them and it is shipped that way on purpose. It is the Week 3 lesson about looking at
your coordinates before you measure anything with them. Correct it, and notice what you did.

### `abramson_states_1340.shp` and `abramson_states_1425.shp` — European polities

Two snapshots of European polity borders, from Scott F. Abramson's polygon data
underlying *The Economic Origins of the Territorial State* (2017). Abramson traced the
borders of roughly two hundred and seventy polities at five-year intervals across six
centuries.

Used at the end of Week 3 for the contrast that makes the mita design work. The French
border moved substantially in the 85 years around the start of the Hundred Years' War,
while the mita line moved not at all in 239 years. A boundary that moves, follows rivers and
mountains, and sorts people for centuries is cheap to compute and impossible to defend
as a discontinuity. The same files then carry the frame where the boundary is the
outcome rather than the design.


---

### `gaez_potato_suitability.tif` — potato suitability, 5 arc-minute raster

The FAO and IIASA Global Agro-Ecological Zones potato suitability surface, global
coverage at 5 arc-minutes, in WGS84 (EPSG:4326). It is the same product Nunn and
Qian use to build their treatment in "The Potato's Contribution to Population and
Urbanization" (*QJE*, 2011), and their Figure II is a map of it.

**Read the scale before you read any number from this file.** It runs *downward*.

| value | meaning | value | meaning |
|---|---|---|---|
| 1 | very high | 6 | marginal |
| 2 | high | 7 | very marginal |
| 3 | good | 8 | not suitable |
| 4 | medium | 9 | **inland water** |
| 5 | moderate | | |

Low numbers are good land. Nine is not a suitability at all, it is water, and it is
also the largest number on the scale. Take the file at face value and the seven
cities in our sample that sit on lake or fjord cells become the most potato-suitable
cities in Europe. Nunn and Qian call land suitable at class 4 or better.

The file carries a grid, a CRS and nine integers. It does not carry any of the above,
which is the Week 4 lesson about codebooks. Used in Week 4 for the raster material and
for the difference-in-differences treatment.

This file is an older GAEZ release, downloaded for the course in 2019, and Nunn and
Qian used the 2002 release. The current release, version 4, sits on the same grid and
classifies a real share of cells differently. Week 5 downloads it and compares.

### `wk05/` — the making-data week

**`gold_coast_1911.png`.** A scan of *Map of the Gold Coast, Ashanti and Northern
Territories*, War Office, 1911, G.S.G.S. No. 2593, printed at the Ordnance Survey
Office, Southampton, in 1912. The stamp shows it reached the Geographical Section of
the General Staff map room on 20 March 1912. All of that is printed on the sheet. The
source of the scan itself is unrecorded. It came to the course in 2022 from Richard
Bluhm's teaching material. The sheet is long out of copyright.

**`gold_coast_1911_gcps.csv` and `gold_coast_1911.points`.** The six ground control
points used in class, the same content in two formats. R reads the csv, and QGIS's
Load GCP Points dialog looks for `.points`. Four sit on graticule crossings and two on
the towns of Salaga and Dadiaso. Pixel rows are stored as negative numbers, which is
the QGIS convention.

**`sekondi_kumasi_trace.gpkg`.** One digitized line, the Sekondi–Kumasi railway traced
from the georeferenced sheet in 67 clicks, 28 September 2026. It was traced on a warp
whose western longitudes had lost their minus signs, and this copy has them restored.

**`ghana_rail_1911.shp` and `ghana_cities_empty.shp`.** Layers digitized by the 2022
version of this course. The railway layer holds a partial trace and a stray line. The
cities layer holds no features at all. Both are here as they were found.

**`gold_coast_1911.qgz`.** The 2022 QGIS project.

**`siHr_wpo.tif`, `siHr_whe.tif`, `siHr_brl.tif`, `siHr_mze.tif`.** FAO and IIASA,
Global Agro-Ecological Zones version 4 (GAEZ v4), crop suitability index in classes
for all land in the grid cell, rain-fed, high input, 1981–2010 climate, for white
potato, wheat, barley and maize. Downloaded 27 September 2026 from

`https://s3.eu-west-1.amazonaws.com/data.gaezdev.aws.fao.org/res05/CRUTS32/Hist/8110H/`

followed by the file name. The codes are 0 no data, 1 to 7 suitability from very high
to very marginal, 8 not suitable, and 9 water. The ocean is 0, not NA. FAO's requested
citation is "FAO and IIASA. Global Agro Ecological Zones version 4 (GAEZ v4)," with
the date accessed.

**Files you make.** `gold_coast_1911_georef.tif` (the week's script or your QGIS
session builds it), `my_rail.gpkg` (your trace), and any `.aux.xml` file QGIS writes
are ignored by git, so they never collide with a pull.

## Reusing any of this

The R code in `code/` is mine and you may reuse it freely, with attribution.

Several of the datasets belong to other scholars, as the entries above make clear. They are here as
teaching extracts. If you want to build a paper on one of them, go to the original
source, read its terms, and cite it properly rather than citing this repository.
