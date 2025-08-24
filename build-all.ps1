# Comprehensive build script for uget
# Builds binaries, MSI installer, and EXE installer

param(
    [string]$Version = "1.0.0",
    [string]$OutputDir = "dist",
    [switch]$SkipBinaries = $false,
    [switch]$SkipMSI = $false,
    [switch]$SkipEXE = $false,
    [switch]$Clean = $false
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

Write-ColorOutput "=== uget Comprehensive Build Script ===" $InfoColor
Write-ColorOutput "Version: $Version" $InfoColor
Write-ColorOutput "Output Directory: $OutputDir" $InfoColor

# Clean output directory if requested
if ($Clean -and (Test-Path $OutputDir)) {
    Write-ColorOutput "Cleaning output directory..." $InfoColor
    Remove-Item $OutputDir -Recurse -Force
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$buildErrors = @()

# Build binaries
if (-not $SkipBinaries) {
    Write-ColorOutput ""
    Write-ColorOutput "=== Building Binaries ===" $InfoColor
    
    try {
        & .\build.ps1 -Version $Version -OutputDir $OutputDir -Clean:$Clean
        if ($LASTEXITCODE -ne 0) {
            throw "Binary build failed"
        }
        Write-ColorOutput "✓ Binaries built successfully" $SuccessColor
    }
    catch {
        $buildErrors += "Binary build: $($_.Exception.Message)"
        Write-ColorOutput "✗ Binary build failed: $($_.Exception.Message)" $ErrorColor
    }
}

# Build MSI installer
if (-not $SkipMSI) {
    Write-ColorOutput ""
    Write-ColorOutput "=== Building MSI Installer ===" $InfoColor
    
    try {
        $binaryPath = "$OutputDir\uget-windows-amd64.exe"
        if (-not (Test-Path $binaryPath)) {
            $binaryPath = "uget.exe"
        }
        
        & .\build-msi.ps1 -BinaryPath $binaryPath -Version $Version -OutputDir $OutputDir
        if ($LASTEXITCODE -ne 0) {
            throw "MSI build failed"
        }
        Write-ColorOutput "✓ MSI installer built successfully" $SuccessColor
    }
    catch {
        $buildErrors += "MSI build: $($_.Exception.Message)"
        Write-ColorOutput "✗ MSI build failed: $($_.Exception.Message)" $ErrorColor
    }
}

# Build EXE installer
if (-not $SkipEXE) {
    Write-ColorOutput ""
    Write-ColorOutput "=== Building EXE Installer ===" $InfoColor
    
    try {
        $binaryPath = "$OutputDir\uget-windows-amd64.exe"
        if (-not (Test-Path $binaryPath)) {
            $binaryPath = "uget.exe"
        }
        
        & .\build-exe.ps1 -BinaryPath $binaryPath -Version $Version -OutputDir $OutputDir
        if ($LASTEXITCODE -ne 0) {
            throw "EXE build failed"
        }
        Write-ColorOutput "✓ EXE installer built successfully" $SuccessColor
    }
    catch {
        $buildErrors += "EXE build: $($_.Exception.Message)"
        Write-ColorOutput "✗ EXE build failed: $($_.Exception.Message)" $ErrorColor
    }
}

# Summary
Write-ColorOutput ""
Write-ColorOutput "=== Build Summary ===" $InfoColor

if ($buildErrors.Count -eq 0) {
    Write-ColorOutput "✓ All builds completed successfully!" $SuccessColor
} else {
    Write-ColorOutput "✗ Some builds failed:" $ErrorColor
    foreach ($error in $buildErrors) {
        Write-ColorOutput "  - $error" $ErrorColor
    }
}

# List created files
Write-ColorOutput ""
Write-ColorOutput "Created files:" $InfoColor
Get-ChildItem $OutputDir -File | ForEach-Object {
    $size = [math]::Round($_.Length / 1MB, 2)
    Write-ColorOutput "  $($_.Name) ($size MB)" $InfoColor
}

# Usage instructions
Write-ColorOutput ""
Write-ColorOutput "=== Usage Instructions ===" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "PowerShell Installation:" $InfoColor
Write-ColorOutput "  irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "MSI Installation:" $InfoColor
Write-ColorOutput "  Interactive: msiexec /i `"$OutputDir\uget-$Version.msi`"" $InfoColor
Write-ColorOutput "  Silent:      msiexec /i `"$OutputDir\uget-$Version.msi`" /quiet ADDTOPATH=1" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "EXE Installation:" $InfoColor
Write-ColorOutput "  Interactive: `"$OutputDir\uget-installer-$Version.exe`"" $InfoColor
Write-ColorOutput "  Silent:      `"$OutputDir\uget-installer-$Version.exe`" /S" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "Manual Installation:" $InfoColor
Write-ColorOutput "  Copy `"$OutputDir\uget-windows-amd64.exe`" to desired location" $InfoColor
Write-ColorOutput "  Rename to `"uget.exe`" and add directory to PATH" $InfoColor

if ($buildErrors.Count -gt 0) {
    exit 1
}
