# uget

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Go Version](https://img.shields.io/badge/go-%3E%3D1.24-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)

**uget** is a user-friendly command-line wrapper for Windows Package Manager (winget) that enhances the package management experience on Windows. It provides interactive search capabilities, simplified commands, and improved user experience for managing Windows applications.

## ✨ Features

- 🔍 **Interactive package search** with fuzzy finding using `fzf`
- 📦 **Simplified commands** for install, uninstall, and upgrade operations
- 🔄 **Automatic dependency checking** and installation
- 🚀 **Enhanced search and discovery** capabilities
- 💡 **Intuitive command aliases** for faster workflow
- 🛡️ **Built on top of winget** - leverages the official Windows Package Manager

## 📋 Prerequisites

- **Windows 10/11** with Windows Package Manager (winget) installed
- **PowerShell 5.1+** or **PowerShell Core 7+**
- **fzf** (fuzzy finder) - will be automatically installed if missing

> **Note**: Winget comes pre-installed on Windows 11 and recent Windows 10 updates. If not available, you can install it from the [Microsoft Store](https://www.microsoft.com/store/productId/9NBLGGH4NNS1) or [GitHub releases](https://github.com/microsoft/winget-cli/releases).

## 🚀 Installation

### Option 1: PowerShell Script (Recommended)

Run this command in PowerShell as Administrator:

```powershell
irm https://raw.githubusercontent.com/Utsav-56/uget/main/install.ps1 | iex
```

### Option 2: MSI Installer (Windows Installer)

1. Download the latest MSI installer from the [Releases](https://github.com/Utsav-56/uget/releases) page
2. Run the installer as Administrator
3. Follow the installation wizard

**Silent installation:**

```cmd
msiexec /i uget-1.0.0.msi /quiet ADDTOPATH=1
```

### Option 3: EXE Installer (NSIS)

1. Download the latest EXE installer from the [Releases](https://github.com/Utsav-56/uget/releases) page
2. Run as Administrator
3. Follow the installation wizard

**Silent installation:**

```cmd
uget-installer-1.0.0.exe /S
```

### Option 4: Portable Binary

1. Download the latest binary from [Releases](https://github.com/Utsav-56/uget/releases)
2. Extract to a directory (e.g., `C:\Program Files\uget\`)
3. Add the directory to your system PATH
4. Restart your terminal

### Option 5: Build from Source

See the [Building from Source](#-building-from-source) section below.

## 📖 Usage

### Quick Start

```bash
# Search and install a package interactively
uget si chrome

# Install a package directly
uget install firefox

# Upgrade all packages
uget upgrade

# Uninstall a package
uget uninstall vlc
```

### Available Commands

```
Usage:
  uget [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  help        Help about any command
  install     Install a package using winget
  si          Interactive search and install packages
  uninstall   Uninstall a package using winget
  upgrade     Upgrade packages using winget

Flags:
  -?, --help   help for uget

Use "uget [command] --help" for more information about a command.
```

### Detailed Usage Examples

#### Interactive Search (`si`)

The `si` command provides an interactive interface to search and install packages:

```bash
# Browse all available packages
uget si

# Search for specific packages
uget si chrome          # Search for Chrome-related packages
uget si "visual studio" # Search for Visual Studio packages
uget search editor      # Alternative: search for text editors
uget find media         # Alternative: find media applications
```

**How it works:**

1. Opens an interactive fuzzy finder (fzf) interface
2. Type to filter packages in real-time
3. Use arrow keys to navigate
4. Press Enter to select and install
5. Press Esc to cancel

#### Install Command

Install packages directly without interactive search:

```bash
# Install by package name
uget install chrome
uget install firefox
uget install "Visual Studio Code"

# Install using exact package ID
uget install Microsoft.VisualStudioCode
uget install Google.Chrome

# Short form
uget i notepad++
```

#### Upgrade Command

Keep your packages up to date:

```bash
# Upgrade all packages
uget upgrade

# Upgrade specific package
uget upgrade chrome
uget upgrade firefox

# Alternative commands
uget update             # Same as upgrade
uget up                 # Short form
```

#### Uninstall Command

Remove packages from your system:

```bash
# Uninstall by name
uget uninstall chrome
uget uninstall "Visual Studio Code"

# Alternative commands
uget remove firefox     # Same as uninstall
uget del vlc            # Same as uninstall
uget rm notepad++       # Same as uninstall
```

#### Help System

Get help for any command:

```bash
# General help
uget --help
uget -?                 # Alternative help flag

# Command-specific help
uget install --help
uget si -?
uget upgrade --help
```

### Advanced Usage

#### Package Name Formats

uget accepts various package name formats:

```bash
# Display name (searches for best match)
uget install "Google Chrome"

# Package ID (exact match)
uget install Google.Chrome

# Partial name (searches for match)
uget install chrome

# Publisher.ProductName format
uget install Microsoft.VisualStudioCode
```

#### Command Aliases

uget provides convenient aliases for faster workflow:

| Command     | Aliases               | Description        |
| ----------- | --------------------- | ------------------ |
| `install`   | `i`                   | Install packages   |
| `uninstall` | `remove`, `del`, `rm` | Remove packages    |
| `upgrade`   | `update`, `up`        | Update packages    |
| `si`        | `search`, `find`      | Interactive search |

#### Examples by Use Case

**Developer Setup:**

```bash
# Install common development tools
uget install git
uget install "Visual Studio Code"
uget install nodejs
uget install python
uget install docker
```

**Media and Entertainment:**

```bash
# Install media applications
uget si media           # Browse media apps interactively
uget install vlc
uget install spotify
uget install discord
```

**System Maintenance:**

```bash
# Keep system updated
uget upgrade            # Update all packages
uget upgrade --dry-run  # Preview updates (if supported)
```

## 🔧 Building from Source

### Prerequisites

- [Go 1.24+](https://golang.org/dl/)
- Git

### Steps

1. **Clone the repository:**

    ```bash
    git clone https://github.com/Utsav-56/uget.git
    cd uget
    ```

2. **Install dependencies:**

    ```bash
    go mod download
    ```

3. **Build the executable:**

    ```bash
    # Build for current platform
    go build -o uget.exe .

    # Build with optimizations
    go build -ldflags="-s -w" -o uget.exe .
    ```

4. **Install locally:**

    ```bash
    # Copy to a directory in your PATH
    copy uget.exe "C:\Program Files\uget\"

    # Or install using Go
    go install .
    ```

### Build for Different Architectures

```bash
# Windows 64-bit
GOOS=windows GOARCH=amd64 go build -o uget-windows-amd64.exe .

# Windows 32-bit
GOOS=windows GOARCH=386 go build -o uget-windows-386.exe .

# Windows ARM64
GOOS=windows GOARCH=arm64 go build -o uget-windows-arm64.exe .
```

### Development Mode

Run without building:

```bash
go run . --help
go run . si chrome
```

## 🤝 Contributing

We welcome contributions! Here's how you can help improve uget:

### Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork:**
    ```bash
    git clone https://github.com/Utsav-56/uget.git
    cd uget
    ```
3. **Create a feature branch:**
    ```bash
    git checkout -b feature/your-feature-name
    ```

### Development Setup

1. **Install Go 1.24+** from [golang.org](https://golang.org/dl/)
2. **Install dependencies:**
    ```bash
    go mod download
    ```
3. **Run tests:**
    ```bash
    go test ./...
    ```
4. **Run the application:**
    ```bash
    go run . --help
    ```

### Code Style

- Follow standard Go formatting: `go fmt ./...`
- Run linter: `golangci-lint run` (install from [golangci-lint.run](https://golangci-lint.run/))
- Write meaningful commit messages
- Add tests for new functionality

### Types of Contributions

- 🐛 **Bug fixes** - Fix issues and improve stability
- ✨ **New features** - Add new commands or functionality
- 📚 **Documentation** - Improve README, code comments, or examples
- 🎨 **UI/UX improvements** - Enhance the interactive experience
- 🔧 **Performance** - Optimize speed and resource usage
- 🧪 **Tests** - Add or improve test coverage

### Submitting Changes

1. **Make your changes** in your feature branch
2. **Test thoroughly:**
    ```bash
    go test ./...
    go run . --help  # Test basic functionality
    ```
3. **Commit your changes:**
    ```bash
    git add .
    git commit -m "feat: add support for package search history"
    ```
4. **Push to your fork:**
    ```bash
    git push origin feature/your-feature-name
    ```
5. **Create a Pull Request** on GitHub

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:

```
feat: add package search history
fix: resolve installation timeout issues
docs: update installation instructions
```

### Issue Guidelines

When reporting issues:

1. **Use the issue templates** if available
2. **Provide system information:**
    - Windows version
    - PowerShell version
    - uget version
    - winget version
3. **Include error messages** and logs
4. **Describe steps to reproduce** the issue
5. **Expected vs actual behavior**

### Feature Requests

When suggesting features:

1. **Describe the use case** - why is this needed?
2. **Provide examples** - how would it work?
3. **Consider alternatives** - are there other solutions?
4. **Check existing issues** - avoid duplicates

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Windows Package Manager (winget)](https://github.com/microsoft/winget-cli) - The underlying package manager
- [Cobra](https://github.com/spf13/cobra) - CLI framework for Go
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder for interactive search
- All [contributors](https://github.com/Utsav-56/uget/contributors) who help improve this project

## 📞 Support

- 📖 Check the [documentation](#-usage) for common usage patterns
- 🐛 Report bugs on [GitHub Issues](https://github.com/Utsav-56/uget/issues)
- 💡 Request features on [GitHub Issues](https://github.com/Utsav-56/uget/issues)
- 💬 Join discussions on [GitHub Discussions](https://github.com/Utsav-56/uget/discussions)

## 🗺️ Roadmap

- [ ] Package search history and favorites
- [ ] Configuration file support
- [ ] Package dependency visualization
- [ ] Batch operations from file
- [ ] Integration with other package managers
- [ ] Web interface for package management
- [ ] Package update notifications

---

**Made with ❤️ for the Windows developer community**
