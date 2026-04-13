# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles and configuration for David Vernet (`void@manifault.com`). This repo is symlinked/sourced into the home directory via `bin/bootstrap.sh`.

## Repository Structure

- `bash/` — Shell configuration, sourced via `main.bash` in order: `environ.bash` → `fzf.bash` → `init.bash` → `mutt.bash`
- `tmux/` — tmux config with C-t prefix (not C-b), vim-style navigation, 256-color
- `mutt/` — Neomutt config (muttrc, msmtprc, GPG, colors, sidebar, keybindings)
- `accounts/` — Per-account email configs (account.conf + muttrc.rc per account)
- `bin/` — Helper scripts: `bootstrap.sh`, `mutt_oauth.sh`, `add_mutt_account.sh`, `oauth2.py`
- `secrets/` — GPG-encrypted credentials (API keys, OAuth tokens). Never commit plaintext secrets.
- `gitconfig` — Shared git config (symlinked to `~/.gitconfig` by bootstrap)

## Key Environment Variables

Defined in `bash/environ.bash`, used throughout:
- `PERSONAL_CONFIGS_DIR` — path to this repo (`~/.personal_configs`)
- `PERSONAL_BASH_DIR`, `PERSONAL_TMUX_DIR`, `PERSONAL_MUTT_DIR` — subdirectory paths
- `UPSTREAM_DIR` — `~/upstream`, where kernel trees and dev projects live

## Context: Linux Kernel Development

The bash config is heavily oriented around Linux kernel and sched_ext development:
- LLVM/clang toolchain at `/opt/clang/latest/bin`
- `lmake` / `kmake` — kernel build wrappers using clang/LLVM
- `vng*` functions — virtme-ng wrappers for building/running kernels in VMs
- `bpf*` / `scx*` functions — BPF and sched_ext patch/email workflows
- `msetup` / `mbld` — meson build wrappers for scx schedulers
- Cross-compilation support for aarch64 and s390

## Bootstrap a New Machine

```bash
./bin/bootstrap.sh
```

Idempotent — safe to re-run. It:
- Appends source lines to `~/.bashrc` (skips if already present)
- Symlinks `~/.gitconfig`, `~/.tmux.conf`, `~/.muttrc`, `~/.msmtprc`, `~/.mailcap` (backs up existing files)
- Creates mutt cache directories (`~/.mutt/hcache`, `~/.mutt/mcache`)

## GPG

Secrets are encrypted with GPG key `F5504C7B7B8107B40EF9E97AA1148BB3207BCC33`. The `unlock_pgp` and `set_anth_key` functions in `init.bash` decrypt secrets at runtime. Never store plaintext secrets in this repo.
