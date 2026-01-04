#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Sources in repo
NVIM_SRC="$DOTFILES_DIR/nvim"
TMUX_SRC="$DOTFILES_DIR/tmux/.tmux.conf"
ZSH_SRC="$DOTFILES_DIR/zsh/.zshrc"
GHOSTTY_SRC="$DOTFILES_DIR/ghostty"

# Targets on system
NVIM_DST="$HOME/.config/nvim"
TMUX_DST="$HOME/.tmux.conf"
ZSH_DST="$HOME/.zshrc"
GHOSTTY_DST="$HOME/.config/ghostty"

# Fonts you expect
EXPECTED_FONTS=("JetBrainsMono Nerd Font" "JetBrainsMono Nerd Font Mono" "JetBrainsMonoNerdFont")

info() { printf "\033[1;34m[i]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[x]\033[0m %s\n" "$*"; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Missing required command: $1"; exit 1; }
}

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

timestamp() { date +%Y%m%d%H%M%S; }

backup_if_needed() {
  local target="$1"
  if [[ -L "$target" ]]; then
    return 0
  fi
  if [[ -e "$target" ]]; then
    local backup="${target}.bak.$(timestamp)"
    warn "Backing up existing $target -> $backup"
    mv "$target" "$backup"
  fi
}

link() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    warn "Source missing, skipping: $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local cur
    cur="$(readlink "$dest")"
    if [[ "$cur" == "$src" ]]; then
      info "Symlink already correct: $dest -> $src"
      return 0
    fi
    warn "Replacing symlink: $dest (was -> $cur)"
    rm "$dest"
  else
    backup_if_needed "$dest"
    [[ -e "$dest" ]] && rm -rf "$dest"
  fi

  ln -s "$src" "$dest"
  info "Linked: $dest -> $src"
}

install_packages() {
  if is_linux && command -v apt >/dev/null 2>&1; then
    info "Installing packages via apt"
    sudo apt update
    # Keep this minimal; add more as you need
    sudo apt install -y git zsh tmux neovim
  elif is_macos; then
    if command -v brew >/dev/null 2>&1; then
      info "Installing packages via Homebrew (best-effort)"
      brew install git zsh tmux neovim || true
    else
      warn "Homebrew not found; skipping package installs on macOS."
    fi
  else
    warn "No supported package manager found; skipping package installs."
  fi
}

install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    info "TPM already installed: $tpm_dir"
    return 0
  fi
  info "Installing TPM..."
  mkdir -p "$(dirname "$tpm_dir")"
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
}

warn_if_font_missing() {
  # Best-effort checks:
  # - Linux: fc-list
  # - macOS: system_profiler (slow) or fc-list if installed
  if command -v fc-list >/dev/null 2>&1; then
    local found="no"
    for f in "${EXPECTED_FONTS[@]}"; do
      if fc-list | grep -qi "$f"; then
        found="yes"
        break
      fi
    done
    if [[ "$found" == "no" ]]; then
      warn "Nerd font not detected via fc-list. Icons may look wrong in nvim/tmux."
      warn "Expected something like: JetBrainsMono Nerd Font."
    else
      info "Font check: Nerd font detected."
    fi
  else
    warn "fc-list not available, skipping font check."
    warn "If icons look wrong, install JetBrainsMono Nerd Font in this OS."
  fi
}

main() {
  need_cmd uname
  need_cmd git

  [[ -d "$DOTFILES_DIR" ]] || { err "Dotfiles directory not found: $DOTFILES_DIR"; exit 1; }

  install_packages

  # Symlinks
  link "$NVIM_SRC" "$NVIM_DST"
  link "$TMUX_SRC" "$TMUX_DST"
  link "$ZSH_SRC" "$ZSH_DST"

  # Ghostty: only link if it exists on this OS
  # (Ghostty might not be installed/available on Ubuntu)
  if command -v ghostty >/dev/null 2>&1 || is_macos; then
    link "$GHOSTTY_SRC" "$GHOSTTY_DST"
  else
    warn "Ghostty not detected; skipping ghostty symlink."
  fi

  install_tpm
  warn_if_font_missing

  info "Done."
  info "Next steps:"
  info "  - tmux: start tmux, then press prefix + I to install plugins (TPM)."
  info "  - zsh: start a new terminal (or run: exec zsh)."
  info "  - nvim: open Neovim and sync plugins (Lazy)."
}

main "$@"
