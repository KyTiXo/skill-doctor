# Meta-params proposal template

> Fill this on request (`suggest tags`) or upfront (`with tags` / `include meta-params`).
> Propose only — no writes until the user consents.

**Open with the profile, then lead with the verdict. Show only tags you recommend.** Rejected tags are one
skip line, not table rows — a table full of "no / keep" verdicts is the clutter this format exists to kill.

The profile line is mandatory and must carry all three axes — **frequency · risk · judgment** — because
every tag keys off them (frequency drives `allowed-tools`, risk drives invocation, judgment drives
`model`/`effort`). Drop an axis and a tag floats free: omit "low-frequency" and `allowed-tools` looks worth
it on repeated-prompt grounds alone. When invoked standalone (no gate-1 audit ran this session), state the
profile from a fresh read of the skill; don't infer tags without it.

````markdown
**Profile:** <frequency> · <risk> · <judgment> — <one clause tying it together>.

**Recommend: <tag: value>[ + <tag: value>]**

Why: <one-line why>
Validate: <the test to run before writing it>.
[repeat one block per recommended tag — usually 0-2]

**Skipped (no-op / net-negative):** <tag>, <tag>, <tag> — <one clause each, or shared reason>.

### Suggested final frontmatter

```diff
 name: <name>
 description: <first ~60 chars of the existing description>… (unchanged)
+<tag>: <value>
```

_Nothing is written without consent — say `apply the tags`, or name the ones you want. Each runs its validation test first._
````

Rules for the frontmatter diff:
- `+` lines are the proposal. They must be verbatim, copy-pasteable YAML — no bold, no ellipsis, no
  parenthetical annotations, no `**key**` styling.
- Context lines (leading space) are the skill's *existing* frontmatter; long values may be truncated
  with `…` since nobody pastes them.
- Only fields that already exist in the target skill or earned a Recommend block above may appear.
  Never invent a field (`version`, etc.) to pad the block.

Rules:
- A tag earns a Recommend block only if it changes behaviour (the no-op test, checklist §4). Everything else
  is a skip-line word, never a row.
- Model + effort travel together (optimize-tags.md §2): recommend both or neither.
- If nothing earns a block, say so in one line — "No tags earn their place; defaults are correct" — and stop.
