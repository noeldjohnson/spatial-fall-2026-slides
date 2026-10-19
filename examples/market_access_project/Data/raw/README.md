# Raw data

All six files are read-only. Scripts write anything derived to `output/` or
`Data/processed/`.

The four GeoPackages share one coordinate reference system, an equidistant conic
for Europe with standard parallels at 43 N and 62 N and meters as units. Its PROJ
string is in the project `CLAUDE.md`.

## roman_roads.gpkg

1,585 line features. The Roman road network from the Digital Atlas of Roman and
Medieval Civilizations (McCormick et al. 2013, Harvard Center for Geographic
Analysis, CC BY-NC). Used as a transport layer with relative cost 0.81.

## medieval_routes.gpkg

56 line features. Medieval trade routes digitized from the map in Shepherd's
Historical Atlas (1923), as used in Johnson and Koyama (2017). Relative cost 0.81.

## rivers.gpkg

184 line features with a `name` column. Major European rivers from Natural Earth
(public domain). Relative cost 0.21.

## seas.gpkg

One multipolygon. Oceans and seas from Natural Earth (public domain), clipped to
the European window and simplified with a 500 m tolerance in the projected CRS.
Relative cost 0.08.

## europe_cities_1801.csv

A gazetteer of 1,801 European cities with present-day coordinates. Columns are
`city_jjk` (the city name in capitals), `countryname`, `longitude` and `latitude`
(decimal degrees, WGS84). Two names, ALBA and HALLE, each belong to two cities and
are dropped before any join. The file is the same as `data/europe_cities_1801.csv`
in the ECON 895 course repository, whose `DATA_SOURCES.md` describes its source.

## europe_press_1500.csv

City populations in thousands for 1500, 1600, 1700, and 1800 (`pop1500` to
`pop1800`), with a `city_jjk` key matching the gazetteer, for 1,019 cities. From the
Bairoch city population data as compiled for Dittmar (2011) and Johnson and Koyama
(2017). A blank or zero population means no estimate for that year.

The relative costs are Bairoch's estimates for early modern Europe and are stated
in the project `CLAUDE.md`.
