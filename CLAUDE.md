# Mac Dev Bootstrap

Project directives live in **[AGENTS.md](./AGENTS.md)**. Read it before working in this
repo. The short version:

- `bootstrap.sh` (zsh, `set -e`) sets up Xcode CLT, Oh My Zsh, Homebrew, the `Brewfile`
  packages, nvm + Node LTS, and fzf.
- **Keep it idempotent.** Every step checks before acting; rc files are only appended to
  when the block is missing. Never overwrite user shell config.
- **Packages go in `Brewfile`,** not in `brew install` lines in the script.
- Paths assume Apple Silicon (`/opt/homebrew`), and the script must run from the repo dir.
- Verify with `zsh -n bootstrap.sh`. Do not run the script itself unless asked; it
  installs software and edits `~/.zprofile` and `~/.zshrc`.

@AGENTS.md
