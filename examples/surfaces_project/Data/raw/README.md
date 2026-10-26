# Raw data

All files are read-only. Scripts write anything derived to `output/` or
`Data/processed/`.

## mort274.csv

Black Death mortality for 274 European cities, from Jedwab, Johnson, and Koyama
(2019), *Negative Shocks and Mass Persecutions: Evidence from the Black Death*,
Journal of Economic Growth 24(4). Columns are `city_jjk`, `countrynam`,
`longitude`, `latitude` (decimal degrees, WGS84), and `mortality`, the percent of
the city's population that died in 1347--1352 as compiled from the sources the
paper's appendix lists.

## europe_cities_1801.csv

A gazetteer of 1,801 European cities with present-day coordinates. Columns are
`city_jjk`, `countryname`, `longitude`, `latitude`. Two names, ALBA and HALLE, each
belong to two cities and are dropped before use.

## europe_modern.shp

Modern European country borders in an equidistant conic projection (meters), used
to mask interpolated surfaces to land.

## guiot_corona_2010.csv and guiot_corona_2010_points.csv

Guiot and Corona (2010), *Growing Season Temperatures in Europe and Climate
Forcings over the Past 1400 Years*, PLoS ONE 5(4), as archived by NOAA's World
Data Center for Paleoclimatology. April to September temperature anomalies in
degrees Celsius relative to 1961--1990 on a 5 degree grid of 125 points
(27.5N to 72.5N, 7.5W to 57.5E), here for the years 1100 to 1800. Columns are
`gp` (grid point id), `lon`, `lat`, `year`, `anomaly`. The points file lists each
point once. Anderson, Johnson, and Koyama (2017) interpolate this grid to cities.

## africa_lights_2000.tif

DMSP-OLS Nighttime Lights Time Series, version 4, satellite F15, year 2000,
stable lights average visible band, cropped to Africa (18W to 52E, 35S to 38N).
NOAA National Geophysical Data Center. 30 arc-second cells. Values are a digital
number from 0 (no detected light) to 63 (the sensor saturates there).

## africa_popdens_2000.tif

Gridded Population of the World, version 3, population density for 2000,
unadjusted, persons per square kilometer, CIESIN and CIAT, cropped to Africa.
2.5 arc-minute cells.

## africa_scale.shp

Natural Earth admin-0 countries, Africa, 51 features. `admin` is the country name.
