# Skill Doctor report template

> Fill this out at gate 1. Tables, not prose. End on one prioritized fix list.

````markdown
## 🩺 <skill-name> audit

**Health: <n>/5 sections pass · <n> smells · <before> → <projected after> lines**

| Section | Verdict | Notes |
|---|---|---|
| 1 · Invocation & description | ✅ / ⚠️ <n> issues / ❌ | <invocation choice, description shape, trigger branches> |
| 2 · Structure & size | ✅ / ⚠️ <n> issues / ❌ | <line count, split correctness, depth, co-location> |
| 3 · Steps & completion | ✅ / ⚠️ <n> issues / ❌ | <criteria checkable? exhaustive?> |
| 4 · Pruning | ✅ / ⚠️ <n> issues / ❌ | <duplication, no-ops, leading words> |
| 5 · Hygiene | ✅ / ⚠️ <n> issues / ❌ | <time-sensitivity, terms, examples, scripts> |

### Smells found
| Smell | Where | Fix |
|---|---|---|
| <premature completion / duplication / sediment / sprawl / no-op / blind-guess> | <line / section> | <first fix> |

### Prioritized fixes
<List ONLY fixes actually found, ordered: reference-out > description/invocation > duplication > no-ops > leading words. Omit categories with no findings — never pad the list to five.>

For the top 2 fixes, quote the offending line and show the rewrite:
```diff
- <offending line, verbatim from the skill>
+ <the rewritten line>
```

_Say `go fix it` to implement changes or say `suggest tags` for execution-tag proposals._
````

## Rules
- Verdict column commits to a count: `✅` pass, `⚠️ <n> issues` with the number, `❌` hard fail. A count,
  not a vibe.
- If no smells are found, replace the smells table with one line: *No smells found — this skill is healthy.*
- The Health header line is mandatory and comes first — it's the TLDR.

## Tone
- Honest, not harsh. If the skill is already good, say so plainly.
- Use the no-op framing, never "this line is wrong": say "the model already does this by default", and
  argue from behaviour change. Keeps the review about outcomes rather than taste.
