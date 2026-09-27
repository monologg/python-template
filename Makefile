clean: clean-pyc clean-test clean-uv clean-lint-and-formatter clean-branches
quality: set-style-dep check-quality
style: set-style-dep set-style
setup: set-git set-dev set-style-dep set-test-dep set-precommit
test: set-test-dep set-test
test-integration: set-test-dep set-test-integration


##### basic #####
set-git:
	git config --local commit.template .gitmessage

set-style-dep:
	uv sync --only-group quality --frozen --no-install-project --inexact

# --group (not --only-group) so `make test` also installs the default dependencies and works on a fresh checkout
set-test-dep:
	uv sync --group test --frozen --no-install-project --inexact

set-precommit:
	uv run --frozen --only-group quality pre-commit install

set-dev:
	uv sync --frozen --no-install-project

set-test:
	uv run --frozen --group test pytest --cov --cov-report=term-missing tests/

set-test-integration:
	uv run --frozen --group test pytest -m integration tests/; \
	status=$$?; \
	if [ $$status -eq 5 ]; then echo "No integration tests collected"; exit 0; else exit $$status; fi

set-style:
	uv run --frozen --only-group quality ruff check --fix .
	uv run --frozen --only-group quality ruff format .

check-quality:
	uv run --frozen --only-group quality ruff check .
	uv run --frozen --only-group quality ruff format --check .

check-lock:
	uv lock --check

#####  clean  #####
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -f .coverage
	rm -f .coverage.*
	rm -rf .pytest_cache
	rm -rf .mypy_cache

clean-lint-and-formatter:
	rm -rf .ruff_cache

clean-uv:
	uv cache clean
	uv cache prune

clean-branches:
	git fetch --prune origin
	git branch -vv | grep ': gone]' | awk '{print $$1}' | xargs -r git branch -D
