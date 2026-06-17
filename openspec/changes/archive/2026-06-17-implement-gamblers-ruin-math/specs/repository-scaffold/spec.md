## MODIFIED Requirements

### Requirement: Three-route library layout

The `lib/` directory SHALL expose a library `gamblers_ruin` containing four modules, each
with an `.mli` interface kept in sync with its `.ml`: `Walk` (the model), `Engine`
(numerical core), `Analytic` (closed forms), and `Simulate` (Monte-Carlo). All four modules
SHALL be fully implemented.

#### Scenario: Model is usable

- **WHEN** code calls `Walk.constant ~target ~p` with `0 <= p <= 1` and `target >= 2`
- **THEN** it returns a model whose `win i` equals `p` for every interior state `i`

#### Scenario: Model rejects invalid parameters

- **WHEN** code calls `Walk.constant` with `p` outside `[0, 1]` or `target < 2`
- **THEN** it raises `Invalid_argument`

#### Scenario: Mathematical modules are implemented

- **WHEN** `Engine`, `Analytic`, or `Simulate` functions are called on a valid walk
- **THEN** they return computed results rather than raising a `TODO`/`Failure`

### Requirement: Test target

The `test/` directory SHALL define a test target that builds and passes, exercising the
`Walk` model and the implemented mathematical routes. The three-way agreement tests (engine
vs. analytic vs. simulation) SHALL be real assertions, not TODO markers.

#### Scenario: Tests pass

- **WHEN** a developer runs `dune test`
- **THEN** the suite builds and passes, validating `Walk`, the closed forms, the engine, the
  simulation, and their agreement
