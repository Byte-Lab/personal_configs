# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles and configuration for David Vernet (`void@manifault.com`). This repo is symlinked/sourced into the home directory via `bin/bootstrap.sh`.

## Repository Structure

- `bash/` — Shell configuration, sourced via `main.bash` in order: `environ.bash` → `fzf.bash` → `init.bash` → `mutt.bash`
- `tmux/` — tmux config with C-t prefix (not C-b), vim-style navigation, 256-color
- `mutt/` — Neomutt config (muttrc, msmtprc, GPG, colors, sidebar, keybindings)
- `accounts/` — Per-account email configs (account.conf + muttrc.rc per account)
- `gpg/` — GPG agent config (gpg-agent.conf: 8h cache TTL, pinentry-tty, SSH support)
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

For machines that don't need email/secrets (e.g. work machines), use sparse-checkout to avoid materializing those files on disk:

```bash
# Sparse clone (default: shell, git, tmux, gpg — no secrets on disk)
curl -sL <raw-url>/bin/checkout-sparse.sh | bash
# Full clone with everything
./bin/checkout-sparse.sh all
```

Then run the bootstrap script with matching modules:

```bash
./bin/bootstrap.sh                    # everything
./bin/bootstrap.sh shell git tmux     # skip mutt
```

Idempotent — safe to re-run. Modules: `shell`, `git`, `tmux`, `gpg`, `mutt`. No args = all modules. It:
- `shell` — appends source lines to `~/.bashrc` (skips if already present)
- `git` — symlinks `~/.gitconfig`
- `tmux` — symlinks `~/.tmux.conf`
- `gpg` — symlinks `~/.gnupg/gpg-agent.conf` (creates `~/.gnupg` with 700 perms if needed)
- `mutt` — symlinks `~/.muttrc`, `~/.msmtprc`, `~/.mailcap`; creates cache directories

## Email Account System

Accounts are config-driven under `accounts/<name>/`:
- `account.conf` — sourceable shell vars (EMAIL, CLIENT_ID, REALNAME, IMAP/SMTP URLs)
- `muttrc.rc` — mutt-specific settings (from, imap_user, imap_authenticators)

All OAuth2 accounts use a single `bin/mutt_oauth.sh <account>` script which reads `account.conf`, decrypts secrets from `secrets/oauth_secret_<account>.gpg` and `secrets/oauth_<account>_refresh_token.gpg`, and returns an access token via `oauth2.py`.

Key commands:
- `pickmutt` — fzf picker that unlocks GPG then launches neomutt for the selected account
- `bin/add_mutt_account.sh <name>` — interactive wizard to onboard a new account (prompts for creds, runs OAuth2 dance, encrypts secrets, creates config files, appends msmtp block)

SMTP is handled by msmtp (`mutt/msmtprc`), with one account block per email that calls the same `mutt_oauth.sh`.

## GPG

Secrets are encrypted with GPG key `F5504C7B7B8107B40EF9E97AA1148BB3207BCC33`. The `unlock_pgp` and `set_anth_key` functions in `init.bash` decrypt secrets at runtime. `pickmutt` triggers a non-batch GPG decrypt before launching neomutt to ensure the key is unlocked. Never store plaintext secrets in this repo.
