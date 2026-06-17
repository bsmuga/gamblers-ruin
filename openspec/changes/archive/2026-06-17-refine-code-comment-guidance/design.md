## Context

This is a documentation-only change to `.claude/CLAUDE.md`. The existing comment bullet
forbids AI-specific and change-narrating comments but gives no positive guidance, so it
reads as purely prohibitive. The repository philosophy already values readable interfaces
and minimal ceremony, so the natural complement is a positive rule favoring concise
function-level documentation.

## Goals / Non-Goals

**Goals:**
- State a single, actionable rule: document a function's main idea; avoid inline body
  commentary.
- Preserve the existing prohibition on AI-specific and change-narrating comments.

**Non-Goals:**
- No changes to source code, build, tests, or any `lib/`/`bin/`/`test/` comments.
- No new linting or automated enforcement.

## Decisions

- Rewrite the single Conventions bullet in place rather than adding a new bullet, keeping
  the section terse. The positive rule (function-level docs) and the negative rule
  (no inline narration, no AI/agent-facing comments) live in one coherent statement.
- Express docs as `.mli`/function-level intent, consistent with the project's "interface
  is the specification" philosophy. Alternative considered: a separate style guide file —
  rejected as unnecessary ceremony for a one-bullet refinement.

## Risks / Trade-offs

- [Guidance could be read as "never comment inside a function"] → Keep the *why*-not-*what*
  carve-out so genuinely non-obvious rationale is still allowed.
