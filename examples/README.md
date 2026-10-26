# Example: a research project set up from the template

`geocode_project/` is a small project built from the public template at
https://github.com/noeldjohnson/research-workflow-template_shared, filled in for
one question: how close are a language model's remembered coordinates to a
gazetteer's? Week 6 runs it live in Claude Code.

## Look around first

- `CLAUDE.md` has the research summary and the project-state table filled in.
- `Data/raw/` holds the two data files and a `README.md` with their provenance.
- `.claude/` holds the template's rules, agents, skills and hooks, unchanged.
  Read `.claude/settings.json` and `.claude/hooks/` before you run anything.

## Run it yourself

Copy the project out of the course repository first. Claude Code also reads any
`CLAUDE.md` in the folders above the one you start it in, so starting it here
would mix this project with whatever surrounds it.

```bash
cp -r examples/geocode_project ~/geocode-demo
cd ~/geocode-demo
git init && git add -A && git commit -m "Start from the template"
claude
```

Then give it one request.

> Write scripts/01_validate.R. It should measure how far each geocode in
> Data/raw/llm_geocodes.csv is from the gazetteer coordinates in
> Data/raw/europe_cities_1801.csv, then report the median and the worst error
> overall and by confidence label. Run it and show me the output.

Read the script it writes before you read its numbers. Then try the second step
in `joins_rule.md`, beside this file, and ask again.

The same task works in PatriotAI. Paste the request and the first lines of each
file, then run the script it gives you in R yourself.

## Second example: a cost surface and market access

`market_access_project/` is the same template filled in for Week 7. `Data/raw/`
holds Roman roads, medieval routes, rivers and seas as GeoPackages, the gazetteer,
and city populations from 1500 to 1800, with a `README.md` giving each file's
source. It has no analysis scripts. Its `CLAUDE.md` specifies every choice in the
construction in words: the grid, the cost of each mode, how a cell counts as
crossed, the least-cost distance, the rule for cities in the same cell, and the
market access sum. In class Claude Code writes the scripts from that
specification and the class checks its numbers against the slides.

```bash
cp -r examples/market_access_project ~/ma-demo
cd ~/ma-demo
git init && git add -A && git commit -m "Start from the template"
claude
```

The requests are on the Week 7 slides. The first asks for the cost surface and
market access for 1800, and the slide after it lists the numbers the answer
should show.

`ma_counterfactual_checks.R` sits outside the project so the model cannot read or
edit it. It checks a rivers-as-land counterfactual file for cities whose market
access rises or is infinite:

```bash
Rscript examples/ma_counterfactual_checks.R ~/ma-demo
```

## Third example: surfaces from points and from satellites

`surfaces_project/` is the template filled in for Week 8. `Data/raw/` holds Black
Death mortality for 274 cities, the gazetteer, Europe's borders, the Guiot and
Corona temperature grid, and the 2000 night lights and population rasters for
Africa, with a `README.md` giving each file's source. It has no analysis scripts.
Its `CLAUDE.md` specifies the construction in two parts: interpolate mortality to
every city with an inverse distance power chosen by leave-one-out, and sum lights
and people by African country. In class Claude Code writes the scripts from that
specification and the class checks its numbers against the slides.

```bash
cp -r examples/surfaces_project ~/wk08-demo
cd ~/wk08-demo
git init && git add -A && git commit -m "Start from the template"
claude
```

The requests are on the Week 8 slides. Each has a slide of the numbers the
answer should show. The scripts need the `gstat` package.
