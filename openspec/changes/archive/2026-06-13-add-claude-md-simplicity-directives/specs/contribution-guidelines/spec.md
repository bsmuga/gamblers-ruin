## ADDED Requirements

### Requirement: Implementations favor simplicity

`.claude/CLAUDE.md` SHALL instruct contributors to prefer the simplest implementation
that solves the problem at hand, avoiding speculative abstraction, premature
generalization, and unused configurability (YAGNI).

#### Scenario: Simplicity directive present in conventions

- **WHEN** a contributor reads the `## Conventions` section of `.claude/CLAUDE.md`
- **THEN** it states that code MUST prefer the simplest working solution and avoid
  abstraction not justified by a present requirement

### Requirement: No AI-specific inline commentary

`.claude/CLAUDE.md` SHALL instruct contributors to omit inline comments that narrate what
the code obviously does, describe the change rather than the code, or address an AI/agent
reader. Comments SHALL explain *why* when the reason is non-obvious, not *what*.

#### Scenario: Anti-AI-commentary directive present in conventions

- **WHEN** a contributor reads the `## Conventions` section of `.claude/CLAUDE.md`
- **THEN** it forbids AI-specific or change-narrating inline comments and states that
  comments should explain non-obvious rationale only

#### Scenario: Directive is concrete enough to act on

- **WHEN** a contributor is deciding whether to add an inline comment
- **THEN** the directive gives a clear test (explain *why*, not *what*; drop comments that
  restate the code or speak to an agent) they can apply without further interpretation
