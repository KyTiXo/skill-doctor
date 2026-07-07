# Meta-params pass — Claude Code execution tags

> Opt-in pass — when and how to run: `SKILL.md` § Meta-params pass. This file is the tag catalog
> + validation tests only. These tune *how* a skill runs, not what it says — Claude Code frontmatter
> on top of Pocock's content spec, not inside it. Field list lives at `code.claude.com/docs/en/skills`
> and `/permissions`; re-check there for new fields.

The rule mirrors the invocation call in checklist §1: **match the tag to the skill's real
frequency, risk, and complexity.** A tag that doesn't change behaviour is a no-op — don't add it.

## The four headline calls

### 1. Fork it? — `context: fork` (+ `agent:`)

Runs the skill in an isolated subagent. The body becomes the subagent's whole prompt; it does
NOT see conversation history, and only a summary returns to the main thread.

| Fork when | Don't fork when |
|---|---|
| Output is verbose and would clutter the thread (scanners, censuses, research dumps) | Reference/knowledge skill with no task — a fork with no actionable prompt returns nothing |
| The task is self-contained and needs no conversation context | The skill needs what's already in the conversation |
| The body has explicit step-by-step instructions | You want the full working output inline, not a summary |

`agent:` — `Explore`/`Plan` are read-only and skip CLAUDE.md + git status, so smallest context
(good for audits); `general-purpose` (default) gets full tools; or name any `.claude/agents/` agent.

### 2. Cheaper model? — `model: haiku | sonnet`

Accepts `/model` values (`haiku`, `sonnet`, `opus`, full IDs) or `inherit` (default — keeps the
active model). Turn-scoped: the session model resumes on your next prompt.

| Downgrade when the skill is… | Keep `opus`/`inherit` when the skill… |
|---|---|
| Simple, mechanical, low-judgment: format conversion, keyword lookup, run-a-script-and-report | Makes design calls, grills, weighs trade-offs, or audits (this doctor itself) |
| → `haiku` trivial/deterministic, `sonnet` moderate | → judgment is the point; the model spend is the value |

Pair with `effort:` (`low`/`medium`/`high`/`xhigh`/`max`) on the reasoning axis — and always pair the
two: a `model` downgrade with no `effort` cap still runs the cheaper model at the session's effort (e.g.
`sonnet` at `high`), which is half a fix. **Baseline trap:** with no `effort` tag the skill inherits the
*user's session effort* (often `high`), NOT `low` — so judge against that, never assume "already low → keep".
A mechanical skill running at an inherited `high` is over-spend; suggest `effort: low` (or `medium`) and the
model downgrade together. Caveat: a value your org's `availableModels` allowlist excludes is ignored, and
the override doesn't persist past the turn.

### 3. Who invokes? — `disable-model-invocation` / `user-invocable`

| Situation | Tag | Bonus |
|---|---|---|
| Side effects, timing-sensitive, or rare (deploy, commit, this audit) | `disable-model-invocation: true` | Drops the description from context = token savings |
| Background knowledge Claude should auto-apply, not a user command | `user-invocable: false` | Hidden from the `/` menu |
| General reusable task | leave default (both) | — |

Never set both — the skill becomes unreachable (hidden from `/` AND from Claude).

### 4. Scope the tools? — `allowed-tools` (+ `disallowed-tools`)

`allowed-tools` pre-approves tools so the skill runs without a prompt each time. It **grants, does
not restrict** — unlisted tools still follow normal permissions (pair with project `deny` rules if
blocking is the goal). A skill declaring `allowed-tools` asks for approval once, before first use.

**Weigh it against the profile's frequency, not in the abstract.** The value is prompts-removed × how
often you run it; the cost is a standing grant someone maintains. A high-frequency skill clears the bar
easily — that's why a `curl:*` or `git:*` grant is right for tools you fire constantly. A low-frequency
skill rarely does: the friction removed is a couple of "don't ask again" clicks a session, and interactive
per-session allowlisting already covers it. Raise the bar further when the grant can't be scoped tight
(`curl:*` grants all curl to any URL — a URL can't be narrowed via a Bash pattern, §gotchas below) or when
the command is compound / function-wrapped (`source …; curl … | jq`, or a `pq(){…}` def) so the patterns
match unreliably and may prompt anyway. None of these is an automatic no — they're the weights. Say which
way the frequency tips it.

For Bash, scope to the *specific commands the skill runs* — least privilege. Matched against the
literal command string, shell-operator aware (`foo && bar` needs both sides to match a rule):

| Pattern | Matches | Note |
|---|---|---|
| `Bash(mkdir -p ~/.explore/repos)` | exactly that string | exact match — no extra args; a subpath re-prompts |
| `Bash(git clone:*)` = `Bash(git clone *)` | `git clone <anything>` | `:*` and space-`*` are equivalent trailing wildcards |
| `Bash(git clone *)` | also bare `git clone` | a single trailing space-`*` lets the bare command match too |
| `Bash(ls:*)` | `ls -la …` but NOT `lsof` | the space before `*` is a word boundary |
| `Bash(gh pr *)` | `gh pr create`, `gh pr view`, … | wildcard scopes a subcommand family |

Least-privilege example for a repo-cloning skill:
```
allowed-tools: Bash(mkdir -p ~/.explore/*), Bash(ls -la ~/.explore/repos), Bash(git clone *)
```
Gotchas to check when suggesting Bash scopes:
- Read-only builtins (`ls`, `cat`, `grep`, `find`, `wc`, `diff`, read-only `git`) never prompt — listing them is harmless but usually redundant.
- Exec wrappers (`watch`, `setsid`, `flock`) and `find -exec`/`-delete` always prompt; a prefix rule won't cover them — use an exact-match rule.
- Don't constrain arguments (e.g. a URL) with a Bash pattern — it's fragile; scope the tool and use a `deny`/WebFetch rule instead.

`disallowed-tools` removes a tool while the skill runs (clears on your next message) — use it to keep
an autonomous loop from calling something like `AskUserQuestion` and stalling.

## Validation before approval

Every suggested tag is a proposal, not an edit. Ship each with a concrete validation test; write it
only after the test passes AND the user consents — bulk (`apply the tags`) or cherry-pick (name the rows).
Suggest → validate → on consent, set.

| Tag | Validation test to offer |
|---|---|
| `allowed-tools: Bash(...)` | `bash scripts/validate-tags.sh . "Bash(git clone *)" "Bash(mkdir -p ~/.explore/*)"` — read GAP/CUT lines, tighten, then dry-run. |
| `model: haiku`/`sonnet` | Run the skill's representative task on the proposed model; confirm output still meets the completion criteria (checklist §3). A/B against `inherit` if unsure. |
| `effort:` down | Run the task; confirm quality holds at the lower effort. |
| `context: fork` | Static: body has explicit step instructions (reference-only forks no-op). Runtime: invoke once, confirm a non-empty summary returns. |
| `disable-model-invocation: true` | After setting, run `/context` and confirm the description is no longer loaded; confirm `/skill-name` still invokes it. |
| `user-invocable: false` | Confirm it's gone from the `/` menu and Claude still auto-loads it when relevant. |

To enumerate the commands a skill runs, use `scripts/validate-tags.sh` — it extracts the `` !` `` injections
and script calls itself. Write the narrowest patterns covering that list. A command with no matching pattern
will prompt at runtime; a pattern matching nothing in the list is an over-grant — cut it.

## Full frontmatter catalog (current)

| Field | What it does | Suggest when |
|---|---|---|
| `name` | Display label in listings; command name usually comes from the folder | Always set explicitly |
| `description` | What + when; key use case first; `description`+`when_to_use` capped ~1,536 chars | Always |
| `disable-model-invocation` | `true` = user-only; drops description from context | Side effects, rare, timing-sensitive |
| `user-invocable` | `false` = Claude-only, hidden from `/` | Background knowledge |
| `allowed-tools` | Pre-approves tools (no restrict) | Skill runs git/bash/scripts that would prompt |
| `disallowed-tools` | Removes tools while active; clears next message | Autonomous loop that must not call X |
| `model` | `haiku`/`sonnet`/`opus`/full-id/`inherit`; turn-scoped | Simple skill → downgrade |
| `effort` | `low`/`medium`/`high`/`xhigh`/`max` | Dial down simple, up hard |
| `context` | `fork` = isolated subagent | Verbose, self-contained task skills |
| `agent` | Subagent type when `context: fork` | Always pair with `fork` |
| *(other)* | `when_to_use`, `argument-hint`, `arguments`, `hooks`, `paths`, `shell` | Rarely proposed by this pass — see docs |

## Don't over-tag
- `allowed-tools` and `hooks` trigger a trust prompt before first use — add only when truly needed.
- `context: fork` on a reference-only skill is a silent no-op (no task = no output).
- A `model` downgrade on a judgment-heavy skill trades output for pennies — the wrong trade.
- Every tag is a line someone maintains later. If it doesn't change behaviour, it fails the same no-op test as prose (checklist §4).
