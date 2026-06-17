## 1. Remove dead code

- [x] 1.1 Delete the `outcome` type (`Ruin | Reached_target`) from `lib/simulate.mli`
- [x] 1.2 Delete the `outcome` type from `lib/simulate.ml`
- [x] 1.3 Confirm nothing references it (`bin/main.ml` already uses a local string); rebuild

## 2. Fix CI formatting check

- [x] 2.1 In `.github/workflows/ci.yml`, replace the `dune fmt` step with `dune build @fmt`
      (non-mutating; fails on drift), keeping the build and test steps
- [x] 2.2 Verify the formatting step name/description matches the new behavior

## 3. Fix and complete documentation

- [x] 3.1 Rewrite the README "Status" section to state that `Engine`, `Analytic`, and
      `Simulate` are implemented and the three-route agreement tests pass (no `TODO` stubs)
- [x] 3.2 Update the README "Build & test" section so the commands work from a fresh shell:
      add `eval $(opam env)` after `opam switch create . --deps-only --with-test`
- [x] 3.3 Add the same switch-activation note to the Build & test section of `.claude/CLAUDE.md`

## 4. Verify

- [x] 4.1 In a fresh shell, follow the README exactly (`eval $(opam env)` then build/test/fmt)
      and confirm `dune build` is warning-clean, `dune test` is green (12 cases), `dune build @fmt` passes
- [x] 4.2 Run `dune exec gamblers-ruin -- --target 10 --start 4 --p 0.45 --simulate --seed 3`
      and confirm engine and analytic agree

## 5. Land as a coherent commit history

- [ ] 5.1 Commit conventions & ignores: `.claude/CLAUDE.md`, `.gitignore`
- [ ] 5.2 Commit build config, library & CLI: `dune-project`, `gamblers_ruin.opam`,
      `.ocamlformat`, `lib/*`, `bin/*` (verify `dune build` green at this commit)
- [ ] 5.3 Commit test suite & CI: `test/*`, `.github/workflows/ci.yml` (verify `dune test` green)
- [ ] 5.4 Commit README
- [ ] 5.5 Commit OpenSpec records: `openspec/specs/*`, `openspec/changes/archive/*`, and
      remove the live `openspec/changes/tidy-agent-config/.openspec.yaml`
- [ ] 5.6 Archive this change (`/opsx:archive tidy-loose-ends`) and commit its record

## 6. Optional follow-up (out of scope unless requested)

- [ ] 6.1 Push the branch so CI runs for the first time (resolves the long-pending
      "confirm CI runs green" task) and confirm the workflow is green
