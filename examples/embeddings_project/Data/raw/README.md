# Raw data for the embeddings project

One input, copied from the ECON 895 course repository's `data/wk10/` folder, the same
file Week 10 used. Nothing here is modified.

**`ustc_english_titles.csv`.** The English-language records of the Universal Short
Title Catalogue (USTC, University of St Andrews), 1455--1650: 52,265 titles with `id`
(the USTC number), `short_title`, `place`, `year`, and `classification1` (the USTC
subject class). Extracted from Noel Johnson's research copy of the catalogue; records
with no title or no year are dropped. One title is one document.

The stop words come from `quanteda::stopwords("en")`, the Snowball list of 175 English
words, so there is no separate file. The list has modern spellings only, so early-modern
forms such as haue, vpon, and vs are kept as words.
