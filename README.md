# Python Template

Template repository for Python projects, built on [uv](https://docs.astral.sh/uv/) and Python 3.13. The code layout and working rules (commands, tests, CI, commits) for people and coding agents are in [CLAUDE.md](CLAUDE.md).

## Features

- **uv**: dependencies in `pyproject.toml` (`test` and `quality` groups), pinned in `uv.lock`
- **ruff** for lint and format (line length 119, rules in `pyproject.toml`)
- **pre-commit**: ruff on the staged Python files only, and a `uv.lock` check when `pyproject.toml` or `uv.lock` changes
- **pytest** with coverage; tests marked `integration` are skipped by default
- **GitHub Actions**: `uv.lock` check and lint, tests (integration tests on manual runs and on same-repo PRs into the default branch)
- Commit message template, PR and issue templates, `.editorconfig`

## Setup

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) first — `make setup` does not install it.

```bash
make setup   # commit template, dependencies (default + quality + test groups), pre-commit hooks
make test
```

Running `uv sync --frozen` on its own is an exact sync and removes the dev tools (pytest, ruff, pre-commit). Run `make setup` again to get them back.

## Makefile commands

| Command                 | What it does                                                                                                                       |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `make setup`            | Development setup: commit template, dependencies, pre-commit hooks                                                                 |
| `make test`             | All tests except integration tests, with coverage. Installs the default and test dependencies itself                              |
| `make test-integration` | Only the tests marked `@pytest.mark.integration`                                                                                   |
| `make quality`          | Lint and format checks only (ruff check + format --check); what CI runs                                                           |
| `make style`            | Fixes the whole repository (ruff check --fix + format)                                                                             |
| `make check-lock`       | Checks that `uv.lock` matches `pyproject.toml`                                                                                     |
| `make clean`            | Removes caches and coverage files, and also **empties the global uv cache** and **force-deletes** local branches whose upstream is gone |

## After creating a repository from this template

1. Rename the package: the `python_template/` directory, `[tool.coverage.run] source` in `pyproject.toml`, and the imports in `tests/`.
2. `pyproject.toml`: set the project name and description, add dependencies, then run `uv lock`.
3. Replace the sample code (`python_template/sample.py`) and its test (`tests/test_sample.py`).
4. `CLAUDE.md`: delete section 2 ("Rules for the template repository only") and write the new repository's commit conventions under "Commits and PRs". Adjust `.gitmessage` to match (for example, a ticket prefix).
5. Rewrite this README.

To ship a CLI or a library, add a `[build-system]` and `[project.scripts]` to `pyproject.toml`.
