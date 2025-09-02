//go:build windows

package win

import (
	"os"
	"os/user"
	"path/filepath"
)

// GetHomeDir returns the home directory of the current user
func GetHomeDir() string {
	home, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	return home
}

// GetUsersDir is just an alias for GetHomeDir
func GetUsersDir() string {
	return GetHomeDir()
}

// GetAppDataPath returns %APPDATA% path for current user
func GetAppDataPath() string {
	return os.Getenv("APPDATA")
}

// GetLocalAppDataPath returns %LOCALAPPDATA%
func GetLocalAppDataPath() string {
	return os.Getenv("LOCALAPPDATA")
}

// GetDownloadsDir tries to return the Downloads folder for the current user
func GetDownloadsDir() string {
	home := GetHomeDir()
	if home == "" {
		return ""
	}
	return filepath.Join(home, "Downloads")
}

// GetDesktopDir returns Desktop folder for current user
func GetDesktopDir() string {
	home := GetHomeDir()
	if home == "" {
		return ""
	}
	return filepath.Join(home, "Desktop")
}

// GetCurrentUser returns the username of the current user
func GetCurrentUser() string {
	u, err := user.Current()
	if err != nil {
		return ""
	}
	return u.Username
}
