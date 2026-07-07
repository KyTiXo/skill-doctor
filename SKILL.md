---
name: skill-doctor
description: Audit a skill against Pocock's write-a-skill spec and return a prioritized, diagnose-only fix report.
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
3. Write the gate-1 report via `references/report-template.md` (content only).
   Exception: user said `with tags` or `include meta-params` upfront → also fill
   `references/meta-params-template.md` in the report (propose only, no writes).
4. Stop at gate 1 — change nothing.

## The five checks

Invocation · Structure · Steps · Pruning · Hygiene. Full criteria live in `references/checklist.md` —
score every row from that file, never from memory.

## Failure-mode lookup

Name the smell when you find it: **premature completion**, **duplication**, **sediment**, **sprawl**,
**no-op**, **blind-guess**. Tell + first fix for each: `references/checklist.md` § Failure-mode lookup.

## Refactor (only after gate 2)

Back up first: `cp SKILL.md SKILL.md.bak-<date>`. Then apply the report's prioritized fix list in order.
Re-check the line count and grep the leading words to confirm nothing got lost in the move.

## Meta-params pass (opt-in — default after gate 2)

Run only on explicit request. Default timing: after content refactor. Upfront exception:
`with tags` / `include meta-params` in the audit invocation → proposals in gate-1 report.

Propose via `references/meta-params-template.md` + `references/optimize-tags.md`.
Nothing writes until the user consents — bulk (`apply the tags`) or cherry-pick (name the rows).
Run each validation test before writing; skip or revert on request.
Never mix tag writes into the content refactor unless the same message explicitly approves both.
