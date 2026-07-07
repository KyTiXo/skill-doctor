# Skill Doctor report template

> Fill this out at gate 1. Tables, not prose. End on one prioritized fix list.

```markdown
## 🩺 <skill-name> audit

| Section | Verdict | Notes |
|---|---|---|
| 1 · Invocation & description | ✅ / ⚠️ | <invocation choice, description shape, trigger branches> |
| 2 · Structure & size | ✅ / ⚠️ | <line count, split correctness, depth, co-location> |
| 3 · Steps & completion | ✅ / ⚠️ | <criteria checkable? exhaustive?> |
| 4 · Pruning | ✅ / ⚠️ | <duplication, no-ops, leading words> |
| 5 · Hygiene | ✅ / ⚠️ | <time-sensitivity, terms, examples, scripts> |

### Smells found
| Smell | Where | Fix |
|---|---|---|
| <premature completion / duplication / sediment / sprawl / no-op> | <line / section> | <first fix> |

### Prioritized fixes (in this order)
1. <push reference out — usually the biggest legibility win>
2. <tighten description / fix invocation>
3. <collapse duplication>
4. <delete no-ops>
5. <refactor restatements into leading words>

**Line count:** <before> → <projected after>

### Suggested meta-params (optional — one row per tag that changes something; leave defaults out)
| Tag | Suggest | Why | Validation test |
|---|---|---|---|
| context: fork (+ agent) | yes / no | <verbose output? self-contained task?> | <body has real steps? one run returns a summary?> |
| model | haiku / sonnet / keep | <how much judgment?> | <run task; still meets completion criteria?> |
| effort | low / medium / keep | <how hard is the reasoning?> | <run task; quality holds?> |
| invocation | disable-model-invocation / user-invocable:false / keep | <side effects? background knowledge?> | </context drops desc? /name still works?> |
| allowed-tools | <Bash(...) patterns> / keep | <runs commands that prompt each time?> | <coverage + least-privilege dry-run: 0 prompts, 0 denials> |
| <any other field> | ... | ... | ... |

**Nothing here is applied without approval AND a passing validation test.**
```

## Tone
- Honest, not harsh. If the skill is already good, say so plainly.
- Use the no-op framing, never "this line is wrong": say "the model already does this by default", and
  argue from behaviour change. Keeps the review about outcomes rather than taste.
