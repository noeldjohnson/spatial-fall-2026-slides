# Raw data for the text project

Three inputs, all from the ECON 895 course repository's `data/wk10/` folder.
Nothing here is modified.

**`ustc_english_titles.csv`.** The English-language records of the Universal Short
Title Catalogue (USTC, University of St Andrews), 1455--1650: 52,265 titles with
`id` (the USTC number), `short_title`, `place`, `year`, and `classification1` (the
USTC subject class). Extracted from Noel Johnson's research copy of the catalogue;
records with no title or no year are dropped. One title is one document.

**`stopwords_early_modern.txt`.** quanteda's English stopword list, the u/v and i/j
spelling variants of its words, archaic function words (thee, hath, doth, vnto), and
words that appear in most titles as boilerplate (printed, newly, london, anno). One
word per line; lines starting with `#` are comments.

**`spelling_rules.csv`.** Eleven regular expressions that map common early-modern
spellings to modern ones (vnto to unto, haue to have, iudgement to judgement, booke to
book). Apply them in order, to each lowercase token, with Perl-compatible regular
expressions. They catch the regular cases and miss many others (seruant stays
seruant).
