## Context

The repo has only `LICENSE`, `.gitignore`, and `.claude`/`openspec` tooling — no OCaml
code or build files. The intended project (see proposal) computes gambler's-ruin results
three independent ways (numerical engine, closed forms, simulation) that cross-check each
other. This change lays down the structure for that design without implementing the math,
so later changes touch only mathematics. The OCaml toolchain is not installed in the
authoring environment, so the skeleton must be written to compile warning-clean by
construction rather than verified locally.

## Goals / Non-Goals

**Goals:**
- A `dune build` / `dune test`-able skeleton, warning-clean under Dune's dev profile.
- Encode the three-route module split as `.mli` contracts (the specification surface).
- Provide CI, formatting config, README, and the minimalism philosophy in CLAUDE.md.

**Non-Goals:**
- Implementing `Engine`, `Analytic`, or `Simulate` (stubbed with `failwith "TODO"`).
- Choosing/adding a test framework (`alcotest`/`qcheck`) — deferred to the math change.
- Any CLI argument parsing beyond printing usage.

## Decisions

- **Three small modules + a shared model, not one file and not many.** `Walk` (model),
  `Engine`, `Analytic`, `Simulate`. Each is a distinct mathematical concern; the `.mli`
  files read as definitions. Rejected: a single `gamblers_ruin.ml` (hides the three-route
  structure) and finer splitting (superficial).
- **Implement `Walk` for real; stub the rest.** `Walk` is trivial, non-mathematical
  plumbing (a record + two validating constructors), so implementing it lets `test/` do
  something real and confirms the wiring. The mathematical functions are `.mli` + a
  `failwith "TODO"` body, with unused parameters `_`-prefixed to stay warning-clean.
- **`win : int -> float` in the model.** Supports the general birth–death chain; `constant`
  is just a constructor. This is what makes `Engine` a real solver rather than a formula
  wrapper. Chosen now because it shapes the `.mli`, even though bodies are stubs.
- **`Engine` returns the whole vector `h_0..h_N`.** One tridiagonal solve yields every
  start state; `start` is an index, not a model field. The `.mli` reflects this asymmetry
  (simulation, a single path, does take `start`).
- **Pure, seeded `lib/`; rendering in `bin/`.** `Simulate.trajectory` returns `int array`;
  the CLI draws it. Keeps the library I/O-free.
- **Minimal test target with no external deps.** A plain `(test)` exercising `Walk` avoids
  needing `alcotest` installed for the skeleton to build green in CI.
- **CI = `ocaml/setup-ocaml@v3` then `dune build` + `dune runtest`.** `dune fmt --check`
  is included but kept non-fatal-friendly; matrix over OCaml 5.1/5.2.

## Risks / Trade-offs

- [Toolchain absent locally, so the skeleton is unverified] → Write conservative code
  (no `open`, `_`-prefixed unused params, exported types so no unused-constructor/field
  warnings); CI is the first real compile.
- [Stub `failwith` bodies make `bin`/`test` crash if they call math] → CLI only prints
  usage; the test only touches the implemented `Walk`. Document stubs as TODO.
- [`.ocamlformat` without a pinned version may format differently across machines] → Use
  `profile = default`, no version pin; keep `dune fmt --check` advisory in CI for now.
- [`win : int -> float` over-generalizes if only constant `p` is ever needed] → Cost is
  one extra constructor; the general signature is the mathematically honest one and costs
  nothing at the scaffold stage.
