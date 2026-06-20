## Why

A multi-agent review of the repository surfaced a set of small, independently
verified issues. None are bugs, but each is the kind of clutter or latent gap the
project's minimalism philosophy says to remove: dead defensive code and a
magic-number coupling in the core, two inline comments that restate the code
(against the project's own comment rule), redundant and drift-prone README
narration, an exported closed form that no test exercises (leaving "the three
routes must agree" only half-verified), and a contradiction where `dune-project`
declares an OCaml `>= 4.14` floor that CI never builds (CI pins `5.1`).

## What Changes

- **Engine — drop dead defensive copies.** Remove `Array.copy` of `sub`/`sup` in
  `Engine.solve`; pass the already-fresh `q`/`p` arrays directly. Identical
  behavior, two fewer allocations, clearer data flow.
- **Comments — delete WHAT-restating inline comments.** Remove the `step` comment
  in `simulate.ml` and the boundary-fold comment in `engine.ml`. The `.mli` specs,
  the `engine.ml` header derivation, and the `analytic.ml` rationale comment stay.
- **CLI — remove a magic-number coupling.** Derive the sparkline scale in
  `bin/main.ml` from the glyph-array length instead of the hard-coded `8.0`.
- **README — cut redundant, drift-prone narration.** Remove the `## Status`
  section and the duplicated hard-coded "12 cases" counts; the routes table and
  `dune test` stay as the source of truth.
- **Tests — close the durations cross-check gap.** Add an engine-vs-analytic
  agreement check for **expected durations**, exercising the delicate unequal-`p`
  closed form that is currently called by no test. Convert `test_unfair_example`
  into a hard-coded known-answer anchor so it stops duplicating the property
  test's oracle. Add a one-line *why* comment justifying the Monte-Carlo
  tolerance and trial count.
- **Toolchain — align declared and tested OCaml versions.** Set the `dune-project`
  floor to `>= 5.1` (the version CI builds) and regenerate `gamblers_ruin.opam`.
  CI itself is unchanged.

Deliberately out of scope (reviewed, left as-is): the `.claude/` tooling
duplication (opsx commands vs. skills, agent-definition example blocks) and the
`floatarray` return type of the engine.

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `gamblers-ruin-computations`: the **Routes agree** requirement gains a scenario
  asserting that engine and analytic **expected durations** match for constant
  `p`, not only ruin probabilities — making the stated three-route agreement
  actually verified for durations.
- `continuous-integration`: add a requirement that the OCaml version CI builds is
  the project's declared minimum, so the declared floor and the tested version
  cannot silently diverge.

## Impact

- **Code:** `lib/engine.ml`, `lib/simulate.ml`, `bin/main.ml` — no public API
  change (the `floatarray` interface is untouched) and no change to any computed
  result.
- **Tests:** `test/test_gamblers_ruin.ml` — one new property, one converted case,
  one rationale comment.
- **Docs / build config:** `README.md`, `dune-project`, and the generated
  `gamblers_ruin.opam`.
- **CI:** `.github/workflows/ci.yml` is unchanged (the floor is lowered to match
  what CI already builds).
- The build must stay warning-clean and `dune test` must stay green.
