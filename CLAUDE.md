# CLAUDE.md

Setup, the Makefile command list and the checklist for new repositories are in the [README](README.md).

## 1. Rules for this repository and the repositories created from it

### Layout

```
python_template/   # the package — rename it in a new repository (README checklist)
tests/             # module tests mirror the package path; tests that run the whole program sit directly under tests/
```

- Files, modules, functions and variables are snake_case, classes are PascalCase, and public functions have type hints. Ruff rules are in `pyproject.toml`.

### Commands

```bash
make setup    # commit template, dependencies (default + quality + test groups), pre-commit hooks (install uv yourself)
make test     # all tests except integration tests, with coverage
uv run --frozen --group test pytest tests/test_sample.py -k add   # a subset
make quality  # the same checks as CI; changes no files
```

- Pass `make quality` and `make test` before committing. `make style` **rewrites** files with ruff.
- pre-commit runs ruff (`check --fix`, then `format`, the version pinned in `uv.lock`) on the staged Python files only, and `make check-lock` only when `pyproject.toml` or `uv.lock` changes. Do not hook `make style`: it rewrites files outside the commit. Keep `force-exclude = true` in the ruff settings — the hooks pass paths explicitly, and without it ruff ignores `exclude`.
- `uv sync --frozen` is an exact sync and removes the quality and test groups (pytest, ruff, pre-commit). `make setup` brings them back.
- `make clean` also **empties the global uv cache** (`uv cache clean`) and **force-deletes** local branches whose upstream is gone.
- Run `make setup` in the main checkout, not in a temporary `git worktree`: worktrees share `.git/hooks`, so `pre-commit install` there points the hook at the worktree's `.venv`, and commits in the main checkout fail once the worktree is removed.

### Tests

- pytest settings are in `pyproject.toml` (`[tool.pytest]`; integration tests are deselected by default). Mark tests that call real external dependencies with `@pytest.mark.integration` and run them with `make test-integration`. CI runs them on manual runs and on same-repo PRs into the default branch (`.github/workflows/test.yml`); PRs from forks get no secrets.
- Keep a fixture in the test file that uses it. Only fixtures shared by several files go in `tests/conftest.py`.
- Mock external calls at the transport (HTTP) boundary instead of replacing the client library with a mock: a mocked library hides bugs in what the library really does.
- Name tests `test_<behavior>`, and cover new branches and error paths.

### CI

- Write workflows so they also run on self-hosted runners: no `sudo` or global paths such as `/usr/local/bin` (unpack into `RUNNER_TEMP` and expose it with `GITHUB_PATH`), no hard-coded architecture (detect it with `uname -s`/`uname -m`), skip downloads of tools that are already installed, support both `sha256sum` and `shasum -a 256`, and use no fixed container names or host ports.
- Never attach a self-hosted runner to a public repository: a PR from a fork runs its code on that machine. Do not use `pull_request_target` to give fork PRs secrets.
- Workflows declare `permissions: contents: read` unless a job needs more.

### Commits and PRs

- Each repository writes its commit subject, branch and merge conventions here. Where none are written, follow the recent convention in `git log`.
- A PR description states what changed and why, the verification commands actually run and their results, and the follow-ups left out.

## 2. Rules for the template repository only (delete this section in derived repositories)

- This repository is a template for Python projects. Start a new project from it, then delete this section and write that project's rules under "Commits and PRs".
- It is public. Commits, branches, PRs, code, comments and docs contain no ticket IDs, organization or product names, internal URLs, or paths on the author's machine.
- Commit subjects are imperative English, capitalized, with no trailing period and no ticket ID. Branches are `<type>/<slug>`. PRs are squash-merged, so the PR title becomes the commit subject on `main` — title PRs the same way. PR descriptions use `## Summary` and `## Test plan`.
