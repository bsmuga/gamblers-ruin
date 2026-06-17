## 1. Confirm the agent roster

- [x] 1.1 Verify `.claude/agents/` contains exactly the five definitions
  (`math-concept-docs`, `ocaml-implementer`, `probability-math-reviewer`,
  `senior-code-reviewer`, `test-author`) and that each file's frontmatter `name` matches
  its filename
- [x] 1.2 Confirm `ocaml-implementer.md` declares `name: "ocaml-implementer"` and
  `memory: project`

## 2. Make memory runtime-only

- [x] 2.1 Add `.claude/agent-memory/` to `.gitignore`
- [x] 2.2 Verify `git check-ignore .claude/agent-memory/ocaml-implementer/` reports the
  path as ignored
- [x] 2.3 Confirm every agent definition still declares `memory: project`

## 3. Remove empty placeholder directories

- [x] 3.1 Delete the empty `.claude/agent-memory/*` directories from the working tree
- [x] 3.2 Verify no empty `.claude/agent-memory/<name>/` directory remains on disk

## 4. Validate

- [x] 4.1 Run `openspec validate tidy-agent-config --strict` and resolve any issues
- [x] 4.2 Confirm `git status` shows only the intended changes (`.gitignore`,
  `.claude/agents/`) and no empty-directory noise
