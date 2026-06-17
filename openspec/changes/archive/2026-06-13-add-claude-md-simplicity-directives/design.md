## Context

`.claude/CLAUDE.md` already has a `## Conventions` section listing authoring rules (naming,
`.mli` sync, warning-clean builds). This change adds two more conventions. It is a
documentation edit with no code impact, so the design is deliberately light.

## Goals / Non-Goals

**Goals:**
- Capture a simplicity directive and an anti-AI-commentary directive as durable project
  conventions.
- Keep the wording concrete and testable so contributors can self-check.

**Non-Goals:**
- Reformatting or restructuring the rest of `CLAUDE.md`.
- Adding tooling or lint rules to enforce the directives (out of scope for a docs change).

## Decisions

- **Extend the existing `## Conventions` bullet list** rather than adding a new section.
  The two directives are peers of the conventions already there, so they belong in the
  same list and keep the file flat and scannable. Alternative considered: a dedicated
  "Style philosophy" section — rejected as heavier than the content warrants.
- **Phrase the comment rule as "why, not what."** This is a widely understood maxim and
  gives a single concrete test, instead of enumerating banned comment patterns which would
  be long and incomplete.

## Risks / Trade-offs

- [Directives are advisory, not enforced] → Acceptable for a small early-stage repo;
  enforcement tooling can be proposed later if drift appears.
- [Wording could be read as "no comments at all"] → Mitigated by explicitly allowing
  comments that explain non-obvious rationale.
