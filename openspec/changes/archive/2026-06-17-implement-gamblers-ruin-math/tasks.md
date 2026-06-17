## 1. Engine (numerical core)

- [x] 1.1 Read interior `win i` into local `p`/`q` arrays; guard degenerate `p in {0,1}`
- [x] 1.2 Implement the Thomas algorithm (forward sweep + back-substitution) over `1..N-1`
- [x] 1.3 `Engine.ruin_probabilities`: solve with RHS 0, boundaries `h_0=1`, `h_N=0`
- [x] 1.4 `Engine.expected_durations`: solve with unit RHS, boundaries `k_0=k_N=0`

## 2. Analytic (closed-form oracle)

- [x] 2.1 Detect constant `p` (sample `win` over interior states); raise `Invalid_argument` otherwise
- [x] 2.2 `Analytic.ruin_probability`: fair (`p=1/2`) and unfair (`r=q/p`) formulas
- [x] 2.3 `Analytic.expected_duration`: fair and unfair formulas

## 3. Simulate (Monte-Carlo)

- [x] 3.1 `Simulate.trajectory`: seeded `Random.State.t`, walk until absorption, return the path
- [x] 3.2 `Simulate.monte_carlo`: run `trials` from one seeded state; return `(ruin_freq, mean_steps)`

## 4. CLI

- [x] 4.1 Parse `--target --start --p [--simulate --seed]`; print engine + analytic results
- [x] 4.2 Render one trajectory as ASCII when `--simulate` is given

## 5. Tests

- [x] 5.1 Add `qcheck-alcotest` (`:with-test`) to `dune-project` and `test/dune`
- [x] 5.2 Special cases: fair `h_i=(N-i)/N`, `k_i=i(N-i)`; boundaries
- [x] 5.3 Property-based invariants (qcheck): `0<=h_i<=1`, `h` non-increasing, `k_i>=0`, survival+ruin=1
- [x] 5.4 Agreement: `Engine ≈ Analytic` (tight) and `monte_carlo ≈ Analytic` (trials-scaled, fixed seed)
- [x] 5.5 `Analytic` raises `Invalid_argument` on a non-constant walk

## 6. Verification

- [x] 6.1 Run `dune build` (warning-clean), `dune fmt`, and `dune test`; fix any issues
