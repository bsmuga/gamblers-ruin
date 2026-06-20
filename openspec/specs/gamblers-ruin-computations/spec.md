## Purpose

The gambler's-ruin mathematics computed three independent, cross-checking ways: a numerical
`Engine` (absorbing Markov chain solved with the Thomas algorithm), closed-form `Analytic`
formulas, and a seeded `Simulate` Monte-Carlo. The routes must agree on shared quantities.

## Requirements

### Requirement: Engine computes ruin probabilities

`Engine.ruin_probabilities` SHALL return, for a `Walk.t` with target `N`, an array of
length `N+1` whose entry `i` is the probability of absorption at `0` before `N` starting
from state `i`. It MUST satisfy the boundary conditions `h_0 = 1` and `h_N = 0`, solve the
tridiagonal first-step system with the Thomas algorithm, and support state-dependent win
probabilities.

#### Scenario: Fair game matches the linear law

- **WHEN** `ruin_probabilities` is called on `Walk.constant ~target:N ~p:0.5`
- **THEN** entry `i` equals `(N - i) / N` within `1e-9` for every `0 <= i <= N`

#### Scenario: Boundaries are exact

- **WHEN** `ruin_probabilities` is called on any valid walk with target `N`
- **THEN** entry `0` equals `1.0` and entry `N` equals `0.0`

#### Scenario: Probabilities are non-increasing in the start state

- **WHEN** `ruin_probabilities` is called on any valid walk
- **THEN** each entry lies in `[0, 1]` and the entries are non-increasing as `i` increases

### Requirement: Engine computes expected durations

`Engine.expected_durations` SHALL return, for a `Walk.t` with target `N`, an array of
length `N+1` whose entry `i` is the expected number of rounds until absorption starting
from state `i`, with `k_0 = k_N = 0`, computed from the same tridiagonal system with a
constant unit right-hand side.

#### Scenario: Fair game matches i(N-i)

- **WHEN** `expected_durations` is called on `Walk.constant ~target:N ~p:0.5`
- **THEN** entry `i` equals `i * (N - i)` within `1e-9` for every `0 <= i <= N`

#### Scenario: Durations are non-negative

- **WHEN** `expected_durations` is called on any valid walk
- **THEN** every entry is `>= 0`, and entries `0` and `N` equal `0`

### Requirement: Closed-form analytic results

`Analytic.ruin_probability` and `Analytic.expected_duration` SHALL return the closed-form
values for a constant win probability `p`, handling both the fair case `p = 1/2` and the
unfair case `p <> 1/2`. They MUST raise `Invalid_argument` when applied to a walk whose win
probability is not constant.

#### Scenario: Unfair game matches the ratio formula

- **WHEN** `ruin_probability` is called with constant `p <> 0.5`, target `N`, start `i`
- **THEN** it returns `(r^N - r^i) / (r^N - 1)` with `r = (1 - p) / p` within `1e-9`

#### Scenario: Rejects a non-constant walk

- **WHEN** `ruin_probability` or `expected_duration` is called on a walk built with a
  non-constant `win`
- **THEN** it raises `Invalid_argument`

### Requirement: Seeded Monte-Carlo simulation

`Simulate.trajectory` SHALL return the sequence of fortunes from `start` until absorption
at `0` or `target`, and `Simulate.monte_carlo` SHALL return `(ruin_frequency, mean_steps)`
over the requested number of trials. Both MUST be reproducible: identical inputs and `seed`
produce identical results, and no global random state is used.

#### Scenario: Reproducible runs

- **WHEN** `monte_carlo` is called twice with identical `walk`, `start`, `trials`, and `seed`
- **THEN** both calls return identical `(ruin_frequency, mean_steps)`

#### Scenario: Trajectory starts and ends correctly

- **WHEN** `trajectory w ~start ~seed` is called
- **THEN** the first element is `start` and the last element is `0` or `w.target`, with all
  interior elements strictly between `0` and `w.target`

### Requirement: Routes agree

The three routes SHALL agree on shared quantities. The engine and analytic results
MUST match closely for constant `p` — for both ruin probabilities and expected
durations — and the simulation MUST match the analytic ruin frequency within a
tolerance that shrinks with the number of trials.

#### Scenario: Engine matches analytic

- **WHEN** both are evaluated on `Walk.constant ~target:N ~p` for several `p` and `N`
- **THEN** `Engine.ruin_probabilities.(i)` equals `Analytic.ruin_probability ~start:i`
  within `1e-9` for every interior `i`

#### Scenario: Engine matches analytic on expected durations

- **WHEN** `Engine.expected_durations` and `Analytic.expected_duration` are evaluated
  on `Walk.constant ~target:N ~p` for several `p` and `N`, covering both the fair case
  `p = 1/2` and the unfair case `p <> 1/2`
- **THEN** `Engine.expected_durations.(i)` equals `Analytic.expected_duration ~start:i`
  within a relative tolerance for every interior `i`

#### Scenario: Simulation matches analytic

- **WHEN** `monte_carlo` runs many trials with a fixed seed on a constant-`p` walk
- **THEN** the estimated ruin frequency is within a trials-scaled tolerance of
  `Analytic.ruin_probability`
