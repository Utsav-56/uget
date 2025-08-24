# Build script for uget
# Creates binaries for different Windows architectures

param(
    [string]$Version = "dev",
    [string]$OutputDir = "dist",
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

# Clean output directory if requested
if ($Clean -and (Test-Path $OutputDir)) {
    Write-ColorOutput "Cleaning output directory..." $InfoColor
    Remove-Item $OutputDir -Recurse -Force
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-ColorOutput "=== Building uget v$Version ===" $InfoColor

# Build configurations
$builds = @(
    @{ OS = "windows"; Arch = "amd64"; Name = "uget-windows-amd64.exe" },
    @{ OS = "windows"; Arch = "386"; Name = "uget-windows-386.exe" },
    @{ OS = "windows"; Arch = "arm64"; Name = "uget-windows-arm64.exe" }
)

$ldflags = "-s -w -X main.Version=$Version"

foreach ($build in $builds) {
    $outputPath = Join-Path $OutputDir $build.Name
    
    Write-ColorOutput "Building $($build.Name)..." $InfoColor
    
    $env:GOOS = $build.OS
    $env:GOARCH = $build.Arch
    
    try {
        go build -ldflags="$ldflags" -o $outputPath .
        
        if (Test-Path $outputPath) {
            $fileSize = [math]::Round((Get-Item $outputPath).Length / 1MB, 2)
            Write-ColorOutput "✓ Built $($build.Name) ($fileSize MB)" $SuccessColor
        } else {
            Write-ColorOutput "✗ Failed to build $($build.Name)" $ErrorColor
        }
    }
    catch {
        Write-ColorOutput "✗ Error building $($build.Name): $($_.Exception.Message)" $ErrorColor
    }
}

# Reset environment variables
Remove-Item Env:GOOS -ErrorAction SilentlyContinue
Remove-Item Env:GOARCH -ErrorAction SilentlyContinue

Write-ColorOutput ""
Write-ColorOutput "=== Build Complete ===" $SuccessColor
Write-ColorOutput "Binaries created in: $OutputDir" $InfoColor

# List created files
Get-ChildItem $OutputDir -Filter "*.exe" | ForEach-Object {
    $size = [math]::Round($_.Length / 1MB, 2)
    Write-ColorOutput "  $($_.Name) ($size MB)" $InfoColor
}
