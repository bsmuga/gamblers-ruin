## Purpose

A `dune`-managed, `alcotest`-based test suite that builds warning-clean, runs via `dune test`,
and exercises the `gamblers_ruin` library's public interface — establishing the pattern future
tests follow.

## Requirements

### Requirement: Runnable test suite

The project SHALL provide a `dune`-managed test suite that builds and passes via `dune test`.
The suite SHALL exercise the library's public interface so that the lib-to-test wiring is
demonstrated, not merely a self-contained assertion.

#### Scenario: Test suite passes

- **WHEN** a contributor runs `dune test` on a clean checkout
- **THEN** the suite builds without warnings and all test cases pass

#### Scenario: Test exercises the library

- **WHEN** the test suite runs
- **THEN** it imports the `gamblers_ruin` library and asserts on a value exposed by its public
  interface

### Requirement: Alcotest framework

The test suite SHALL use `alcotest` as its framework, and `alcotest` SHALL be declared as a
test-only dependency in `dune-project`. The suite SHALL define at least one named test group
with at least one test case, serving as the pattern future tests follow.

#### Scenario: Alcotest dependency declared

- **WHEN** `dune-project` is inspected
- **THEN** `alcotest` appears as a project dependency (test/dev scope)

#### Scenario: Example test group exists

- **WHEN** the test suite source is inspected
- **THEN** it registers at least one `alcotest` test group containing at least one test case
