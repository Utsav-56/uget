# Contributing to uget

Thank you for your interest in contributing to uget! This document provides guidelines and information for contributors.

## 🚀 Quick Start

1. Fork the repository
2. Clone your fork: `git clone https://github.com/Utsav-56/uget.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Test your changes: `go test ./...` and `go run . --help`
6. Commit your changes: `git commit -m "feat: add amazing feature"`
7. Push to your branch: `git push origin feature/amazing-feature`
8. Open a Pull Request

## 📋 Development Environment

### Prerequisites

- **Go 1.24+** - [Download from golang.org](https://golang.org/dl/)
- **Git** - For version control
- **Windows 10/11** - Primary target platform
- **PowerShell** - For testing scripts
- **winget** - For testing package operations

### Setup

```bash
# Clone the repository
git clone https://github.com/Utsav-56/uget.git
cd uget

# Install dependencies
go mod download

# Run tests
go test ./...

# Test the application
go run . --help
go run . si test-query
```

### Development Tools (Optional)

- **golangci-lint** - For code linting
- **fzf** - For testing interactive features
- **VS Code** with Go extension - Recommended IDE

## 🏗️ Project Structure

```
uget/
├── cmd/                    # Cobra CLI commands
│   ├── root.go            # Root command and global flags
│   ├── install.go         # Install command
│   ├── uninstall.go       # Uninstall command
│   ├── upgrade.go         # Upgrade command
│   ├── si.go              # Interactive search command
│   └── requirements.go    # Dependency checking
├── uget/                  # Core functionality
│   └── winget_helpers.go  # winget integration
├── ucmd/                  # Utility commands
│   ├── utils.go           # General utilities
│   └── win/               # Windows-specific utilities
├── main.go               # Application entry point
├── go.mod               # Go module definition
├── README.md           # Main documentation
├── install.ps1        # PowerShell installer
├── build.ps1          # Build script
└── .github/           # GitHub workflows
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
go test ./...

# Run tests with verbose output
go test -v ./...

# Run tests with coverage
go test -cover ./...

# Test specific package
go test ./uget
```

### Manual Testing

```bash
# Test basic functionality
go run . --help
go run . -?

# Test commands
go run . install --help
go run . si --help
go run . upgrade --help
go run . uninstall --help

# Test interactive search (requires fzf)
go run . si
go run . si chrome
```

### Testing Changes

Before submitting changes:

1. **Test all commands work**: `go run . [command] --help`
2. **Verify help system**: Test both `-h` and `-?` flags
3. **Test on clean system**: Ensure no dependencies on your specific setup
4. **Check error handling**: Test with invalid inputs
5. **Verify backward compatibility**: Existing commands should still work

## 🎯 Contribution Guidelines

### Code Style

- **Follow Go conventions**: Use `go fmt` and `go vet`
- **Write clear comments**: Especially for exported functions
- **Use meaningful names**: Functions, variables, and packages
- **Keep functions small**: Single responsibility principle
- **Handle errors properly**: Don't ignore errors

### Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect meaning (formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to build process or auxiliary tools

**Examples:**

```
feat: add package search history
fix: resolve installation timeout on slow connections
docs: update installation instructions for ARM64
style: format code according to gofmt
refactor: extract winget operations to separate package
test: add unit tests for interactive search
chore: update dependencies to latest versions
```

### Pull Request Process

1. **Update documentation** if you're changing functionality
2. **Add or update tests** for new features
3. **Update README.md** if adding new commands or changing usage
4. **Test on Windows** - primary target platform
5. **Keep PRs focused** - one feature/fix per PR
6. **Write clear PR description** - what, why, and how

### PR Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing

- [ ] Tests pass locally
- [ ] Manual testing completed
- [ ] New tests added for new functionality

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added to hard-to-understand areas
- [ ] Documentation updated
- [ ] No new warnings introduced
```

## 🐛 Bug Reports

When reporting bugs, include:

### System Information

```
- OS: Windows 11 22H2
- PowerShell: 7.3.0
- Go: 1.24.0 (if building from source)
- uget version: 1.0.0
- winget version: 1.4.10173
```

### Bug Description

- **What happened?** - Clear description of the bug
- **What did you expect?** - Expected behavior
- **Steps to reproduce** - Detailed steps
- **Error messages** - Full error output
- **Screenshots** - If applicable

### Example Bug Report

```markdown
## Bug Description

uget fails to install packages with spaces in names

## Steps to Reproduce

1. Run `uget install "Visual Studio Code"`
2. Application crashes with error

## Expected Behavior

Should install Visual Studio Code successfully

## Actual Behavior

Application crashes with: `panic: index out of range`

## System Information

- OS: Windows 11 22H2
- uget version: 1.0.0
- winget version: 1.4.10173

## Error Output
```

panic: index out of range [1] with length 1
at uget/cmd.Install:25

```

```

## ✨ Feature Requests

When requesting features:

1. **Describe the problem** - What current limitation are you facing?
2. **Propose a solution** - How would you like it to work?
3. **Consider alternatives** - Other ways to solve the problem?
4. **Provide examples** - How would users interact with it?

### Example Feature Request

````markdown
## Problem

Currently, there's no way to see update history for packages

## Proposed Solution

Add a `uget history` command that shows:

- Recently installed packages
- Recently updated packages
- Installation/update timestamps

## Usage Example

```bash
uget history               # Show all history
uget history --installs    # Show only installations
uget history --updates     # Show only updates
uget history --days 7      # Show last 7 days
```
````

## Alternative Solutions

- Integration with winget's built-in logging
- Simple file-based history tracking

```

## 📚 Documentation

### Types of Documentation

1. **Code comments** - For complex logic
2. **README.md** - Main user documentation
3. **Command help** - Built into CLI (`--help`)
4. **Contributing.md** - This file
5. **Examples** - In README and help text

### Documentation Standards

- **Clear and concise** - Easy to understand
- **Examples included** - Show real usage
- **Up to date** - Match current functionality
- **Platform specific** - Note Windows-specific requirements

## 🔄 Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality (backward compatible)
- **PATCH** version for backward compatible bug fixes

### Release Checklist

1. Update version numbers
2. Update CHANGELOG.md
3. Test on clean Windows system
4. Create GitHub release
5. Update installation scripts
6. Announce on relevant channels

## 🤝 Community

### Communication Channels

- **GitHub Issues** - Bug reports and feature requests
- **GitHub Discussions** - General questions and ideas
- **Pull Requests** - Code contributions

### Code of Conduct

Be respectful, inclusive, and constructive. We want uget to be a welcoming project for contributors of all backgrounds and experience levels.

## ❓ Getting Help

If you need help:

1. **Check existing documentation** - README, help commands
2. **Search existing issues** - Your question might be answered
3. **Ask in GitHub Discussions** - For general questions
4. **Create an issue** - For specific problems

## 🎉 Recognition

Contributors will be:
- Listed in README.md acknowledgments
- Mentioned in release notes for significant contributions
- Invited to be maintainers for substantial ongoing contributions

Thank you for contributing to uget! 🚀
```
