<div align="center">

# skill-doctor

[![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=500&size=22&duration=3000&pause=1000&color=6E7681&center=true&vCenter=true&width=435&lines=Diagnose+first.;Fix+only+when+you+say+so.)](https://git.io/typing-svg)

<br/>

[![Claude Code skill](https://img.shields.io/badge/Claude%20Code-skill-111111?style=for-the-badge&logo=anthropic&logoColor=white)](https://code.claude.com/docs/en/skills)
[![GitHub](https://img.shields.io/badge/repo-KyTiXo%2Fskill--doctor-111111?style=for-the-badge&logo=github)](https://github.com/KyTiXo/skill-doctor)

</div>

---

<table>
<tr>
<td width="50%" valign="top">

### What it does

Audits an agent skill against [Matt Pocock's write-a-skill spec](https://github.com/mattpocock/skills), plus the deeper `writing-great-skills` principles used by this skill.

It reads the target skill, follows the local checklist, and returns a prioritized fix report. Refactors must be approved by the user.

</td>
<td width="50%" valign="top">

### How to invoke

Invoke it against another skill:

```text
/skill-doctor audit my-skill
```

</td>
</tr>
</table>

---

## Example flow

```text
> /skill-doctor audit my-skill

skill-doctor reads the target skill and returns a prioritized report.

> Okay, implement the suggestions.

skill-doctor creates SKILL.md.bak-<date>
skill-doctor applies approved fixes inside the target skill directory.

> Suggest execution tags too.

skill-doctor proposes frontmatter like context, model, effort, allowed-tools.
skill-doctor includes validation tests before anything is written.
```

---

## What it checks

Five sections, mapped to Pocock's `write-a-skill` and `writing-great-skills`:

<table>
<tr>
<th align="left">Section</th>
<th align="left">Focus</th>
</tr>
<tr>
<td><strong>Invocation</strong></td>
<td>Trigger wording, description shape, invocation boundaries</td>
</tr>
<tr>
<td><strong>Structure</strong></td>
<td>Line count, reference splitting, co-location</td>
</tr>
<tr>
<td><strong>Steps</strong></td>
<td>Checkable, exhaustive completion criteria</td>
</tr>
<tr>
<td><strong>Pruning</strong></td>
<td>Duplicate guidance, dead instructions, vague openings</td>
</tr>
<tr>
<td><strong>Hygiene</strong></td>
<td>Time-sensitivity, terminology, examples, scripts</td>
</tr>
</table>

Full criteria: [`references/checklist.md`](references/checklist.md)

---

## Optional: meta-params

After the content audit, skill-doctor can suggest Claude Code execution tags: invocation mode, `context: fork`, `model`, `effort`, and `allowed-tools` scoped to exact Bash commands.

Every tag is a **proposal with a validation test**. Nothing is written without approval.

<table>
<tr>
<th align="left">Resource</th>
<th align="left">Purpose</th>
</tr>
<tr>
<td><a href="references/optimize-tags.md"><code>references/optimize-tags.md</code></a></td>
<td>Tag catalog, scoping rules, validation tests</td>
</tr>
<tr>
<td><code>scripts/validate-tags.sh</code></td>
<td>Pre-flight <code>allowed-tools</code> patterns before approving</td>
</tr>
</table>

```bash
bash scripts/validate-tags.sh .
bash scripts/validate-tags.sh . "Bash(git clone *)" "Bash(mkdir -p ~/.explore/*)"
```

Read `[GAP]` and `[CUT]` lines, tighten patterns, then dry-run the skill to confirm the tags behave as expected.

---

## Structure

```text
skill-doctor/
├── SKILL.md
├── scripts/
│   └── validate-tags.sh
├── references/
│   ├── checklist.md
│   ├── optimize-tags.md
│   └── report-template.md
└── README.md
```

