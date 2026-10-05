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
