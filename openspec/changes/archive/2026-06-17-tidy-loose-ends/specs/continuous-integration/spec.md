## MODIFIED Requirements

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
