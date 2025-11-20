#!/bin/bash
set -e

echo "🔍 Detectando sistema operacional..."
OS="$(uname -s)"
case "$OS" in
Linux*)
  if [ -f /etc/debian_version ]; then
    echo "📦 Ubuntu/Debian detectado"
    sudo apt update
    sudo apt install -y neovim git build-essential curl wget unzip ripgrep fd-find fontconfig
  elif [ -f /etc/fedora-release ]; then
    echo "📦 Fedora detectado"
    sudo dnf install -y neovim git gcc make curl wget unzip ripgrep fd-find
  fi
  ;;
Darwin*)
  echo "📦 macOS detectado"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install neovim git ripgrep fd curl wget
  ;;
MINGW* | CYGWIN* | MSYS*)
  echo "⚠️  Windows detectado. Por favor, instale manualmente:"
  echo "  winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC"
  exit 1
  ;;
*)
  echo "❌ Sistema não suportado: $OS"
  exit 1
  ;;
esac

echo "✅ Dependências instaladas com sucesso!"
