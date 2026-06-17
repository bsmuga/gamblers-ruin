## 1. Library scaffold

- [x] 1.1 Create `lib/dune` with a `(library (name gamblers_ruin) ...)` stanza
- [x] 1.2 Add `lib/gamblers_ruin.ml` exposing a trivial value (e.g. `let name = "gamblers_ruin"`)
- [x] 1.3 Add `lib/gamblers_ruin.mli` declaring that value, keeping the interface in sync

## 2. Test suite

- [x] 2.1 Add `alcotest` as a test dependency in `dune-project`
- [x] 2.2 Create `test/dune` with a `(test ...)` stanza depending on `gamblers_ruin` and `alcotest`
- [x] 2.3 Add `test/test_gamblers_ruin.ml` with one `alcotest` group asserting on the library value
- [x] 2.4 Run `dune test` and confirm it builds warning-clean and passes

## 3. Formatting baseline

- [x] 3.1 Add an `.ocamlformat` file pinning the formatter version
- [x] 3.2 Run `dune fmt` and confirm the tree is clean (profile = janestreet, idempotent)

## 4. CI pipeline

- [x] 4.1 Create `.github/workflows/ci.yml` triggered on `push` and `pull_request`
- [x] 4.2 Configure `ocaml/setup-ocaml` with a pinned compiler and dependency install
- [x] 4.3 Add steps: `dune build`, `dune fmt` check, `dune test`
- [x] 4.4 Verify the workflow file is valid YAML and the step order matches the design

## 5. Verification

- [x] 5.1 Run `dune build && dune fmt && dune test` locally with no warnings or failures
- [ ] 5.2 Push a branch / open a PR and confirm the CI workflow runs green (pending: requires user to push)
