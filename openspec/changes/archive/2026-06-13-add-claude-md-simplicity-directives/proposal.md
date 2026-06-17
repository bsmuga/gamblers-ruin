## Why

The project's `CLAUDE.md` guides how code is written here, but it says nothing about
keeping implementations simple or about avoiding AI-generated inline commentary. Without
explicit directives, contributions (especially AI-assisted ones) tend to accumulate
needless abstraction and explanatory comments that narrate the obvious or address an AI
audience rather than future maintainers.

## What Changes

- Add a directive to the `## Conventions` section of `.claude/CLAUDE.md` favoring simple,
  direct implementations over speculative abstraction (YAGNI; solve the problem in front
  of you).
- Add a directive forbidding AI-specific inline commentary — comments that narrate what
  the code obviously does, explain the change rather than the code, or address an AI/agent
  reader. Comments should explain *why*, not *what*, and only when non-obvious.

## Capabilities

### New Capabilities
- `contribution-guidelines`: Project authoring conventions captured in `.claude/CLAUDE.md`,
  covering simplicity expectations and rules against AI-specific inline commentary.

### Modified Capabilities
<!-- None: no existing specs in openspec/specs/. -->

## Impact

- Affected files: `.claude/CLAUDE.md` (documentation only).
- No source code, build, API, or dependency changes.
