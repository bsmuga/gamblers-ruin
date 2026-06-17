## Context

The gambler's-ruin project is fully implemented and green, but the result lives entirely in
an uncommitted working tree; the committed history is tooling-only. Six OpenSpec changes
were applied and archived without ever being committed. Reconstructing a faithful
stub-then-implementation history is impossible from the working tree, which holds only the
final state of each file — recreating intermediate stub bodies would mean fabricating
history. This change instead closes a handful of consistency loose ends and then lands the
work as a coherent, honest commit sequence.

## Goals / Non-Goals

**Goals:**
- Make the repository internally consistent: docs match the implemented state, the
  documented local commands actually run, no dead exports, CI enforces what its spec claims.
- Make local testing reproducible for a newcomer from a fresh shell.
- Commit the working tree as a small, coherent, each-builds-green history.

**Non-Goals:**
- Replaying a fabricated stub→implementation history.
- Changing any mathematics or the public `Walk`/`Engine`/`Analytic` interfaces.
- Adding dependencies or new runtime behavior.
- Pushing / running CI on a remote (the user drives that; see Open Questions).

## Decisions

- **Remove `Simulate.outcome` rather than wire it in.** The type `Ruin | Reached_target` is
  exported but unused; `bin/main.ml` already derives the outcome as a local string, and
  `trajectory`/`monte_carlo` return their own shapes. The project's minimalism rule forbids
  abstraction kept "for later," so deletion is the conforming fix. *Alternative considered:*
  make a function return `outcome` (e.g. `outcome_of_trajectory`) — rejected as speculative;
  nothing needs it today.
- **CI formatting check uses `dune build @fmt`, not `dune fmt --check`.** `dune build @fmt`
  is the canonical non-mutating gate that fails on drift and is stable across dune versions;
  `dune fmt` reformats in place and always exits zero (the current bug). *Alternative:*
  `dune fmt --check` — equivalent intent, but `@fmt` matches how the local build already
  verifies formatting.
- **Document switch activation with `eval $(opam env)`.** A fresh shell has no `dune` on
  `PATH`; the README and CLAUDE.md must show the activation step after
  `opam switch create . --deps-only --with-test`. This is the concrete fix for "how do I run
  tests locally."
- **Commit grouping by theme, each building green** (not a stub→impl replay). The sequence,
  on top of `bb7f181`:
  1. Conventions & ignores — `.claude/CLAUDE.md`, `.gitignore`
  2. Build config, library & CLI — `dune-project`, `gamblers_ruin.opam`, `.ocamlformat`,
     `lib/*`, `bin/*`  → `dune build` green
  3. Test suite & CI — `test/*`, `.github/workflows/ci.yml`  → `dune test` green
  4. README
  5. OpenSpec records — `openspec/changes/archive/*`, `openspec/specs/*`, remove the live
     `tidy-agent-config/.openspec.yaml`; this `tidy-loose-ends` change archived alongside.
  The loose-end fixes are folded into the commit that owns each file (README fix in 4, dead
  type in 2, CI fix in 3, doc steps in 1/4).

## Risks / Trade-offs

- **History is thematic, not a literal replay** → accepted deliberately; a fabricated
  stub history would be dishonest and add no value. The OpenSpec archive already records the
  true change-by-change narrative.
- **CI has never actually run** (nothing is pushed) → only a push verifies the workflow;
  flagged as an open item, out of scope to perform here.
- **Removing an exported type is technically a public-interface change** → low risk: it has
  no consumers in-repo and the library is unreleased/uncommitted.

## Open Questions

- After landing, does the user want me to push so CI runs for the first time, or keep the
  history local?
