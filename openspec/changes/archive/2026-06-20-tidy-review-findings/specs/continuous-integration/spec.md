## ADDED Requirements

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
