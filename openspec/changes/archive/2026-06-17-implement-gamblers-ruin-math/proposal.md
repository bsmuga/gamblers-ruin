## Why

The scaffold left `Engine`, `Analytic`, and `Simulate` as `TODO` stubs. This change fills
them in: the numerical engine that solves the absorbing chain, the closed-form oracle, and
the seeded Monte-Carlo — so the project actually computes gambler's-ruin results and the
three routes cross-check each other.

## What Changes

- Implement `Engine`: reduce first-step analysis to a tridiagonal system and solve it with
  the Thomas algorithm, returning `ruin_probabilities` and `expected_durations` for every
  start state at once. Works for any `Walk.t`, including state-dependent `win i`.
- Implement `Analytic`: closed forms for constant `p`, covering the fair (`p = 1/2`) and
  unfair (`p ≠ 1/2`) cases; raise `Invalid_argument` on a non-constant walk.
- Implement `Simulate`: seeded, reproducible `trajectory` and `monte_carlo` (ruin frequency
  and mean steps) using an explicit PRNG state.
- Wire the CLI: print engine + analytic results, and render one trajectory in the terminal
  with `--simulate --seed`.
- Add `qcheck-alcotest` (`:with-test`) and a real test suite: special cases, invariants
  (property-based), and the three-way Engine ≈ Analytic ≈ Simulate agreement.

## Capabilities

### New Capabilities
- `gamblers-ruin-computations`: the mathematical behavior — ruin probabilities and expected
  durations via the numerical engine, the closed-form formulas, seeded simulation, their
  numerical stability, and the cross-checking agreement between routes.

### Modified Capabilities
- `repository-scaffold`: two requirements asserted the stubbed state and must reflect the
  now-implemented modules — `Three-route library layout` (modules are implemented, not
  `TODO` stubs) and `Test target` (agreement tests are real assertions, not TODO markers).

## Impact

- Modified code: `lib/engine.ml`, `lib/analytic.ml`, `lib/simulate.ml`, `bin/main.ml`,
  `test/test_gamblers_ruin.ml`, `test/dune`.
- Dependencies: add `qcheck-alcotest` (`:with-test`) to `dune-project`. The library core
  (`lib/`) still has no runtime dependencies.
- `.mli` interfaces are unchanged — this fills in bodies behind the existing contracts.
