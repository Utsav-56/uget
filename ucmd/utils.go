package ucmd

import (
	"os"
	"os/exec"
	"strings"
	"uget/ucmd/win"
)

// Exists checks if a given command exists in PATH
func Exists(command string) bool {
	_, err := exec.LookPath(command)
	return err == nil
}

// ExistsAll checks if all given commands exist.
// Returns (true, nil) if all exist, or (false, []missingOnes) otherwise.
func ExistsAll(commands ...string) (bool, []string) {
	var missing []string
	for _, cmd := range commands {
		if !Exists(cmd) {
			missing = append(missing, cmd)
		}
	}
	return len(missing) == 0, missing
}

// FileExists checks if a file/directory exists at the given path
func FileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

// AddToPath appends a directory to PATH (temporary, process-wide only).
// Returns true if successful.
func AddToPath(path string) bool {
	if path == "" {
		return false
	}
	cur := os.Getenv("PATH")
	if !strings.Contains(cur, path) {
		return os.Setenv("PATH", path+string(os.PathListSeparator)+cur) == nil
	}
	return true
}

// RemoveFromPath removes a directory from PATH (process-wide only).
func RemoveFromPath(path string) bool {
	if path == "" {
		return false
	}
	parts := strings.Split(os.Getenv("PATH"), string(os.PathListSeparator))
	var newParts []string
	for _, p := range parts {
		if strings.TrimSpace(p) != path {
			newParts = append(newParts, p)
		}
	}
	return os.Setenv("PATH", strings.Join(newParts, string(os.PathListSeparator))) == nil
}

func WingetPath() string {
	appdata := win.GetLocalAppDataPath()

	return appdata + "\\Microsoft\\WindowsApps\\winget.exe"

}
