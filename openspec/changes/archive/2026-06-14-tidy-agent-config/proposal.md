## Why

The `.claude/` subagent setup is inconsistent: every agent declares `memory: project`,
which spawns a per-agent directory under `.claude/agent-memory/`, but those directories
are empty and untracked — git cannot commit an empty folder, so they are pure on-disk
trash that the repository neither carries nor regenerates intentionally. We want the
agent roster (including `ocaml-implementer`) to be complete and the memory convention to
be explicit, so nothing empty or orphaned lingers.

## What Changes

- Establish a 1:1 consistency rule between agent definitions in `.claude/agents/` and the
  per-agent memory convention: every committed `.claude/agents/<name>.md` is a real agent,
  and `ocaml-implementer` is part of that roster.
- Keep the `memory: project` feature on all agents, but treat `.claude/agent-memory/` as
  **runtime state, not source**: add it to `.gitignore` so per-agent memory is never
  committed.
- Remove the existing empty `.claude/agent-memory/*` directories from disk. They are
  recreated automatically by the harness the first time an agent actually writes a memory.
- Result: no empty placeholder directories are tracked or left as trash; the agent roster
  and its memory convention are documented and self-consistent.

## Capabilities

### New Capabilities

- `agent-configuration`: Governs the structure and consistency of the project's Claude
  Code subagent setup — which agents exist, how their definitions are organized, and how
  per-agent memory is treated relative to version control.

### Modified Capabilities

<!-- None: no existing spec's requirements change. -->

## Impact

- `.claude/agents/` — roster confirmed complete (5 agents, including `ocaml-implementer`).
- `.claude/agent-memory/` — empty directories deleted from disk; directory tree no longer
  committed.
- `.gitignore` — new entry ignoring `.claude/agent-memory/`.
- No application/OCaml source code is affected; this is tooling/configuration hygiene only.
