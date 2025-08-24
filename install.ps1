# uget Installation Script
# Run with: irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex

param(
    [string]$InstallPath = "$env:LOCALAPPDATA\uget",
    [string]$Version = "latest",
    [switch]$AddToPath = $true
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

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Add-ToPath {
    param([string]$Path)
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$Path*") {
        Write-ColorOutput "Adding uget to PATH..." $InfoColor
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$Path", "User")
        
        # Also add to current session
        $env:Path += ";$Path"
        
        Write-ColorOutput "✓ Added to PATH successfully" $SuccessColor
        return $true
    }
    return $false
}

function Test-Prerequisites {
    Write-ColorOutput "Checking prerequisites..." $InfoColor
    
    # Check Windows version
    $osVersion = [System.Environment]::OSVersion.Version
    if ($osVersion.Major -lt 10) {
        Write-ColorOutput "✗ Windows 10 or later is required" $ErrorColor
        exit 1
    }
    
    # Check winget
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "✗ Windows Package Manager (winget) is not installed or not in PATH" $ErrorColor
        Write-ColorOutput "Please install winget from Microsoft Store or GitHub releases" $WarningColor
        exit 1
    }
    
    Write-ColorOutput "✓ Prerequisites check passed" $SuccessColor
}

function Get-LatestRelease {
    try {
        $apiUrl = "https://api.github.com/repos/Utsav-56/uget/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop
        return $response.tag_name
    }
    catch {
        Write-ColorOutput "Warning: Could not fetch latest version, using fallback" $WarningColor
        return "v1.0.0"
    }
}

function Get-PreferredInstaller {
    Write-ColorOutput ""
    Write-ColorOutput "Multiple installation options are available:" $InfoColor
    Write-ColorOutput "1. Direct binary download (current method)" $InfoColor
    Write-ColorOutput "2. MSI installer (Windows Installer)" $InfoColor
    Write-ColorOutput "3. EXE installer (NSIS)" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "For MSI installer, download from GitHub releases and run:" $InfoColor
    Write-ColorOutput "  msiexec /i uget-VERSION.msi /quiet ADDTOPATH=1" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "For EXE installer, download and run:" $InfoColor
    Write-ColorOutput "  uget-installer-VERSION.exe /S" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "Continuing with direct binary download..." $InfoColor
}

function Download-UgetBinary {
    param(
        [string]$Version,
        [string]$Destination
    )
    
    if ($Version -eq "latest") {
        $Version = Get-LatestRelease
    }
    
    # Determine architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }
    
    $downloadUrl = "https://github.com/Utsav-56/uget/releases/download/$Version/uget-windows-$arch.exe"
    $binaryPath = Join-Path $Destination "uget.exe"
    
    Write-ColorOutput "Downloading uget $Version for Windows $arch..." $InfoColor
    Write-ColorOutput "Download URL: $downloadUrl" $InfoColor
    
    try {
        # Create directory if it doesn't exist
        if (-not (Test-Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        }
        
        # Download with progress
        $progressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $downloadUrl -OutFile $binaryPath -ErrorAction Stop
        $progressPreference = 'Continue'
        
        Write-ColorOutput "✓ Downloaded successfully to $binaryPath" $SuccessColor
        return $binaryPath
    }
    catch {
        Write-ColorOutput "✗ Failed to download uget: $($_.Exception.Message)" $ErrorColor
        Write-ColorOutput "You can manually download from: https://github.com/Utsav-56/uget/releases" $InfoColor
        exit 1
    }
}

function Install-Dependencies {
    Write-ColorOutput "Checking and installing dependencies..." $InfoColor
    
    # Check if fzf is available
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "Installing fzf (fuzzy finder)..." $InfoColor
        try {
            winget install junegunn.fzf --silent --accept-package-agreements --accept-source-agreements
            Write-ColorOutput "✓ fzf installed successfully" $SuccessColor
        }
        catch {
            Write-ColorOutput "Warning: Could not install fzf automatically. Please install it manually." $WarningColor
            Write-ColorOutput "Run: winget install junegunn.fzf" $InfoColor
        }
    } else {
        Write-ColorOutput "✓ fzf is already installed" $SuccessColor
    }
}

function Test-Installation {
    param([string]$BinaryPath)
    
    Write-ColorOutput "Testing installation..." $InfoColor
    
    try {
        $output = & $BinaryPath --help 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✓ Installation test passed" $SuccessColor
            return $true
        } else {
            Write-ColorOutput "✗ Installation test failed" $ErrorColor
            return $false
        }
    }
    catch {
        Write-ColorOutput "✗ Installation test failed: $($_.Exception.Message)" $ErrorColor
        return $false
    }
}

# Main installation process
Write-ColorOutput "=== uget Installation Script ===" $InfoColor
Write-ColorOutput "Installing to: $InstallPath" $InfoColor

# Show installer options
Get-PreferredInstaller

# Check prerequisites
Test-Prerequisites

# Download and install
$binaryPath = Download-UgetBinary -Version $Version -Destination $InstallPath

# Install dependencies
Install-Dependencies

# Add to PATH if requested
if ($AddToPath) {
    Add-ToPath $InstallPath
}

# Test installation
if (Test-Installation $binaryPath) {
    Write-ColorOutput "" 
    Write-ColorOutput "=== Installation Complete! ===" $SuccessColor
    Write-ColorOutput ""
    Write-ColorOutput "uget has been installed successfully!" $SuccessColor
    Write-ColorOutput "Location: $binaryPath" $InfoColor
    
    if ($AddToPath) {
        Write-ColorOutput ""
        Write-ColorOutput "You may need to restart your terminal for PATH changes to take effect." $WarningColor
        Write-ColorOutput "Or run: `$env:Path += ';$InstallPath'" $InfoColor
    }
    
    Write-ColorOutput ""
    Write-ColorOutput "Quick start:" $InfoColor
    Write-ColorOutput "  uget --help          # Show help" $InfoColor
    Write-ColorOutput "  uget si chrome       # Search and install Chrome" $InfoColor
    Write-ColorOutput "  uget install firefox # Install Firefox directly" $InfoColor
    Write-ColorOutput "  uget upgrade         # Upgrade all packages" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "Documentation: https://github.com/Utsav-56/uget" $InfoColor
} else {
    Write-ColorOutput ""
    Write-ColorOutput "=== Installation Failed ===" $ErrorColor
    Write-ColorOutput "Please check the error messages above and try again." $ErrorColor
    Write-ColorOutput "If the problem persists, please report it at:" $InfoColor
    Write-ColorOutput "https://github.com/Utsav-56/uget/issues" $InfoColor
    exit 1
}
