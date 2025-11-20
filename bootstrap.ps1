# bootstrap.ps1
param(
    [Parameter(Mandatory=$false)]
    [string]$RepoUrl = "https://github.com/SEU-USUARIO/dotfiles-neovim.git"
)

Write-Host "🚀 Bootstrap Neovim + LazyVim (Windows)" -ForegroundColor Cyan

# 1. Instala dependências
function Install-Deps {
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Winget não encontrado. Atualize o Windows." -ForegroundColor Red
        exit 1
    }
    
    winget install -e --id Neovim.Neovim --accept-package-agreements
    winget install -e --id Git.Git --accept-package-agreements
    winget install -e --id BurntSushi.ripgrep.MSVC --accept-package-agreements
    
    # Adiciona ao PATH
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host "✅ Dependências instaladas" -ForegroundColor Green
}

# 2. Backup
function Backup-Config {
    $configDir = "$env:LOCALAPPDATA\nvim"
    if (Test-Path $configDir) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        Rename-Item $configDir "nvim.bak-$timestamp"
        Write-Host "📦 Backup criado" -ForegroundColor Yellow
    }
}

# 3. Clone
function Clone-Repo {
    git clone $RepoUrl "$env:LOCALAPPDATA\nvim"
    Write-Host "✅ Repositório clonado" -ForegroundColor Green
}

# 4. Instala plugins
function Install-Plugins {
    Write-Host "⏳ Instalando plugins (pode demorar)..." -ForegroundColor Yellow
    nvim --headless "+Lazy! sync" +qa
    Write-Host "✅ Plugins instalados" -ForegroundColor Green
}

# Executa
Install-Deps
Backup-Config
Clone-Repo
Install-Plugins

Write-Host "`n✅ Tudo pronto! Execute 'nvim' para começar." -ForegroundColor Green
