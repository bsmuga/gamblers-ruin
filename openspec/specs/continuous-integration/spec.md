## Purpose

A GitHub Actions workflow that runs on every push and pull request, sets up a pinned
OCaml/OPAM toolchain, and enforces the build, formatting, and tests so that broken or
unformatted code is caught automatically.
## Requirements
### Requirement: CI workflow on push and pull request

The project SHALL include a GitHub Actions workflow that runs automatically on pushes and on
pull requests. The workflow SHALL set up an OCaml/OPAM environment and install the project's
dependencies before running checks.

#### Scenario: Workflow triggers on push and pull request

- **WHEN** a commit is pushed or a pull request is opened or updated
- **THEN** the CI workflow runs automatically

#### Scenario: Environment is prepared

- **WHEN** the workflow runs
- **THEN** it sets up a pinned OCaml compiler via the OPAM toolchain and installs project
  dependencies before any check step

### Requirement: CI enforces build, formatting, and tests

The workflow SHALL run `dune build`, a non-mutating formatting check, and `dune test`. The
workflow SHALL fail if the build emits warnings, if formatting does not match `ocamlformat`,
or if any test fails. The formatting step MUST NOT rewrite files in place; it MUST be a
check that exits non-zero on drift (e.g. `dune build @fmt`). A step that runs `dune fmt`
(which reformats in place and always exits zero) does NOT satisfy this requirement.

#### Scenario: Failing build or test fails CI

- **WHEN** `dune build` produces a warning/error or `dune test` reports a failure
- **THEN** the workflow concludes with a failing status

#### Scenario: Formatting drift fails CI

- **WHEN** the committed source does not match `ocamlformat` output
- **THEN** the formatting check step exits non-zero and the workflow fails

#### Scenario: Formatting step does not mutate the checkout

- **WHEN** the CI formatting step runs
- **THEN** it verifies formatting without rewriting tracked files, so it does not rely on
  `dune fmt`'s in-place reformat (which always exits zero)

### Requirement: CI builds the declared minimum OCaml version

The OCaml compiler version the CI workflow installs SHALL be the project's declared
minimum supported version (the `(ocaml (>= X))` constraint in `dune-project`, mirrored
in the generated opam file), so that the declared floor is the version actually built
and tested. The declared minimum and the version CI pins MUST NOT silently diverge.

#### Scenario: Declared floor matches the CI compiler

- **WHEN** `dune-project`'s `(ocaml (>= X))` constraint and the CI workflow's pinned
  `ocaml-compiler` are compared
- **THEN** the CI compiler is the declared minimum `X` — or, if a version matrix is
  used, the matrix includes `X` — so the declared floor is exercised by CI

#### Scenario: Lowered floor is reflected everywhere

- **WHEN** the declared minimum OCaml version is changed in `dune-project`
- **THEN** the generated `gamblers_ruin.opam` is regenerated to match and CI still
  pins a version that satisfies the new floor

