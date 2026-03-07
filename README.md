# winarch





## Git hooks

This project uses [git_hooks](https://pub.dev/packages/git_hooks) for pre-commit and commit-msg checks (format, fix, analyze, and conventional commit messages).

**One-time setup (after clone):** From the project root, run:

```bash
dart run tool/install_git_hooks.dart
```

Then every `git commit` (from IDE, VS Code, or CLI) will:

- **Pre-commit:** Format code, run `dart fix --apply`, format again, then run `dart analyze --fatal-warnings`. The commit is blocked if the analyzer reports errors or warnings.
- **Commit-msg:** Enforce [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): subject`, e.g. `feat(auth): add login`. Header must be at most 100 characters. Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`.


## Conventional Commit Type Reference

Below are the standard [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/) types in this project, examples, and when to use them:

| Type      | When to Use                                                                 | Example                                                       |
|-----------|----------------------------------------------------------------------------|---------------------------------------------------------------|
| **feat**      | New feature for user or product                                           | `feat(auth): add OAuth2 login support`                        |
| **fix**       | Bug fix affecting user-visible functionality or behavior                 | `fix(login): correct password reset validation`               |
| **docs**      | Add/update project documentation (README, docs, comments)                | `docs(README): add contribution guidelines`                   |
| **style**     | Code style changes (formatting, white-space, semi-colons); **no logic** | `style(login): format code and fix lint issues`               |
| **refactor**  | Code restructuring (rename, restructure, move); **no behavior change**  | `refactor(user): extract user validation methods`             |
| **perf**      | Code change that improves performance                                   | `perf(image): optimize image loading for faster startup`      |
| **test**      | Add or update tests (unit, integration, etc.)                           | `test(api): add tests for error handling in login flow`       |
| **build**     | Changes affecting build process (tools, dependencies, scripts)           | `build: update build_runner from 2.4.0 to 2.4.13`             |
| **ci**        | CI configuration changes (GitHub Actions, GitLab CI, scripts)           | `ci: add test coverage badge to workflow`                     |
| **chore**     | Maintenance changes (dep updates, tooling), not user facing             | `chore: update .gitignore for macOS files`                    |

**Guidelines:**
- Always use the conventional: `type(scope): subject`
    - e.g. `feat(ui): add dark mode toggle`
- Keep the header ≤ 100 chars.
- Use the correct type for the change; see above for guidance.

