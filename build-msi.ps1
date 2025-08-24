# Build MSI Installer using WiX Toolset
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

function Test-WixInstalled {
    try {
        $null = Get-Command "candle.exe" -ErrorAction Stop
        $null = Get-Command "light.exe" -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

Write-ColorOutput "=== Building MSI Installer ===" $InfoColor

# Check if WiX is installed
if (-not (Test-WixInstalled)) {
    Write-ColorOutput "✗ WiX Toolset not found in PATH" $ErrorColor
    Write-ColorOutput "Please install WiX Toolset v3.11+ from https://wixtoolset.org/" $WarningColor
    Write-ColorOutput "Or install via Chocolatey: choco install wixtoolset" $InfoColor
    exit 1
}

# Check if binary exists
if (-not (Test-Path $BinaryPath)) {
    Write-ColorOutput "✗ Binary not found: $BinaryPath" $ErrorColor
    Write-ColorOutput "Please build the binary first: go build -o uget.exe ." $WarningColor
    exit 1
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$wxsFile = "installer\wix\uget.wxs"
$objDir = "installer\wix\obj"
$wixobjFile = "$objDir\uget.wixobj"
$msiFile = "$OutputDir\uget-$Version.msi"

# Create obj directory
if (-not (Test-Path $objDir)) {
    New-Item -ItemType Directory -Path $objDir -Force | Out-Null
}

try {
    # Copy binary to installer directory
    $installerBinary = "installer\wix\uget.exe"
    Copy-Item $BinaryPath $installerBinary -Force
    Write-ColorOutput "✓ Copied binary to installer directory" $SuccessColor

    # Update version in WXS file
    $wxsContent = Get-Content $wxsFile -Raw
    $wxsContent = $wxsContent -replace 'Version="1\.0\.0"', "Version=`"$Version`""
    Set-Content $wxsFile $wxsContent
    Write-ColorOutput "✓ Updated version to $Version" $SuccessColor

    # Compile WXS to WIXOBJ
    Write-ColorOutput "Compiling WXS file..." $InfoColor
    $candleArgs = @(
        "-out", $wixobjFile,
        $wxsFile,
        "-ext", "WixUIExtension"
    )
    
    & candle.exe @candleArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Candle compilation failed"
    }
    Write-ColorOutput "✓ WXS compilation successful" $SuccessColor

    # Link WIXOBJ to MSI
    Write-ColorOutput "Linking to MSI..." $InfoColor
    $lightArgs = @(
        "-out", $msiFile,
        $wixobjFile,
        "-ext", "WixUIExtension",
        "-cultures:en-US"
    )
    
    & light.exe @lightArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Light linking failed"
    }
    Write-ColorOutput "✓ MSI linking successful" $SuccessColor

    # Verify MSI was created
    if (Test-Path $msiFile) {
        $fileSize = [math]::Round((Get-Item $msiFile).Length / 1MB, 2)
        Write-ColorOutput ""
        Write-ColorOutput "=== MSI Build Complete ===" $SuccessColor
        Write-ColorOutput "Output: $msiFile ($fileSize MB)" $InfoColor
        Write-ColorOutput ""
        Write-ColorOutput "Installation commands:" $InfoColor
        Write-ColorOutput "  Interactive: msiexec /i `"$msiFile`"" $InfoColor
        Write-ColorOutput "  Silent:      msiexec /i `"$msiFile`" /quiet" $InfoColor
        Write-ColorOutput "  With PATH:   msiexec /i `"$msiFile`" /quiet ADDTOPATH=1" $InfoColor
    } else {
        throw "MSI file was not created"
    }
}
catch {
    Write-ColorOutput ""
    Write-ColorOutput "=== MSI Build Failed ===" $ErrorColor
    Write-ColorOutput "Error: $($_.Exception.Message)" $ErrorColor
    exit 1
}
finally {
    # Cleanup
    if (Test-Path $installerBinary) {
        Remove-Item $installerBinary -Force
    }
    if (Test-Path $objDir) {
        Remove-Item $objDir -Recurse -Force
    }
}
