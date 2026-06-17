## Why

The current `.claude/CLAUDE.md` guidance forbids AI-specific and change-narrating
comments, but it does not give positive direction on what documentation *is* wanted.
Contributors are left unsure whether to document functions at all, leading to either
noisy inline commentary or undocumented code.

## What Changes

- Refine the comment guidance in `.claude/CLAUDE.md` so it states a single, clear rule:
  prefer a short doc comment describing the *main idea* of a function, and avoid inline
  comments inside function bodies.
- Keep the existing prohibition on AI-specific and change-narrating comments, folding it
  into the refined guidance rather than dropping it.
- Make the directive concrete: function-level docs explain purpose/intent; inline,
  step-by-step narration of the code is omitted.

## Capabilities

### New Capabilities
<!-- None. -->

### Modified Capabilities
- `contribution-guidelines`: the comment-related requirement changes from "no
  AI-specific inline commentary" to a positive rule favoring concise function-level
  documentation while forbidding inline body commentary.

## Impact

- `.claude/CLAUDE.md` — the `## Conventions` section comment bullet is rewritten.
- `openspec/specs/contribution-guidelines/spec.md` — requirement updated via delta.
- No source code, build, or runtime behavior is affected.
