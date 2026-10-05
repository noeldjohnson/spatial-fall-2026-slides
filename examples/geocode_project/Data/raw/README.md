# Raw data

Both files are read-only. Scripts write anything derived to `Data/processed/`.

## llm_geocodes.csv

A language model's coordinates for twenty historical city names, answered from
memory. The model, the date, the interface and the verbatim prompt are in the
file's comment header. The names were chosen from the German and Austrian
entries of the gazetteer below, seventeen German and three Austrian. Columns
are `name`, `lat`, `lon` (decimal degrees, WGS84) and `confidence` (high,
medium or low, as the model reported it).

## europe_cities_1801.csv

A gazetteer of 1,801 European cities with present-day coordinates, used as the
gold standard. Columns are `city_jjk` (the city name in capitals), `countryname`,
`longitude` and `latitude` (decimal degrees, WGS84). It is the same file as
`data/europe_cities_1801.csv` in the ECON 895 course repository, which
describes its source in `DATA_SOURCES.md`.
