# install-windows.ps1
# Execute: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Depois: .\install-windows.ps1

Write-Host "📦 Instalando Neovim + Dependências..." -ForegroundColor Cyan

# Verifica se Winget está disponível
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Winget não encontrado. Atualize seu Windows." -ForegroundColor Red
    exit 1
}

# Instala pacotes
winget install -e --id Neovim.Neovim --accept-package-agreements --accept-source-agreements
winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements
winget install -e --id BurntSushi.ripgrep.MSVC --accept-package-agreements --accept-source-agreements

# Adiciona USERPROFILE\.local\bin ao PATH se não existir
$pathToAdd = "$env:USERPROFILE\.local\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$pathToAdd*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$pathToAdd", "User")
    Write-Host "✅ PATH atualizado. Reinicie o terminal." -ForegroundColor Green
}

Write-Host "`n✅ Tudo instalado! Execute 'nvim' para testar." -ForegroundColor Green
