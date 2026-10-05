# Step two: add a rule and ask again

Save the text below as `.claude/rules/joins.md` inside your copy of the
project, start a fresh Claude Code session, and give it the same request.
Compare the two scripts and the two sets of numbers.

```markdown
---
paths:
  - "scripts/**/*.R"
---
# Joins

- Print nrow() on both sides of every join, before and after.
- Use relationship = "one-to-one" wherever a key should be unique, so a
  duplicate stops the script.
- A name is not a unique key. When names can repeat, join on name plus a
  second field that tells the entries apart.
```

A rule is text the model reads at the start of the work. It travels to every
later session in this project, and to the next project if you copy it there.
