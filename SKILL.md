---
name: skill-doctor
description: Audit an existing skill against Pocock's write-a-skill spec and return a prioritized, diagnose-only fix report.
disable-model-invocation: true
---

# Skill Doctor

> Audits a skill against Matt Pocock's `write-a-skill` (the enforced Review Checklist) and
> `writing-great-skills` (the deeper principles). Diagnose-first — the two gates below never move.

## 🔒 Two gates (never cross)

1. **Diagnose** — once the target skill is picked, only read and produce a report. Change nothing.
2. **Refactor** — after the report, wait for an explicit "go fix it" before editing. A report is not consent.

Refactoring touches only the target skill's own directory. Never other files, never user data.

## Flow

1. Read the target `SKILL.md` in full, plus any linked `references/`.
2. Score it against every row in `references/checklist.md` — five sections: Invocation, Structure, Steps, Pruning, Hygiene.
3. Write the report with `references/report-template.md`: a per-section verdict plus one prioritized fix list.
4. Stop at gate 1.

## The five checks (full criteria live in references/checklist.md)

- **Invocation** — model- vs user-invoked chosen on purpose; description is third person, ≤1024 chars,
  "what it does" + "Use when [triggers]", one trigger per branch, leading word front-loaded.
- **Structure** — `SKILL.md` under 100 lines; body is only steps + reference; branch-only reference
  pushed to a linked file, one level deep; a concept's rules co-located under one heading.
- **Steps** — each step ends on a *checkable* completion criterion, exhaustive where it matters
  ("every model accounted for", not "make a list").
- **Pruning** — one source of truth per meaning; run the no-op test sentence by sentence and delete whole
  sentences that fail; upgrade weak leading words (`be thorough` → `relentless`) rather than cut them.
- **Hygiene** — no time-sensitive info, consistent terminology, concrete examples, scripts only for
  deterministic/repeated work with real error handling; a repeated discovery call becomes a helper the
  model runs on demand, promoted to an inline `!`…`` live-state block only when its output is small + stable.

## Failure-mode lookup

Name the smell when you find it: **premature completion** (step ends early — sharpen the criterion first,
split only if the rush persists), **duplication** (same meaning twice — collapse it), **sediment** (stale
layers nobody removed), **sprawl** (every line live but too long — disclose behind pointers / split by
branch), **no-op** (the model already does it by default — cut, or strengthen the leading word),
**blind-guess** (skill re-derives known live state every run — give it a helper, and inline a small
`!`…`` live-state block only when output is small/stable).

## Refactor (only after gate 2)

Back up first: `cp SKILL.md SKILL.md.bak-<date>`. Then apply the fix list in order: push reference out >
tighten description / fix invocation > collapse duplication > delete no-ops > refactor restatements into
leading words. Re-check the line count and grep the leading words to confirm nothing got lost in the move.
