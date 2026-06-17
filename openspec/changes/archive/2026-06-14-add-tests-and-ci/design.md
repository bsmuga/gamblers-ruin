## Context

The repository is empty scaffolding: `dune-project` declares the `gamblers_ruin` package and
its ambitions, but there is no `lib/`, `bin/`, or `test/`, and no automated checks run on
pushes. We want to establish the testing and CI guarantees *before* substantive code lands, so
the very first feature is developed against a working harness rather than retrofitting one
later. The constraint is to keep this minimal — a pattern to follow, not a full test suite for
code that does not exist yet.

## Goals / Non-Goals

**Goals:**
- A `dune test` invocation that builds and passes locally and in CI.
- A clear, copyable example of the test pattern future contributors extend.
- A CI pipeline that builds, format-checks, and tests on every push and pull request, and fails
  on warnings, formatting drift, or test failures.

**Non-Goals:**
- Implementing any gambler's-ruin logic (numerical engine, closed forms, simulation) — that is
  future work.
- Property-based testing, coverage reporting, release/publish automation, or multi-OS testing.
- Caching tuning beyond what the standard OCaml CI action provides out of the box.

## Decisions

**Test framework: `alcotest`.** The project conventions (`.claude/CLAUDE.md`) name `alcotest`
or expect tests as preferred. `alcotest` gives readable, structured test output that works
cleanly in CI, and is the more conventional choice for a library with numeric assertions.
*Alternative considered:* inline expect tests (`ppx_expect`) — rejected for now to avoid pulling
in the ppx toolchain before there is code that benefits from snapshot-style assertions.

**Minimal placeholder under test.** `lib/` exposes a trivial value (e.g. a `name` or `version`
string) with a matching `.mli`, and the test asserts it. This keeps the harness honest (it
actually exercises the library) without inventing throwaway domain logic.
*Alternative considered:* an empty test that always passes — rejected because it would not
demonstrate the lib-to-test wiring future contributors need to copy.

**CI via GitHub Actions + `ocaml/setup-ocaml`.** The `dune-project` already points at a GitHub
source (`bsmuga/gamblers-ruin`), so GitHub Actions is the natural fit. The official
`ocaml/setup-ocaml` action handles the OPAM switch and caching.
*Alternative considered:* a hand-rolled OPAM install script — rejected as more fragile and
slower than the maintained action.

**CI steps and ordering.** `dune build` → `dune fmt` check → `dune test`. Formatting is enforced
in CI (not just locally) to keep `dune fmt` violations from merging. The build is warning-clean
per project convention, so warnings fail the build.

## Risks / Trade-offs

- [Format check pins an `ocamlformat` version] → Add an `.ocamlformat` file so local and CI
  formatting agree; without it `dune fmt --check` can diverge between machines.
- [Testing a placeholder gives a false sense of coverage] → The spec scopes the test as a
  *pattern*, and `tasks.md` makes clear real tests arrive with real code.
- [CI minutes / action version drift] → Pin the OCaml compiler version in the workflow and use a
  stable major version of the setup action; the single-job matrix keeps usage low.
