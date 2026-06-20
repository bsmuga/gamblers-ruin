## MODIFIED Requirements

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
