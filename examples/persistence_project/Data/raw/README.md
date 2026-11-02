# Raw data for the persistence project

Three inputs, all from the ECON 895 course repository's `data/` folder. Nothing
here is modified.

**`europe_cities_1801.csv`.** The city gazetteer: 1,801 European cities with
`city_jjk`, `countryname`, `longitude`, and `latitude` (WGS 84). Two names,
ALBA and HALLE, each belong to two cities and are dropped before any join on
the name.

**`europe_press_1500.csv`.** One row per city in the printing data: `city_jjk`,
`print_date` (year of the first press, NA if none by 1500), and populations in
thousands, `pop1500` through `pop1800`. Populations come from Bairoch, Batou,
and Chevre (1988) as used by Dittmar (2011) and in Weeks 2 and 7.

**`europe_modern.shp`.** Modern country borders, in an equidistant conic
projection with a complete `.prj`. Used for maps only.
