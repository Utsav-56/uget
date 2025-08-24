# Build EXE Installer using NSIS
param(
    [string]$BinaryPath = "uget.exe",
    [string]$Version = "1.0.0",
    [string]$OutputDir = "dist"
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

function Test-NSISInstalled {
    try {
        $null = Get-Command "makensis.exe" -ErrorAction Stop
        return $true
    }
    catch {
        # Try common installation paths
        $nsisPath = @(
            "${env:ProgramFiles}\NSIS\makensis.exe",
            "${env:ProgramFiles(x86)}\NSIS\makensis.exe"
        )
        
        foreach ($path in $nsisPath) {
            if (Test-Path $path) {
                $env:PATH += ";$(Split-Path $path)"
                return $true
            }
        }
        return $false
    }
}

function Get-EnvVarUpdatePlugin {
    $pluginPath = "installer\nsis\EnvVarUpdate.nsh"
    if (-not (Test-Path $pluginPath)) {
        Write-ColorOutput "Downloading EnvVarUpdate plugin..." $InfoColor
        try {
            $url = "https://raw.githubusercontent.com/GsNSIS/EnvVarUpdate/master/EnvVarUpdate.nsh"
            Invoke-WebRequest -Uri $url -OutFile $pluginPath
            Write-ColorOutput "✓ Downloaded EnvVarUpdate plugin" $SuccessColor
        }
        catch {
            Write-ColorOutput "✗ Failed to download EnvVarUpdate plugin" $ErrorColor
            Write-ColorOutput "Please download manually from: https://nsis.sourceforge.io/EnvVarUpdate" $WarningColor
            return $false
        }
    }
    return $true
}

Write-ColorOutput "=== Building EXE Installer ===" $InfoColor

# Check if NSIS is installed
if (-not (Test-NSISInstalled)) {
    Write-ColorOutput "✗ NSIS not found in PATH" $ErrorColor
    Write-ColorOutput "Please install NSIS from https://nsis.sourceforge.io/" $WarningColor
    Write-ColorOutput "Or install via Chocolatey: choco install nsis" $InfoColor
    exit 1
}

# Check if binary exists
if (-not (Test-Path $BinaryPath)) {
    Write-ColorOutput "✗ Binary not found: $BinaryPath" $ErrorColor
    Write-ColorOutput "Please build the binary first: go build -o uget.exe ." $WarningColor
    exit 1
}

# Get EnvVarUpdate plugin
if (-not (Get-EnvVarUpdatePlugin)) {
    exit 1
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$nsiFile = "installer\nsis\uget.nsi"
$exeFile = "$OutputDir\uget-installer-$Version.exe"

try {
    # Copy binary to installer directory
    $installerBinary = "installer\nsis\uget.exe"
    Copy-Item $BinaryPath $installerBinary -Force
    Write-ColorOutput "✓ Copied binary to installer directory" $SuccessColor

    # Build the installer
    Write-ColorOutput "Compiling NSIS installer..." $InfoColor
    $nsisArgs = @(
        "/DVERSION=$Version",
        "/DOUTFILE=$exeFile",
        $nsiFile
    )
    
    & makensis.exe @nsisArgs
    if ($LASTEXITCODE -ne 0) {
        throw "NSIS compilation failed"
    }
    Write-ColorOutput "✓ NSIS compilation successful" $SuccessColor

    # Verify EXE was created
    if (Test-Path $exeFile) {
        $fileSize = [math]::Round((Get-Item $exeFile).Length / 1MB, 2)
        Write-ColorOutput ""
        Write-ColorOutput "=== EXE Build Complete ===" $SuccessColor
        Write-ColorOutput "Output: $exeFile ($fileSize MB)" $InfoColor
        Write-ColorOutput ""
        Write-ColorOutput "Installation commands:" $InfoColor
        Write-ColorOutput "  Interactive: `"$exeFile`"" $InfoColor
        Write-ColorOutput "  Silent:      `"$exeFile`" /S" $InfoColor
        Write-ColorOutput "  Custom dir:  `"$exeFile`" /S /D=C:\MyPath\uget" $InfoColor
    } else {
        throw "EXE file was not created"
    }
}
catch {
    Write-ColorOutput ""
    Write-ColorOutput "=== EXE Build Failed ===" $ErrorColor
    Write-ColorOutput "Error: $($_.Exception.Message)" $ErrorColor
    exit 1
}
finally {
    # Cleanup
    if (Test-Path $installerBinary) {
        Remove-Item $installerBinary -Force
    }
}
