## ADDED Requirements

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

The workflow SHALL run `dune build`, a `dune fmt` formatting check, and `dune test`. The
workflow SHALL fail if the build emits warnings, if formatting does not match `ocamlformat`, or
if any test fails.

#### Scenario: Failing build or test fails CI

- **WHEN** `dune build` produces a warning/error or `dune test` reports a failure
- **THEN** the workflow concludes with a failing status

#### Scenario: Formatting drift fails CI

- **WHEN** the committed source does not match `dune fmt` output
- **THEN** the formatting check step fails the workflow
