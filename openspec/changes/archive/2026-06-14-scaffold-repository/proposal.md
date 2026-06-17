## Why

The repository is an empty OCaml project: no `dune-project`, no `lib/`, `bin/`, or
`test/`, no CI, no README. Before any gambler's-ruin mathematics can be written, the
project needs a clean, buildable skeleton that encodes the intended structure and the
minimalist conventions — so subsequent changes add only mathematics, never plumbing.

## What Changes

- Add Dune build configuration (`dune-project`, generated `gamblers_ruin.opam`) and an
  `.ocamlformat` so `dune build` / `dune fmt` work and the build is warning-clean.
- Create the three-route library layout under `lib/` as documented interface stubs:
  - `Walk` — the model (`states {0..N}`, `win : int -> float`); implemented for real.
  - `Engine` — numerical core (tridiagonal / Thomas solve); `.mli` + stubbed `.ml`.
  - `Analytic` — closed-form formulas (constant `p`, oracle); `.mli` + stubbed `.ml`.
  - `Simulate` — seeded Monte-Carlo, pure data; `.mli` + stubbed `.ml`.
- Add a minimal CLI scaffold under `bin/` (`main.ml`) that builds and prints usage.
- Add a `test/` target that builds and exercises the implemented `Walk` model, with the
  three-way agreement tests marked as TODO.
- Add a GitHub Actions CI workflow: `dune build` → `dune test` (optional `dune fmt --check`).
- Add `README.md` documenting the problem, the three-route design, and build/test usage.
- Add a "minimalism" philosophy section to `.claude/CLAUDE.md`.

Non-goals: implementing the engine, closed forms, or simulation. Those land in a later
change; here every mathematical function is an interface plus a `TODO` stub.

## Capabilities

### New Capabilities
- `repository-scaffold`: a buildable, warning-clean OCaml project skeleton — Dune
  configuration, the `lib/`/`bin/`/`test/` layout with documented interface stubs, CI,
  formatting config, and README — onto which the gambler's-ruin mathematics is added later.

### Modified Capabilities
<!-- None: no existing specs/capabilities to modify. -->

## Impact

- New files: `dune-project`, `.ocamlformat`, `lib/`, `bin/`, `test/` (with `dune` stanzas
  and `.ml`/`.mli` stubs), `.github/workflows/ci.yml`, `README.md`.
- Modified: `.claude/CLAUDE.md` (philosophy + layout sections).
- Generated (gitignored / by dune): `gamblers_ruin.opam`, `_build/`, `_opam/`.
- Dependencies: OCaml `>= 4.14`, Dune `>= 3.0`; no external libraries in the core. A test
  framework (`alcotest` / `qcheck`) may be added in the change that implements the math.
