# gamblers-ruin

[![CI](https://github.com/bsmuga/gamblers-ruin/actions/workflows/ci.yml/badge.svg)](https://github.com/bsmuga/gamblers-ruin/actions/workflows/ci.yml)

The **gambler's-ruin** problem, solved three independent ways that cross-check
one another. A gambler starts with fortune `i`, bets one unit per round, wins
with probability `p` and loses with `q = 1 − p`. The states `0` (ruin) and `N`
(target) are absorbing:

```
   0                      i (start)                 N (target)
   ●━━━━━━━━━━━━━━━━━━━━━━━━◆━━━━━━━━━━━━━━━━━━━━━━━━━━●
  ruin                  fortune                     win
(absorbing)         +1 w.p. p,  −1 w.p. q=1−p   (absorbing)
```

## The three routes

| Module      | Approach | Notes |
|-------------|----------|-------|
| `Engine`    | Numerical: first-step analysis → tridiagonal system → Thomas algorithm | Stable (`O(N)`); handles state-dependent `win i`; returns the answer for every start state at once |
| `Analytic`  | Closed-form formulas | Constant `p` only; used as the oracle |
| `Simulate`  | Seeded Monte-Carlo | Pure; reproducible from a `seed` |

The closed forms (constant `p`, `r = q/p`, target `N`):

```
ruin probability  h_i = (r^N − r^i) / (r^N − 1)      (p ≠ q),   (N − i)/N   (p = q)
expected duration k_i = i/(q−p) − N/(q−p)·(1−r^i)/(1−r^N)  (p ≠ q),  i·(N − i)  (p = q)
```

The test suite asserts that the engine, the closed forms, and the simulation all
agree.

## Layout

```
lib/    walk · engine · analytic · simulate   (the library `gamblers_ruin`)
bin/    main.ml                                (minimal CLI)
test/   alcotest suite
```

## Build & test

```sh
opam switch create . --deps-only --with-test   # one-time: local switch + deps
eval $(opam env)                               # activate the switch (puts dune on PATH)
dune build                                     # compile (warning-clean)
dune test                                      # run the suite
dune build @fmt                                # check formatting
dune exec gamblers-ruin -- --target 10 --start 5 --p 0.5   # run the CLI
```

## Running the CLI

```sh
dune exec gamblers-ruin -- --target 10 --start 4 --p 0.45 --simulate --seed 3
```

| Flag | Meaning |
|------|---------|
| `--target N` | upper absorbing barrier (required, `N ≥ 2`) |
| `--start I` | initial fortune |
| `--p P` | win probability per round |
| `--simulate` | also render one simulated trajectory as a sparkline |
| `--seed S` | PRNG seed for `--simulate` |

It prints the ruin probability (engine and analytic — which agree) and the expected
duration; with `--simulate` it also renders one trajectory and its outcome:

```
ruin probability   0.808734 (engine)  0.808734 (analytic)
expected duration  20.8734 rounds
▃▂▃▄▅▆▆▆▆▇▆▆▆▇█
outcome: reached target in 14 rounds
```

The library is also usable directly from a REPL:

```sh
dune utop lib   # then: Gamblers_ruin.Engine.ruin_probabilities (Gamblers_ruin.Walk.constant ~target:10 ~p:0.5);;
```

## License

MIT — see [LICENSE](LICENSE).
