# gamblers-ruin

An OCaml project (Dune build system, managed via OPAM) computing the gambler's-ruin
problem three independent, cross-checking ways: a numerical `Engine` (absorbing Markov
chain → tridiagonal Thomas solve), closed-form `Analytic` formulas, and a seeded
`Simulate` Monte-Carlo. Source lives under `bin/`, `lib/`, and `test/`.

## Project philosophy — minimalism

Minimalism here means no superficial software-engineering scaffolding, not less mathematics.

- **Substance over ceremony.** No wrapper layers, factories, or abstraction added "for
  later." Each `lib/` module is a distinct mathematical concern: `Walk` (model), `Engine`
  (numerical solver), `Analytic` (closed forms), `Simulate` (Monte-Carlo).
- **The interface is the specification.** Keep `.mli` files readable as definitions and
  theorem statements; they are the project's primary documentation.
- **Pure, seeded core.** `lib/` has no I/O and no global state; randomness enters only
  through an explicit `seed`. All rendering lives in `bin/`.
- **Prefer the stable method.** Solve via diagonally-dominant tridiagonal recurrences
  (Thomas), not formulas that overflow. Closed forms are kept as test oracles.
- **Three routes must agree.** Engine, closed form, and Monte-Carlo cross-check each other
  in the test suite.
- **Dependencies are a cost.** The engine and analytic core use no external libraries.

## Build & test

```sh
dune build          # compile the project
dune exec <name>    # run an executable defined in bin/dune
dune test           # run the test suite
dune fmt            # format with ocamlformat
dune utop lib       # interactive REPL with the library loaded
```

Use a local OPAM switch (`_opam/`, gitignored) to isolate dependencies. Activate it
with `eval $(opam env)` so `dune` is on `PATH` in a fresh shell:

```sh
opam switch create . --deps-only --with-test   # create the switch with test deps
eval $(opam env)                               # activate it (puts dune on PATH)
```

## Layout conventions

- `bin/` — executables (entry points), each with a `dune` stanza using `(executable ...)`.
- `lib/` — reusable library code, exposed via `(library ...)`.
- `test/` — tests, typically `(test ...)` stanzas; prefer expect tests or `alcotest`.
- `dune-project` — declares the Dune lang version and package metadata.

## Conventions

- Match the surrounding style: snake_case for values/functions, CamelCase for modules
  and constructors. Keep `.mli` interface files in sync with their `.ml` implementations.
- Run `dune build` (and `dune fmt`) before considering a change done; the build must be
  warning-clean.
- `_build/` and `_opam/` are generated — never edit or commit them.
- Keep it simple: prefer the simplest solution that solves the problem in front of you.
  Avoid speculative abstraction, premature generalization, and unused configurability
  (YAGNI).
- Document the main idea, not the steps: give a function a short doc comment stating
  what it's for, and avoid inline comments narrating the body. Don't add comments that
  restate what the code obviously does, narrate the change, or address an AI/agent
  reader. When a comment is warranted, it explains *why* (non-obvious rationale) — not
  *what*.
