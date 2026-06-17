## MODIFIED Requirements

### Requirement: No AI-specific inline commentary

`.claude/CLAUDE.md` SHALL instruct contributors to document a function with a short doc
comment stating its main idea, and to omit inline comments inside function bodies. It
SHALL continue to forbid comments that narrate what the code obviously does, describe the
change rather than the code, or address an AI/agent reader. When a comment is warranted,
it SHALL explain *why* (non-obvious rationale), not *what*.

#### Scenario: Function-level documentation directive present in conventions

- **WHEN** a contributor reads the `## Conventions` section of `.claude/CLAUDE.md`
- **THEN** it directs them to give a function a concise doc comment about its main idea
  and to avoid step-by-step inline commentary inside the body

#### Scenario: Anti-AI-commentary directive present in conventions

- **WHEN** a contributor reads the `## Conventions` section of `.claude/CLAUDE.md`
- **THEN** it forbids AI-specific or change-narrating inline comments and states that
  comments should explain non-obvious rationale only

#### Scenario: Directive is concrete enough to act on

- **WHEN** a contributor is deciding whether and how to comment
- **THEN** the directive gives a clear test (document the main idea at the function level;
  drop inline comments that restate the code, narrate the change, or speak to an agent;
  keep only comments explaining *why*) they can apply without further interpretation
