# Python Template

Template repository for KotterAI

## 🚀 Features

### Code Quality

- black
- isort
- flake8
- editorconfig

### Github Actions

- [release-drafter](https://github.com/release-drafter/release-drafter)
- Check code quality when PR (`black`, `isort`, `flake8`)

### Other

- Commit template
- Issue, PR Template
- Add dummy test code
- Auto-close stale issue

## 📄 Guideline

### 1. Set commit template

Please follow the instruction in `.gitmessage` when commit.

```bash
make set-git
```

### 2. Install dependencies

Will install `requirements.txt`

```bash
make set-dev
```

### 3. Writes your own code! ✏️

Don't forget to update the `README`!

## ⬆️ Contributing

### 1. Test

```bash
make test
```

### 2. Execute code formatting & Check lint

```bash
make style
```
