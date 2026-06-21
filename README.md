<div align="center">

# no-yapping

**A coding skill that turns the AI back into a tool.**

Code first. No preamble. No philosophy. No yapping.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[Install](#install) • [Principles](#principles) • [Examples](examples/before-after.md) • [Spec](SPEC.md)

</div>

---

## What is this?

A [Claude](https://docs.claude.com) skill that strips the chatter out of coding sessions. Lead with the diff, show trade-offs as code, answer what was asked — and nothing else.

```diff
- "Great question! Debouncing is a really important technique for optimizing
-  performance. In order to implement a robust solution, we should consider the
-  trade-offs between leading and trailing edges. Here's how I'd approach it..."

+ const onSearch = useMemo(() => debounce(q => fetchResults(q), 300), [])
+ // import { debounce } from "lodash-es"
```

Same answer. One of them respects your time.

---

## Why

LLMs are trained to be helpful, and "helpful" leaks into long-winded. During hands-on coding that's friction: you wade through preamble, rationale, and best-practice lectures to reach three lines of code you could already picture.

You can read code. The code shows the trade-off. If you want the *why*, you ask for it — or open a new chat for the deep dive. The default should be the diff.

`no-yapping` makes the diff the default.

---

## Principles

1. **Code before prose** — lead with the diff, command, or snippet.
2. **No preamble, no postamble** — no "Great question", no "Let me know if".
3. **Don't explain why unless asked** — the code carries the reasoning.
4. **Trade-offs as code** — show A vs B as snippets, one-line labels, no essay.
5. **Plain words** — ban filler (robust, leverage, seamless, holistic, "in order to").
6. **Answer what was asked** — no scope creep, no volunteered tangents.
7. **Ask only when blocked** — else state the assumption in one line, proceed.
8. **The ripcord** — "why" / "explain" / "discuss" overrides the mode for that turn.

Full ruleset in [SPEC.md](SPEC.md).

---

## Install

Copy the skill folder into your skills directory:

```bash
# Project-local (this repo only)
mkdir -p .claude/skills
git clone https://github.com/<you>/no-yapping .claude/skills/no-yapping

# Or global (all projects)
git clone https://github.com/<you>/no-yapping ~/.claude/skills/no-yapping
```

Then trigger it by saying things like *"no yapping"*, *"just the code"*, or *"be terse"* — or keep it on by referencing it in your project's `CLAUDE.md`.

---

## When to use

✅ **Good for**
- Hands-on coding when you know what you want
- Quick fixes, diffs, refactors, command lookups
- Sessions where verbose answers are slowing you down

❌ **Turn it off for** (just ask — the ripcord overrides it)
- Architecture and design discussions
- Learning something new where the *why* matters
- Debugging that needs reasoning out loud

---

## How it relates to other skills

- [caveman-compression](https://github.com/wilpel/caveman-compression) compresses *text* to save tokens. `no-yapping` compresses the *conversation* to save your attention.
- Pairs well with planning skills: use a planner to decide *what* to build, `no-yapping` for *building* it.

---

## License

MIT — see [LICENSE](LICENSE).
