# uget Installation Guide

This guide provides detailed instructions for installing uget using various methods.

## 🚀 Installation Methods

### 1. PowerShell Script (Recommended)

The fastest way to install uget:

```powershell
# Run as Administrator (recommended for system-wide installation)
irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex
```

**Features:**

- ✅ Automatic dependency installation (fzf)
- ✅ PATH configuration
- ✅ Prerequisites checking
- ✅ Architecture detection
- ✅ Upgrade support

**Options:**

```powershell
# Custom installation path
irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex -ArgumentList @('-InstallPath', 'C:\MyApps\uget')

# Skip adding to PATH
irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex -ArgumentList @('-AddToPath', '$false')
```

### 2. MSI Installer (Windows Installer)

Professional Windows installer with GUI and silent installation support.

#### Interactive Installation

1. Download `uget-VERSION.msi` from [Releases](https://github.com/Utsav-56/uget/releases)
2. Double-click the MSI file
3. Follow the installation wizard
4. Choose whether to add uget to PATH
5. Complete the installation

#### Silent Installation

```cmd
# Download the MSI file first, then run:

# Basic silent installation
msiexec /i uget-1.0.0.msi /quiet

# Silent installation with PATH (recommended)
msiexec /i uget-1.0.0.msi /quiet ADDTOPATH=1

# Custom installation directory
msiexec /i uget-1.0.0.msi /quiet ADDTOPATH=1 INSTALLFOLDER="C:\Program Files\uget"

# Installation with logging
msiexec /i uget-1.0.0.msi /quiet ADDTOPATH=1 /l*v install.log
```

#### PowerShell Silent Installation

```powershell
# Download and install silently
$version = "1.0.0"
$msiUrl = "https://github.com/Utsav-56/uget/releases/download/v$version/uget-$version.msi"
$msiFile = "uget-$version.msi"

Invoke-WebRequest -Uri $msiUrl -OutFile $msiFile
Start-Process msiexec.exe -ArgumentList "/i", $msiFile, "/quiet", "ADDTOPATH=1" -Wait
Remove-Item $msiFile
```

#### Uninstallation

```cmd
# Via Programs and Features
appwiz.cpl

# Command line uninstall
msiexec /x uget-1.0.0.msi /quiet

# Or find the product code
wmic product where "name='uget'" call uninstall
```

### 3. EXE Installer (NSIS)

Lightweight executable installer with modern UI.

#### Interactive Installation

1. Download `uget-installer-VERSION.exe` from [Releases](https://github.com/Utsav-56/uget/releases)
2. Right-click and "Run as administrator" (recommended)
3. Follow the installation wizard
4. Choose components to install:
    - ✅ Main application (required)
    - ✅ Add to PATH (recommended)
    - ✅ Start Menu shortcuts
    - ✅ Desktop shortcut
5. Complete the installation

#### Silent Installation

```cmd
# Basic silent installation
uget-installer-1.0.0.exe /S

# Silent installation with custom directory
uget-installer-1.0.0.exe /S /D=C:\MyApps\uget
```

#### PowerShell Silent Installation

```powershell
# Download and install silently
$version = "1.0.0"
$exeUrl = "https://github.com/Utsav-56/uget/releases/download/v$version/uget-installer-$version.exe"
$exeFile = "uget-installer-$version.exe"

Invoke-WebRequest -Uri $exeUrl -OutFile $exeFile
Start-Process $exeFile -ArgumentList "/S" -Wait
Remove-Item $exeFile
```

#### Uninstallation

```cmd
# Via Control Panel
appwiz.cpl

# Command line uninstall (if available)
"C:\Program Files\uget\Uninstall.exe" /S
```

### 4. Portable Binary

Download and use without installation.

1. Download the appropriate binary from [Releases](https://github.com/Utsav-56/uget/releases):
    - `uget-windows-amd64.exe` - Windows 64-bit (recommended)
    - `uget-windows-386.exe` - Windows 32-bit
    - `uget-windows-arm64.exe` - Windows ARM64

2. Rename to `uget.exe`

3. Place in desired directory

4. Add directory to PATH (optional):

    ```powershell
    # Temporary (current session only)
    $env:PATH += ";C:\path\to\uget"

    # Permanent (user)
    [Environment]::SetEnvironmentVariable("Path", $env:PATH + ";C:\path\to\uget", "User")

    # Permanent (system - requires admin)
    [Environment]::SetEnvironmentVariable("Path", $env:PATH + ";C:\path\to\uget", "Machine")
    ```

### 5. Package Managers

#### Chocolatey (Future)

```cmd
# Coming soon
choco install uget
```

#### Scoop (Future)

```powershell
# Coming soon
scoop bucket add extras
scoop install uget
```

#### Winget (Future)

```cmd
# Coming soon
winget install uget
```

## 🔧 Installation Comparison

| Method     | Size   | GUI | Silent | Uninstall | PATH   | Dependencies |
| ---------- | ------ | --- | ------ | --------- | ------ | ------------ |
| PowerShell | Small  | ❌  | ✅     | Manual    | ✅     | ✅           |
| MSI        | Medium | ✅  | ✅     | ✅        | ✅     | ❌           |
| EXE        | Medium | ✅  | ✅     | ✅        | ✅     | ❌           |
| Portable   | Small  | ❌  | ❌     | Manual    | Manual | Manual       |

## 🛡️ Security Considerations

### Code Signing

Future releases will include code signing for MSI and EXE installers to ensure authenticity.

### Verification

Always download from official sources:

- GitHub Releases: `https://github.com/Utsav-56/uget/releases`
- Official website: `https://uget.dev` (coming soon)

### Checksums

Verify file integrity using checksums provided in releases:

```powershell
# Verify SHA256 checksum
$expectedHash = "ABC123..."  # From release notes
$actualHash = (Get-FileHash uget-installer-1.0.0.exe -Algorithm SHA256).Hash
if ($actualHash -eq $expectedHash) {
    Write-Host "✅ Checksum verified" -ForegroundColor Green
} else {
    Write-Host "❌ Checksum mismatch!" -ForegroundColor Red
}
```

## 🚨 Troubleshooting

### Common Issues

#### "Windows protected your PC" (SmartScreen)

For unsigned installers:

1. Click "More info"
2. Click "Run anyway"
3. Or disable SmartScreen temporarily

#### Installation fails with "Access denied"

- Run installer as Administrator
- Check antivirus software
- Ensure no other uget processes are running

#### PATH not updated

- Restart terminal/PowerShell
- Log out and back in
- Restart computer (rarely needed)

#### Dependencies missing (fzf)

```powershell
# Install fzf manually
winget install junegunn.fzf
# Or via Chocolatey
choco install fzf
# Or via Scoop
scoop install fzf
```

#### MSI installation fails

```cmd
# Check Windows Installer service
sc query msiserver

# Repair Windows Installer
MSIEXEC /UNREGISTER
MSIEXEC /REGSERVER

# View detailed error logs
msiexec /i uget-1.0.0.msi /l*v install.log
```

### Getting Help

- 📖 Documentation: [README.md](README.md)
- 🐛 Bug reports: [GitHub Issues](https://github.com/Utsav-56/uget/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/Utsav-56/uget/discussions)
- 📧 Email: support@uget.dev (coming soon)

## 🔄 Updating uget

### PowerShell Method

```powershell
# Re-run installation script (will upgrade)
irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex
```

### MSI Method

1. Download new MSI version
2. Run installer (will upgrade automatically)

### EXE Method

1. Download new EXE installer
2. Run installer (will upgrade automatically)

### Manual Method

1. Download new binary
2. Replace existing `uget.exe`

### Using uget itself

```cmd
# Self-update (coming soon)
uget upgrade uget
```

## 🗑️ Complete Uninstallation

### MSI Installation

```cmd
# Via Programs and Features
appwiz.cpl

# Command line
msiexec /x {PRODUCT-GUID} /quiet
```

### EXE Installation

```cmd
# Via Control Panel
appwiz.cpl

# Command line (if available)
"C:\Program Files\uget\Uninstall.exe" /S
```

### PowerShell Installation

```powershell
# Run uninstall script
irm https://raw.githubusercontent.com/Utsav-56/uget/main/uninstall.ps1 | iex
```

### Manual Cleanup

```powershell
# Remove binary
Remove-Item "C:\Program Files\uget\uget.exe" -Force

# Remove from PATH
$path = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = $path -replace [regex]::Escape(";C:\Program Files\uget"), ""
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# Remove configuration (if any)
Remove-Item "$env:APPDATA\uget" -Recurse -Force -ErrorAction SilentlyContinue
```

---

**Need help?** Check our [troubleshooting guide](TROUBLESHOOTING.md) or [open an issue](https://github.com/Utsav-56/uget/issues).
