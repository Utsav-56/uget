# uget Uninstallation Script
param(
    [string]$InstallPath = "$env:LOCALAPPDATA\uget",
    [switch]$RemoveFromPath = $true
)

# Colors for output
$SuccessColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"
$InfoColor = "Cyan"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Remove-FromPath {
    param([string]$Path)
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -like "*$Path*") {
        Write-ColorOutput "Removing uget from PATH..." $InfoColor
        $newPath = $currentPath -replace [regex]::Escape(";$Path"), "" -replace [regex]::Escape("$Path;"), "" -replace [regex]::Escape($Path), ""
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-ColorOutput "✓ Removed from PATH successfully" $SuccessColor
        return $true
    }
    return $false
}

Write-ColorOutput "=== uget Uninstallation Script ===" $InfoColor
Write-ColorOutput "Removing from: $InstallPath" $InfoColor

# Check if uget is installed
$binaryPath = Join-Path $InstallPath "uget.exe"
if (-not (Test-Path $binaryPath)) {
    Write-ColorOutput "✗ uget not found at $binaryPath" $WarningColor
    Write-ColorOutput "It may have been installed elsewhere or already removed." $InfoColor
} else {
    # Remove the binary
    try {
        Remove-Item $binaryPath -Force
        Write-ColorOutput "✓ Removed uget binary" $SuccessColor
    } catch {
        Write-ColorOutput "✗ Failed to remove binary: $($_.Exception.Message)" $ErrorColor
    }
    
    # Remove directory if empty
    try {
        if ((Get-ChildItem $InstallPath -ErrorAction SilentlyContinue).Count -eq 0) {
            Remove-Item $InstallPath -Force
            Write-ColorOutput "✓ Removed installation directory" $SuccessColor
        }
    } catch {
        Write-ColorOutput "Warning: Could not remove installation directory" $WarningColor
    }
}

# Remove from PATH
if ($RemoveFromPath) {
    Remove-FromPath $InstallPath
}

Write-ColorOutput ""
Write-ColorOutput "=== Uninstallation Complete ===" $SuccessColor
Write-ColorOutput "uget has been removed from your system." $InfoColor
Write-ColorOutput ""
Write-ColorOutput "Note: Dependencies like fzf were not removed." $WarningColor
Write-ColorOutput "To remove fzf: winget uninstall junegunn.fzf" $InfoColor
