## Context

A multi-agent code review of the repository produced a set of small, verified
findings (each cross-checked by independent skeptics against the project's
minimalism philosophy in `.claude/CLAUDE.md`). This change applies the confirmed,
in-scope subset. The codebase is small and the changes are local; this design
exists mainly to record the non-obvious decisions (which comments stay vs. go, the
tolerance choice for the new cross-check, and how the generated opam file is
updated) so implementation is unambiguous.

## Goals / Non-Goals

**Goals:**

- Remove genuinely dead code and a brittle magic-number coupling without changing
  any computed result or public interface.
- Remove only the inline comments that restate the code; preserve the `.mli`
  specs, the `engine.ml` derivation header, and the `analytic.ml` rationale.
- Make "the three routes must agree" actually verified for expected durations,
  not only ruin probabilities.
- Make the declared OCaml floor and the version CI builds consistent.
- Keep the build warning-clean and `dune test` green throughout.

**Non-Goals:**

- No change to the engine's public `floatarray` return type (reviewed; the
  result-assembly loop is intrinsic to splicing the absorbing boundaries and
  would persist under any element type).
- No `.claude/` tooling changes (opsx command/skill duplication, agent-definition
  example blocks) — deferred by decision.
- No new behavior for `Engine`, `Analytic`, or `Simulate`; results are unchanged.

## Decisions

**Pass `q`/`p` directly instead of copying into `sub`/`sup`.**
`solve_tridiagonal` only ever reads `sub`/`sup` (it writes solely to its own
`cp`/`dp`/`x`), and `q`/`p` are freshly allocated locals (`Array.map` / `Array.init`).
The copies guard an aliasing hazard that cannot occur, and `diag` is already passed
without a copy — so removing them makes the off-diagonals consistent with `diag`.
_Alternative considered:_ keep the copies "for safety" — rejected as exactly the
speculative defensiveness the philosophy forbids; correctness is guaranteed by the
existing tests.

**Delete two WHAT-comments; keep the WHY-comments.**
Remove `simulate.ml`'s `(* [+1] with probability [win pos], else [-1]. *)` (a literal
transliteration of the body) and `engine.ml`'s `(* fold the known boundary values
into the right-hand side *)` (narration already covered by the header derivation).
Explicitly keep: every `.mli` doc comment (the project's primary spec), the
`engine.ml` first-step-analysis header, the `analytic.ml` constant-`p` rationale,
and the `bin/main.ml` `render_trajectory` role comment. The distinction is WHAT
(delete) vs. WHY (keep).

**Derive the sparkline scale from the glyph array.**
Replace the hard-coded `8.0` in `bin/main.ml` with `Array.length blocks - 1` so the
index range stays correct if a glyph is added or removed. Behavior-preserving.

**README: remove the `## Status` section and duplicated counts.**
The routes table already states the design and implemented modules; the Status
prose duplicates it and hard-codes "12 cases"/"green" in two places that drift.
This stays consistent with `repository-scaffold`'s documentation requirement, which
forbids describing modules as `TODO` (removal introduces no such description) and
requires the README explain the problem/design/build (all retained).

**New durations cross-check uses a relative tolerance.**
Add a QCheck property mirroring `prop_engine_matches_analytic` that compares
`Engine.expected_durations.(i)` with `Analytic.expected_duration ~start:i` over the
existing `gen_walk`, covering both `p = 1/2` and `p <> 1/2`. Durations grow large
at extreme `p` over `n` up to 30, so a fixed `1e-6` absolute bound would flake; use
a relative bound (`abs diff <= 1e-6 *. (1. +. abs expected)`).

**Convert `test_unfair_example` to a known-answer anchor.**
Replace its Analytic-derived expected values with literals computed from
`r = q/p = 1.5`, `N = 5` (`h_i = (r^N - r^i)/(r^N - 1)`), mirroring
`test_fair_special`. This removes the duplication with the property test while
keeping a deterministic unfair-case check that is independent of the `Analytic`
module (so a bug shared by engine and analytic would still be caught).
_Alternative considered:_ delete it outright — acceptable, but loses the
independent anchor for the unfair case.

**Justify the Monte-Carlo magic numbers with one WHY comment.**
Keep `trials:20000` and `< 0.03` (≈8σ on the fixed seed) and add a single
rationale comment — permitted by the comment rule because it explains a
non-obvious tolerance choice, not the code.

**Lower the OCaml floor to 5.1 and regenerate the opam file.**
Set `(ocaml (>= 5.1))` in `dune-project` so the declared minimum equals what CI
builds, then regenerate `gamblers_ruin.opam` via `dune build` (it is generated —
never hand-edited). _Alternative considered:_ a `4.14 + 5.1` CI matrix to keep the
4.14 floor honest — not chosen; 4.14 support is not a goal and CI already builds
only 5.1.

## Risks / Trade-offs

- **Removing the copies introduces an aliasing bug** → verified the solver never
  mutates its inputs; `dune test` (engine-vs-analytic cross-check) must pass after
  the change.
- **The new durations property flakes** → mitigated by the relative tolerance and
  by reusing the existing seeded generator range.
- **Hand-edited literals in the converted test are wrong** → they are derived from
  the closed form for `r = 1.5, N = 5` and independently re-checked by the property
  test; a mismatch fails CI immediately.
- **Editing the generated opam by hand** → avoided; the file is regenerated by
  `dune build`, and CI would catch drift.
- **Lowering the floor narrows declared support** → accepted; the previous 4.14
  claim was never built, so tested support is unchanged in practice.
