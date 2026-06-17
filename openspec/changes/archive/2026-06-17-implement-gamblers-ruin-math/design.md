## Context

The scaffold (`repository-scaffold`) established the model `Walk` (`target`, `win : int ->
float`) and three stubbed routes behind fixed `.mli` contracts. This change supplies the
bodies. The `.mli` signatures are already decided, so design here is about algorithms and
numerical choices, not interfaces.

## Goals / Non-Goals

**Goals:**
- A stable, `O(N)` engine that handles general birth–death (state-dependent `win`).
- Closed forms valid for constant `p`, both fair and unfair, as an independent oracle.
- Reproducible simulation driven solely by `seed`.
- A test suite where the three routes cross-check, plus property-based invariants.

**Non-Goals:**
- Distribution of duration / generating functions (only the means `h_i`, `k_i`).
- Performance tuning beyond the natural `O(N)` solve.
- Rich CLI (argument parsing stays minimal; one trajectory rendering).

## Decisions

- **Engine via the Thomas algorithm on the interior states `1..N-1`.** First-step analysis
  gives, for ruin probabilities `h`: `h_i = p_i h_{i+1} + q_i h_{i-1}` with `h_0 = 1`,
  `h_N = 0`; rearranged to tridiagonal `-q_i h_{i-1} + h_i - p_i h_{i+1} = 0`. Durations
  `k` solve the same matrix with right-hand side `1` and `k_0 = k_N = 0`. One forward sweep
  + back-substitution per quantity. The matrix is diagonally dominant ⇒ stable; no
  `(q/p)^N` overflow. Rejected: matrix inversion (O(N³), pointless for tridiagonal) and the
  naive closed-form recurrence (overflows for large `N`).
- **Engine returns `floatarray` of length `N+1`** indexed by state, including the absorbing
  endpoints (`h_0=1, h_N=0`; `k_0=k_N=0`). Callers index by `start`.
- **`win` is read once per interior state** into local arrays `p_i`, `q_i = 1 - p_i`, so a
  costly `win` is not called repeatedly during the sweep.
- **Analytic uses `r = q/p`.** Detect the fair case with an exact `p = 0.5` test in `Walk`
  terms; otherwise use the ratio formulas. Constant-`p` is verified by sampling `win` across
  interior states and requiring equality; raise `Invalid_argument` otherwise. The oracle is
  intended for the numerically safe range; the engine is the workhorse for large `N`.
- **Simulation PRNG threaded explicitly.** Use a `Random.State.t` seeded from `seed`; one
  state per `monte_carlo` call drives all trials, keeping `lib/` pure (no global RNG) and
  runs reproducible. `trajectory` builds the path in a growable buffer until absorption.
- **Tests in three layers.** (1) special cases vs. hand formulas (fair `h_i=(N−i)/N`,
  `k_i=i(N−i)`; boundaries). (2) `qcheck` invariants: `0≤h_i≤1`, `h` non-increasing in `i`,
  `k_i≥0`, `survival+ruin=1`. (3) agreement: `Engine ≈ Analytic` (tight tol) and
  `Engine ≈ monte_carlo` (loose tol scaled by `1/√trials`, fixed seed).

## Risks / Trade-offs

- [Monte-Carlo agreement test is statistical and could flake] → Fix the `seed`, use a
  generous tolerance derived from trials, and keep `trials` large enough; assert a bound,
  not equality.
- [Constant-`p` detection by sampling could misclassify a pathological `win`] → Acceptable:
  `Analytic` is documented as constant-`p` only and is reached via `Walk.constant` in
  practice; the check is a guard, not a proof.
- [Thomas algorithm divides by pivots] → Pivots stay away from zero given `0 < p_i < 1`;
  guard the degenerate `p_i ∈ {0,1}` inputs (document or reject) so no division by zero.
- [Toolchain still not installed locally] → Same as scaffold: write carefully; CI compiles.
