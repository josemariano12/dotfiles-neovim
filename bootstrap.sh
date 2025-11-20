#!/bin/bash
set -e

REPO_URL="https://github.com/SEU-USUARIO/dotfiles-neovim.git"
INSTALL_DIR="$HOME/.config/nvim"

echo "🚀 Bootstrap Neovim + LazyVim"

# 1. Detecta SO e instala dependências
install_deps() {
  OS="$(uname -s)"
  case "$OS" in
  Linux*)
    if command -v apt &>/dev/null; then
      sudo apt update && sudo apt install -y neovim git build-essential ripgrep fd-find
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y neovim git gcc ripgrep fd-find
    fi
    ;;
  Darwin*)
    if ! command -v brew &>/dev/null; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install neovim git ripgrep fd
    ;;
  esac
}

# 2. Backup existente
backup_config() {
  if [ -d "$INSTALL_DIR" ]; then
    mv "$INSTALL_DIR" "$INSTALL_DIR.bak-$(date +%Y%m%d)"
    echo "📦 Backup criado"
  fi
}

# 3. Clone do repositório
clone_repo() {
  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
}

# 4. Primeira execução (instala plugins)
install_plugins() {
  echo "⏳ Instalando plugins (pode demorar)..."
  nvim --headless "+Lazy! sync" +qa
}

# Executa tudo
install_deps
backup_config
clone_repo
install_plugins

echo "✅ Neovim pronto! Execute 'nvim' para começar."
