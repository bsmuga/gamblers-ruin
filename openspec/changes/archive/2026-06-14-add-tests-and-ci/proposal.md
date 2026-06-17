## Why

The repository declares an ambitious package (numerical engine, closed forms, Monte-Carlo
simulation that cross-check one another) but has no source code, no test harness, and no
automated checks. Before real implementation begins, we need a minimal, working test setup
and a CI pipeline so that every future change is built, formatted, and tested automatically —
catching regressions and style drift from the very first commit rather than after the code
has grown.

## What Changes

- Add a minimal `lib/` library and a `test/` suite wired with `dune` so `dune test` runs and
  passes against a trivial placeholder (e.g. a `version`/identity value), establishing the
  testing pattern for future work.
- Adopt `alcotest` as the test framework, declared as a dev dependency in `dune-project`, with
  one example test group that future tests can follow.
- Add a GitHub Actions CI workflow (`.github/workflows/ci.yml`) that, on push and pull request,
  sets up OCaml/OPAM, installs dependencies, and runs `dune build`, `dune fmt --check`, and
  `dune test` — failing the build on warnings, formatting violations, or test failures.

## Capabilities

### New Capabilities
- `automated-testing`: A `dune`-managed test suite using `alcotest`, with a documented pattern
  (a `test/` stanza and an example test group) that all future tests follow.
- `continuous-integration`: A GitHub Actions pipeline that builds, format-checks, and tests the
  project on every push and pull request.

### Modified Capabilities
<!-- None: no existing specs in openspec/specs/. -->

## Impact

- New files: `lib/` (placeholder module + `dune`), `test/` (example test + `dune`),
  `.github/workflows/ci.yml`.
- Modified files: `dune-project` (add `alcotest` dev dependency).
- New dependency: `alcotest` (test-only).
- No production behavior yet — this is scaffolding that establishes build/test/CI guarantees.
