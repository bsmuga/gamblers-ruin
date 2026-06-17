## 1. Build configuration

- [x] 1.1 Create `dune-project` (lang dune `>= 3.0`, package `gamblers_ruin`, metadata, `generate_opam_files true`)
- [x] 1.2 Add `.ocamlformat` (`profile = default`, version pinned to 0.26.2)
- [x] 1.3 Confirm `.gitignore` covers `_build/` and `_opam/` (already present)

## 2. Library (`lib/`)

- [x] 2.1 Add `lib/dune` declaring `(library (name gamblers_ruin))`
- [x] 2.2 Implement `lib/walk.mli` and `lib/walk.ml` (model: `type t`, `constant`, `create`, validation)
- [x] 2.3 Add `lib/engine.mli` (`ruin_probabilities`, `expected_durations`) with `failwith "TODO"` stub `.ml`
- [x] 2.4 Add `lib/analytic.mli` (`ruin_probability`, `expected_duration`, constant-`p` oracle) with stub `.ml`
- [x] 2.5 Add `lib/simulate.mli` (`outcome`, `trajectory`, `monte_carlo`) with stub `.ml`

## 3. Executable (`bin/`)

- [x] 3.1 Add `bin/dune` (`(executable (name main) (public_name gamblers-ruin) (libraries gamblers_ruin))`)
- [x] 3.2 Add `bin/main.ml` printing planned usage; no calls into stubbed math

## 4. Tests (`test/`)

- [x] 4.1 Add `test/dune` (`(test (name test_gamblers_ruin) (libraries gamblers_ruin alcotest))`)
- [x] 4.2 Add `test/test_gamblers_ruin.ml` exercising `Walk` construction and validation; mark engine/analytic/simulation agreement tests as TODO

## 5. CI and documentation

- [x] 5.1 Add `.github/workflows/ci.yml` (setup-ocaml, `dune build`, `dune test`)
- [x] 5.2 Write `README.md` (problem statement, three-route design, build/test usage)
- [x] 5.3 Add minimalism philosophy section to `.claude/CLAUDE.md`; update layout note now that structure exists

## 6. Verification

- [ ] 6.1 Run `dune build` (warning-clean), `dune fmt`, and `dune test`; fix any issues
      — deferred: no OCaml toolchain in the authoring environment. Run locally or rely on CI.
