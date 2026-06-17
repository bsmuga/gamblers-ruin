## Why

The entire gambler's-ruin implementation — `lib/`, `bin/`, `test/`, CI, README, and the
OpenSpec records of six applied changes — is finished and green (warning-clean build,
12/12 tests, three routes agree) but sits **uncommitted** in the working tree; the
committed history covers only tooling. Before that work is committed as a coherent
history, a few loose ends should be closed so the repository is internally consistent and
a newcomer can actually build and test it.

## What Changes

- **Fix the stale README status.** The "Status" section still claims `Engine`, `Analytic`,
  and `Simulate` "declare their interfaces with `TODO` stub bodies." They are fully
  implemented and tested; the section must state the true state.
- **Document how to run tests locally so the commands work.** The README/CLAUDE.md
  build/test commands omit activating the local OPAM switch, so `dune` is not on `PATH`
  from a fresh shell and the documented commands fail. Add the missing
  `eval $(opam env)` step so `dune build` / `dune test` / `dune fmt` / `dune exec` run.
- **Remove dead code.** Delete the unused `outcome` type (`Ruin | Reached_target`) from
  `Simulate`'s `.mli`/`.ml`: no function consumes it, and `bin/main.ml` derives the
  outcome itself. (Minimalism: no abstraction kept "for later.")
- **Make CI actually enforce formatting.** The workflow's formatting step runs `dune fmt`,
  which reformats in place and always exits `0`, so drift is never caught. Replace it with
  a non-mutating check (`dune build @fmt`) that fails on drift.
- **Land the work as a coherent commit history** — the uncommitted implementation plus
  these fixes, grouped into logical, each-builds-green commits (see `tasks.md`).

## Capabilities

### New Capabilities
<!-- None: this change tidies existing capabilities and introduces no new behavior. -->

### Modified Capabilities
- `repository-scaffold`: the **Project documentation** requirement is strengthened — the
  README MUST reflect the implemented (non-stub) state, and the documented local
  build/test instructions MUST succeed from a fresh shell, including the step that
  activates the local OPAM switch.
- `continuous-integration`: the **CI enforces build, formatting, and tests** requirement is
  sharpened — the formatting step MUST be a non-mutating check that fails on drift (e.g.
  `dune build @fmt`), not `dune fmt`, which rewrites files in place and always passes.

## Impact

- Docs: `README.md` (status + runnable build/test instructions), `.claude/CLAUDE.md`
  (switch-activation note in Build & test).
- Code: `lib/simulate.mli`, `lib/simulate.ml` (remove the `outcome` type). No behavior
  change — `bin/main.ml` already computes its own outcome string.
- CI: `.github/workflows/ci.yml` (formatting step becomes a real check).
- Specs: deltas for `repository-scaffold` and `continuous-integration`.
- History: the working tree (whole implementation + OpenSpec records + these fixes) is
  organized into a coherent commit sequence.
- No change to the mathematics, the public `Engine`/`Analytic`/`Walk` interfaces, or
  dependencies.
