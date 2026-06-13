# gamblers-ruin

An OCaml project (Dune build system, managed via OPAM). The repository is in early
stage — source code is added under `bin/`, `lib/`, and `test/` as the project grows.

## Build & test

```sh
dune build          # compile the project
dune exec <name>    # run an executable defined in bin/dune
dune test           # run the test suite
dune fmt            # format with ocamlformat
dune utop lib       # interactive REPL with the library loaded
```

Use a local OPAM switch (`_opam/`, gitignored) to isolate dependencies:

```sh
opam switch create . --deps-only
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
