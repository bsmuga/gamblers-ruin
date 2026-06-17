## MODIFIED Requirements

### Requirement: Project documentation

The repository SHALL include a `README.md` describing the gambler's-ruin problem, the
three-route design, and build/test usage. The `.claude/CLAUDE.md` SHALL document the
project's minimalism philosophy. The README MUST reflect the implemented state of the
library — it MUST NOT describe `Engine`, `Analytic`, or `Simulate` as `TODO`/stub bodies
once they are implemented. The documented local build/test instructions MUST succeed from
a fresh shell with the toolchain installed, including the step that activates the local
OPAM switch so `dune` is on `PATH`.

#### Scenario: README present

- **WHEN** a reader opens the repository
- **THEN** `README.md` explains the problem, the engine/analytic/simulation design, and how
  to build and test the project

#### Scenario: Documentation reflects implemented state

- **WHEN** the README describes the status of the `Engine`, `Analytic`, and `Simulate` modules
- **THEN** it describes them as implemented, not as `TODO`/stub bodies

#### Scenario: Local instructions run from a fresh shell

- **WHEN** a developer follows the README build/test instructions in a fresh shell after
  creating the local OPAM switch
- **THEN** the documented commands include activating the switch (e.g. `eval $(opam env)`),
  and `dune build`, `dune test`, and `dune fmt` then run successfully
