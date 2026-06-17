## Purpose

A buildable, warning-clean OCaml project skeleton — Dune configuration, the
`lib/`/`bin/`/`test/` layout with documented interface stubs, CI, formatting config, and
README — onto which the gambler's-ruin mathematics is added later.
## Requirements
### Requirement: Buildable Dune project

The repository SHALL define a Dune project that compiles warning-clean. It MUST include a
`dune-project` (Dune lang `>= 3.0`, package metadata, `generate_opam_files true`) and an
`.ocamlformat` configuration. `dune build` MUST succeed with no warnings under the dev
profile.

#### Scenario: Clean build

- **WHEN** a developer runs `dune build` on a fresh checkout with the toolchain installed
- **THEN** the build succeeds with no errors and no warnings

#### Scenario: Formatting configured

- **WHEN** a developer runs `dune fmt`
- **THEN** ocamlformat runs using the project `.ocamlformat` profile without configuration errors

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

### Requirement: Minimal CLI scaffold

The `bin/` directory SHALL define an executable that builds against the `gamblers_ruin`
library and runs without crashing, printing planned usage. It MUST NOT call unimplemented
mathematical functions.

#### Scenario: CLI runs

- **WHEN** a developer runs the executable with no arguments
- **THEN** it prints usage/status text and exits successfully without raising

### Requirement: Test target

The `test/` directory SHALL define a test target that builds and passes, exercising the
`Walk` model and the implemented mathematical routes. The three-way agreement tests (engine
vs. analytic vs. simulation) SHALL be real assertions, not TODO markers.

#### Scenario: Tests pass

- **WHEN** a developer runs `dune test`
- **THEN** the suite builds and passes, validating `Walk`, the closed forms, the engine, the
  simulation, and their agreement

### Requirement: Continuous integration

The repository SHALL include a GitHub Actions workflow that, on push and pull request,
sets up OCaml, installs dependencies, and runs `dune build` and `dune test`.

#### Scenario: CI verifies the build

- **WHEN** a commit is pushed or a pull request is opened
- **THEN** the workflow runs `dune build` and `dune test` and reports their status

### Requirement: Project documentation

The repository SHALL include a `README.md` describing the gambler's-ruin problem, the
three-route design, and build/test usage. The `.claude/CLAUDE.md` SHALL document the
project's minimalism philosophy. The README MUST reflect the implemented state of the
library — it MUST NOT describe `Engine`, `Analytic`, or `Simulate` as `TODO`/stub bodies
once they are implemented. The documented local build/test instructions MUST succeed from
a fresh shell with the toolchain installed, including the step that activates the local
OPAM switch so `dune` is on `PATH`.

#### Scenario: README present

- **WHEN** a reader opens the repository
- **THEN** `README.md` explains the problem, the engine/analytic/simulation design, and how
  to build and test the project

#### Scenario: Documentation reflects implemented state

- **WHEN** the README describes the status of the `Engine`, `Analytic`, and `Simulate` modules
- **THEN** it describes them as implemented, not as `TODO`/stub bodies

#### Scenario: Local instructions run from a fresh shell

- **WHEN** a developer follows the README build/test instructions in a fresh shell after
  creating the local OPAM switch
- **THEN** the documented commands include activating the switch (e.g. `eval $(opam env)`),
  and `dune build`, `dune test`, and `dune fmt` then run successfully

