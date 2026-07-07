# skill-doctor

Audit an agent skill against [Matt Pocock's write-a-skill spec](https://github.com/mattpocock/write-a-skill) and get a prioritized fix report.

Diagnose-first: the skill reads your target skill, scores it, and reports — it does not edit until you explicitly ask.

## Usage

Invoke the skill on any existing skill directory:

```
Audit my-skill against the skill-doctor checklist
```

Or point it at a specific path:

```
Run skill-doctor on ~/.claude/skills/my-skill
```

You'll get a report with per-section verdicts, named smells, and a prioritized fix list. Say "go fix it" when you want the refactor pass.

## What it checks

Five sections, mapped to Pocock's `write-a-skill` and `writing-great-skills`:

| Section | Focus |
|---|---|
| Invocation | Model vs user-invoked, description shape, triggers |
| Structure | Line count, reference splitting, co-location |
| Steps | Checkable, exhaustive completion criteria |
| Pruning | Single source of truth, no-op deletion, leading words |
| Hygiene | Time-sensitivity, terminology, examples, scripts |

Full criteria live in [`references/checklist.md`](references/checklist.md).

## Structure

```
skill-doctor/
├── SKILL.md                    # Agent skill definition
├── references/
│   ├── checklist.md            # Full audit criteria
│   └── report-template.md      # Report output format
└── README.md
```

## Two gates

1. **Diagnose** — read and report only. No edits.
2. **Refactor** — edits happen only after explicit consent, and only inside the target skill's directory.
