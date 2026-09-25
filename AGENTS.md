# Mac Dev Bootstrap — Project Directives

A single zsh script that sets up a new Mac for development: Xcode Command Line Tools,
Oh My Zsh, Homebrew, the packages in `Brewfile`, nvm with Node LTS, and fzf shell
integration.

## Hard constraints

- **Stay idempotent.** The README promises the script is safe to run repeatedly. Every
  step must check before acting (`xcode-select -p`, `~/.oh-my-zsh` exists, `command -v
  brew`, `grep -q 'NVM_DIR' ~/.zshrc`). New steps follow the same pattern.
- **Never clobber user shell config.** Oh My Zsh is installed with
  `RUNZSH=no CHSH=no KEEP_ZSHRC=yes`; rc files are only appended to, and only when the
  block is not already present.
- **Packages belong in `Brewfile`,** not in ad-hoc `brew install` lines in the script.
- The script runs with `set -e`; any failing command aborts the run.

## Layout

```
bootstrap.sh   the whole setup, in order (see below)
Brewfile       Homebrew formulae ("CLI Tools") and casks (GUI, API testing, productivity)
Readme.md      user-facing usage notes
```

`bootstrap.sh` steps, in order:

1. Re-exec under zsh if not already running in zsh.
2. Xcode Command Line Tools: `xcode-select --install`, then poll every 5s until installed.
3. Oh My Zsh via the official install script.
4. Homebrew via the official install script; appends `brew shellenv` to `~/.zprofile`.
5. `brew update`, then `brew bundle --file ./Brewfile`.
6. nvm: creates `~/.nvm`, appends an NVM block to `~/.zshrc` if missing, sources `~/.zshrc`.
7. `nvm install --lts` and `nvm use --lts` if `nvm` is available.
8. Runs fzf's `install --all` if fzf is installed.

## Run and verify

```bash
chmod +x bootstrap.sh
./bootstrap.sh        # full setup; installs software, modifies ~/.zprofile and ~/.zshrc
brew bundle           # install or update Brewfile packages later (from the repo dir)
```

There are no tests. For changes, a safe check that installs nothing:

```bash
zsh -n bootstrap.sh   # syntax check
```

Do not run `bootstrap.sh` to test a change on a working machine unless the user asks; it
installs software and edits shell rc files.

## Conventions

- zsh script, `#!/usr/bin/env zsh`. Sections separated by `#####` banner comments with a
  title. Each step prints a status line before acting and a "already installed" line when
  skipped.
- Brewfile groups entries under comment headings; add new entries to the matching group.
- Git history is a single `first commit`, so there is no established message style yet.
  Use short imperative summaries.

## Gotchas

- **Apple Silicon only.** Homebrew and nvm paths are hardcoded to `/opt/homebrew`
  (`brew shellenv` line, the nvm block in `~/.zshrc`). On an Intel Mac Homebrew lives in
  `/usr/local` and those lines will not work.
- **Must run from the repo directory.** `brew bundle --file ./Brewfile` uses a relative
  path.
- `xcode-select --install` opens a GUI dialog; the script waits until the user completes it.
- `source ~/.zshrc` inside the script runs the user's whole rc file (including Oh My Zsh)
  under `set -e`, so an error in `~/.zshrc` aborts the bootstrap.
- `echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile` is not guarded, but only
  runs when brew was missing, so it is appended once in practice.
- fzf `install --all` edits shell rc files itself on every run.
- `Readme.md` still contains a pasted chat-assistant closing section ("If you want, I can
  also show you 3 major upgrades...") and some unformatted code blocks. It is not real
  documentation and can be cleaned up.

## Current state and next steps

- One commit (`first commit`, March 2026). The script and Brewfile are the whole project.
- Not implemented, mentioned only in the stray README section: VS Code extension install,
  Git + SSH setup, macOS defaults. Whether the user wants these is unknown.
- Intel Mac support is not handled (see Gotchas).
