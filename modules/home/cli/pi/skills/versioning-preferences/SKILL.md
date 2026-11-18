---
name: versioning-preferences
description: Use when editing files or working with repository status, history, changes, or commits.
---

# Versioning preferences

- Prefer `jj` over `git` in Jujutsu repositories, including colocated repositories.
- After editing files in a Jujutsu repository, run `jj st` so new files are picked up.
- Use `jj diff` and `jj log` to inspect changes and history.
- Initialize new repositories with `jj`. Do not convert an existing Git repository without asking.

## Commits

- Follow Conventional Commits: `<type>(<optional scope>): <description>`, using types such as `feat`, `fix`, `chore`, `docs`, `refactor`, and `test`.
- Each commit must contain related changes and leave the project in a working state. Run relevant checks before committing; report any that could not be run.
- When asked to commit, inspect the working copy first and avoid including unrelated changes. Use `jj commit` in Jujutsu repositories.
