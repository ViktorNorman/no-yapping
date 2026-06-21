<div align="center">

# no-yapping

**Stop talking. Start coding.**

A coding skill that turns the AI back into a tool — code first, no preamble, no philosophy, no yapping.

<img src="assets/banner.png" alt="no-yapping — a finger to the lips: stop talking, start coding" width="100%">

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

> **The receipts:** same model, 7 prompts, with the skill vs without. Replies hit the intended _shape_ — terse on build asks, full depth when you ask _why_ — **100% vs 60%** of the time, and ran **~8.5× shorter** on build prompts. _(Behavioral conformance + word count, not a code-quality score — the model is identical either way.)_ → [benchmark](https://github.com/viktornorman/no-yapping-benchmark)

---

## Why

LLMs are trained to be helpful, and "helpful" leaks into long-winded. During hands-on coding that's friction: you wade through preamble, rationale, and best-practice lectures to reach three lines of code you could already picture.

You can read code. The code shows the trade-off. If you want the _why_, you ask for it — or open a new chat for the deep dive. The default should be the diff.

`no-yapping` makes the diff the default.

---

## Principles

1. **Code before prose** — lead with the diff, command, or snippet.
2. **No preamble, no postamble** — no "Great question", no "Let me know if".
3. **Don't explain why unless asked** — the code carries the reasoning.
4. **Trade-offs as code** — show A vs B as snippets, one-line labels, no essay.
5. **Plain words** — ban filler (robust, leverage, seamless, holistic, "in order to").
6. **One concept per turn** — a bundle of changes gets a numbered menu; pick one, park the rest.
7. **Vague in → point at code** — an abstract ask ("make it cleaner") gets a one-line concrete target, then proceeds.
8. **The ripcord** — "why" / "explain" / "discuss" overrides the mode for that turn.

Full ruleset in [SPEC.md](SPEC.md).

---

## Benchmark

Same model, same prompts, with the skill and without — graded on objective rules.
Full method, every response, and one-command reproduction live in
**[no-yapping-benchmark](https://github.com/viktornorman/no-yapping-benchmark)**.

|                                              | With `no-yapping` | Baseline |
| -------------------------------------------- | ----------------- | -------- |
| Assertion pass rate (7 cases)                | **100%**          | 59.8%    |
| Avg words — build / redirect prompts         | **42**            | 357      |
| Avg words — "explain / architecture" prompts | 496               | 499      |

Per case:

| Prompt                                | With — words | Baseline — words |
| ------------------------------------- | ------------ | ---------------- |
| Vague "clean up this component"       | **26**       | 465              |
| Four changes bundled in one ask       | **34**       | 510              |
| "Add a 300ms debounce"                | **78**       | 194              |
| "Why useReducer? explain" (ripcord)   | 492          | 613              |
| "Shard, replicas, or event sourcing?" | 500          | 386              |
| Sloppy file w/ a hidden XSS bug       | **40**       | 366              |
| "Data layer feels off, thoughts?"     | **31**       | 251              |

~8.5× shorter on build prompts — and **the same length** when you explicitly ask _why_ or
for an architecture call. It cuts the chatter, not the substance.

---

## Install

`SKILL.md` is the single source of truth. The `install.sh` script writes it into the
file your harness reads — strip nothing, edit one place.

```bash
git clone https://github.com/viktornorman/no-yapping
cd no-yapping
./harnesses/install.sh <harness> /path/to/your/project   # target dir defaults to .
```

| Harness                   | Lands at                          | Command               |
| ------------------------- | --------------------------------- | --------------------- |
| Claude Code / Cowork      | `.claude/skills/no-yapping/`      | `install.sh claude`   |
| Codex CLI                 | `AGENTS.md`                       | `install.sh codex`    |
| Cursor                    | `.cursor/rules/no-yapping.mdc`    | `install.sh cursor`   |
| GitHub Copilot            | `.github/copilot-instructions.md` | `install.sh copilot`  |
| Gemini CLI                | `GEMINI.md`                       | `install.sh gemini`   |
| Windsurf                  | `.windsurf/rules/no-yapping.md`   | `install.sh windsurf` |
| Anything else (30+ tools) | `AGENTS.md`                       | `install.sh agents`   |

[`AGENTS.md`](https://agents.md) is read natively by Codex, Cursor, Copilot, Windsurf,
Aider, Zed, Jules and many more — so `agents` covers most tools. Gemini CLI reads
`GEMINI.md`; Claude Code uses the skill folder.

**Triggering.** As a Claude skill it fires when you say _"no yapping"_, _"just the
code"_, or _"be terse"_. In `AGENTS.md` / Cursor / Copilot it's always-on by default —
the **ripcord** (say _"why"_ / _"explain"_) still drops the mode for that turn.

---

## When to use

✅ **Good for**

- Hands-on coding when you know what you want
- Quick fixes, diffs, refactors, command lookups
- Sessions where verbose answers are slowing you down

❌ **Turn it off for** (just ask — the ripcord overrides it)

- Architecture and design discussions
- Learning something new where the _why_ matters
- Debugging that needs reasoning out loud

---

## How it relates to other skills/projects

- [ponytail](https://github.com/DietrichGebert/ponytail) — the "lazy senior dev" who replaces fifty lines with one. Same spirit, different target: **ponytail trims the _code_ to the minimum that works; `no-yapping` trims the _conversation_ down to the code.** Run both and the AI says little and writes less.
- [caveman-compression](https://github.com/wilpel/caveman-compression) compresses _text_ to save tokens. `no-yapping` compresses the _conversation_ to save your attention.
- Pairs well with planning skills: use a planner to decide _what_ to build, `no-yapping` for _building_ it.

---

## License

MIT — see [LICENSE](LICENSE).
