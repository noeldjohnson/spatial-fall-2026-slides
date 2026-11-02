# Workflow Quick Reference

**Model:** Contractor (you direct, Claude orchestrates)

---

## The Loop

```
Your instruction
    |
[PLAN] (if multi-file or unclear) -> Show plan -> Your approval
    |
[EXECUTE] Implement, verify, done
    |
[REPORT] Summary + what's ready
    |
Repeat
```

---

## I Ask You When

- **Design forks:** "Option A (fast) vs. Option B (robust). Which?"
- **Research ambiguity:** "Spec unclear on X. Assume Y?"
- **Data questions:** "Variable definition unclear. Interpret as Z?"
- **Scope question:** "Also refactor Y while here, or focus on X?"

---

## I Just Execute When

- Code fix is obvious (bug, pattern application)
- Verification (compilation, tests, tolerance checks)
- Documentation (logs, commits)
- Plotting (per established standards)
- LaTeX compilation (after you approve content, I compile automatically)

---

## Quality Gates (No Exceptions)

| Score | Action |
|-------|--------|
| >= 80 | Ready to commit |
| < 80  | Fix blocking issues |

---

## Non-Negotiables

- **Paths:** Relative paths for LaTeX (`../Figures/`), `here::here()` for R
- **Seeds:** `set.seed()` once at top (YYYYMMDD format) for stochastic code
- **Figures:** PDF format for LaTeX, transparent bg, explicit dimensions
- **Colors:** Define your project palette in this file (5-6 colors recommended)
- **Tolerances:** 1e-6 for point estimates, 1e-4 for standard errors

---

## Preferences

<!-- Customize these for your working style -->
**Visual:** Publication-ready, polished. Every figure must be journal-quality.
**Reporting:** Structured, precise, rigorous.
**Session logs:** Always (post-plan, incremental, end-of-session)
**Replication:** Strict. Flag near-misses.

---

## Exploration Mode

For experimental work, use the **Fast-Track** workflow:
- Work in `explorations/` folder
- 60/100 quality threshold (vs. 80/100 for production)
- No plan needed -- just a research value check (2 min)
- See `.claude/rules/exploration-fast-track.md`

---

## Next Step

You provide task -> I plan (if needed) -> Your approval -> Execute -> Done.
