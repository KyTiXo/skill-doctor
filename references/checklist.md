# Skill audit checklist — mapped to Pocock's spec

> Source tags: **[WAS]** = `write-a-skill` (its own "Review Checklist" + rules — the enforced bar).
> **[WGS]** = `writing-great-skills` (the deeper principles that explain *why*).
> Root virtue [WGS]: **predictability** — the agent runs the same *process* every time. Every check serves it.

## 1. Invocation & description

| Check | Pass bar | Src |
|---|---|---|
| Invocation chosen on purpose | Rare / manual tool → `disable-model-invocation: true` (user-invoked, zero context load). Go model-invoked only if the agent or another skill must reach it on its own. | WGS |
| Person + length | Third person, ≤ 1024 chars. | WAS |
| Description shape | Sentence 1 = what it does; sentence 2 = "Use when [specific triggers]". (User-invoked: trim to a human one-liner, trigger list stripped.) | WAS / WGS |
| One trigger per branch | No synonyms renaming the same branch ("test-first" and "TDD" are one branch, not two). | WGS |
| Leading word front-loaded | The skill's anchor concept appears early in the description, where it does its invocation work. | WGS |
| No identity bloat | Description is triggers + optional "when another skill needs…" clause — not a re-summary of the body. | WGS |
| Not "Helps with X" | Reject vague descriptions the agent can't tell apart from its neighbours. | WAS |

## 2. Structure & size

| Check | Pass bar | Src |
|---|---|---|
| Main-file length | `SKILL.md` under **100 lines**. (Note: Pocock's own draft step says 500, but his Review Checklist *and* "When to Split" both say 100. Audit to 100; flag the internal conflict.) | WAS |
| Two content types only | Body is **steps** + **reference** — nothing else. | WGS |
| Branch-only reference pushed out | Material only some branches reach → linked file behind a context pointer. What every branch needs stays inline. | WGS |
| References one level deep | No pointer-to-a-pointer chains. | WAS |
| Co-location | A concept's definition, rules, and caveats sit under one heading, not scattered across the file. | WGS |
| Template sections | Where they fit: Quick start / Workflows / Advanced features (advanced links out to a file). | WAS |

## 3. Steps & completion

| Check | Pass bar | Src |
|---|---|---|
| Every step has a completion criterion | The step names the condition that means "done". | WGS |
| Criterion is checkable | The agent can tell done from not-done. | WGS |
| Criterion is exhaustive where it matters | "every modified model accounted for", not "produce a change list". | WGS |
| Split by sequence when needed | If visible later steps tempt the agent to rush the current one (premature completion), hide them by splitting. | WGS |

## 4. Pruning (the deletion pass)

| Check | Pass bar | Src |
|---|---|---|
| Single source of truth | Each meaning lives in exactly one place, so changing behaviour is a one-place edit. | WGS |
| Relevance | Every line still bears on what the skill does. | WAS / WGS |
| No-op test | Run it per **sentence**, not just per line: does this change behaviour vs the model's default? If not, delete the whole sentence. Be aggressive — most failing prose should go, not be reworded. | WGS |
| Weak leading words upgraded | `be thorough` (the model is already thorough-ish) is a no-op → strengthen to `relentless`; don't just cut it. | WGS |
| Real leading words protected | Compact pretrained anchors (`tracer bullet`, `red` / `green`, `fog of war`, `tight` loop) stay — they hold a region of behaviour in the fewest tokens. Never prune them as filler. | WGS |
| Restatements collapsed | "fast, deterministic, low-overhead" → one leading word (`tight`). Assume every skill is carrying restatements a leading word would retire. | WGS |

## 5. Hygiene

| Check | Pass bar | Src |
|---|---|---|
| No time-sensitive info | Nothing that dates — versions, "as of", current-year claims. | WAS |
| Consistent terminology | Same concept, same word, throughout. | WAS |
| Concrete examples | At least one worked example, not only abstract rules. | WAS |
| Scripts earn their place | Add a script only for deterministic / repeated ops with explicit error handling — not to wrap what the model already does fine in prose. | WAS |
| Live state earns its place | A skill that makes the model guess or re-run the same discovery call every time should collapse it into a helper the model runs on demand (the default) — and *additionally* inject it via an inline `!`…`` block at load only when that call's output is small and stable. Skip the inline block for large / noisy output; it scrambles context every load. | WGS |

## Failure-mode lookup (name the smell)

| Smell | Tell | First fix | Src |
|---|---|---|---|
| Premature completion | Step ends before the work is genuinely done | Sharpen the completion criterion (cheap, local); split only if the rush persists | WGS |
| Duplication | Same meaning in 2+ places | Collapse to one source of truth | WGS |
| Sediment | Stale layers that settled because adding felt safe and removing felt risky | Prune | WGS |
| Sprawl | Every line live and unique, but simply too long | Disclose reference behind pointers; split by branch or sequence | WGS |
| No-op | A line the model already obeys by default | Cut it, or upgrade to a stronger leading word | WGS |
| Blind-guess | Skill re-derives known live state every run (guess an id, re-list, re-fetch) | Give it a helper to run on demand; add an inline `!`…`` live-state block too only when output is small/stable | WGS |

---

## What this audit adds beyond write-a-skill

`write-a-skill`'s own Review Checklist is short — description-has-triggers, under 100 lines, no
time-sensitive info, consistent terms, concrete examples, references one level deep. That's sections **2
and 5** here, plus the description rows in **1**. Everything tagged **[WGS]** — the invocation trade-off,
completion criteria, the sentence-level no-op pass, and leading-word refactoring — is the deeper layer
`write-a-skill` gestures at but doesn't itself check. This doctor also adds the two consent gates, which
Pocock's tools don't have (they just edit).
