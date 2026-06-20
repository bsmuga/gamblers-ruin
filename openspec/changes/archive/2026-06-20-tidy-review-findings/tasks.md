## 1. Engine cleanup

- [x] 1.1 In `lib/engine.ml`, remove `let sub = Array.copy q in` and `let sup = Array.copy p in`; pass `~sub:q ~sup:p` to `solve_tridiagonal` (keeping local bindings if it reads more clearly, but without copying).
- [x] 1.2 Delete the inline comment `(* fold the known boundary values into the right-hand side *)` at the boundary-fold lines; leave the header derivation (lines 1-8) and the `solve` doc comment intact.

## 2. Comment and CLI cleanup

- [x] 2.1 In `lib/simulate.ml`, delete the `(* [+1] with probability [win pos], else [-1]. *)` comment on `step`.
- [x] 2.2 In `bin/main.ml`, introduce `let top = Array.length blocks - 1 in` and scale the sparkline index by `float_of_int top` instead of the hard-coded `8.0`.

## 3. README

- [x] 3.1 Remove the `## Status` section from `README.md` (the routes table already conveys the implemented design).
- [x] 3.2 Remove the duplicated hard-coded "12 cases" count from the Build & test section so `dune test` is the single source of truth.

## 4. Tests

- [x] 4.1 Add a QCheck property `prop_engine_matches_analytic_durations` over `gen_walk` asserting `Engine.expected_durations.(i)` agrees with `Analytic.expected_duration ~start:i` for every interior `i`, covering both `p = 1/2` and `p <> 1/2`, using a relative tolerance (`abs diff <= 1e-6 *. (1. +. Float.abs expected)`); register it in the `properties` group.
- [x] 4.2 Convert `test_unfair_example` into a known-answer anchor: replace the `Analytic`-derived expectations with literals for `n=5, p=0.4` computed from `h_i = (r^N - r^i)/(r^N - 1)` with `r = 1.5`, mirroring `test_fair_special`.
- [x] 4.3 Add a single WHY comment above the `< 0.03` assertion in `test_sim_matches_analytic` stating the safety margin (ruin prob ~0.6, SE ~0.0035 over 20000 trials, ~8σ, never flakes on the fixed seed).

## 5. Toolchain alignment

- [x] 5.1 In `dune-project`, change the OCaml constraint to `(ocaml (>= 5.1))`.
- [x] 5.2 Run `dune build` to regenerate `gamblers_ruin.opam`; do not hand-edit it. Confirm the opam floor now reads `>= 5.1`.

## 6. Verify

- [x] 6.1 Run `dune build` and confirm it is warning-clean.
- [x] 6.2 Run `dune fmt` (or `dune build @fmt`) and confirm no formatting drift.
- [x] 6.3 Run `dune test` and confirm all cases pass, including the new durations cross-check and the converted unfair anchor.
