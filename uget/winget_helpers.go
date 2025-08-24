package uget

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// func SearchInteractive(pkg string, install bool) {
// 	args := []string{"search"}
// 	if pkg != "" {
// 		args = append(args, "--query", pkg)
// 	} else {
// 		// empty query should still be passed explicitly, avoids panic
// 		args = append(args, "--query", "")
// 	}

// 	// Run winget search
// 	wingetCmd := exec.Command("winget", args...)
// 	fzfCmd := exec.Command("fzf")

// 	// Pipe winget → fzf
// 	pipe, err := wingetCmd.StdoutPipe()
// 	if err != nil {
// 		fmt.Println("Error creating pipe:", err)
// 		return
// 	}
// 	fzfCmd.Stdin = pipe

// 	outBytes := &strings.Builder{}
// 	fzfCmd.Stdout = outBytes
// 	fzfCmd.Stderr = os.Stderr
// 	wingetCmd.Stderr = os.Stderr

// 	// Start both processes
// 	if err := wingetCmd.Start(); err != nil {
// 		fmt.Println("Error starting winget:", err)
// 		return
// 	}
// 	if err := fzfCmd.Run(); err != nil {
// 		fmt.Println("fzf canceled or failed")
// 		return
// 	}
// 	wingetCmd.Wait()

// 	// Parse selected output
// 	out := strings.TrimSpace(outBytes.String())
// 	if out == "" {
// 		fmt.Println("No package selected. Cancelled.")
// 		return
// 	}

// 	println(" =========== Selection ===========")
// 	println(out)
// 	println("=================================== \n")

// 	// Extract ID safely (PowerShell used .Split()[1])
// 	fields := strings.Fields(out)
// 	if len(fields) < 2 {
// 		fmt.Println("Could not parse package ID from:", out)
// 		return
// 	}
// 	id := fields[1]

// 	fmt.Println("Selected package ID:", id)

// 	// If install is true → run install
// 	if install {
// 		Install(id)
// 	}
// }

func Search(pkg string) {
	args := []string{"search"}
	if pkg != "" {
		args = append(args, pkg)
	}
	runCommand("winget", args...)
}

func Upgrade(pkg string) {
	args := []string{"upgrade"}
	if pkg != "" {
		args = append(args, pkg)
	}
	runCommand("winget", args...)
}

func Uninstall(pkg string) {
	args := []string{"uninstall", pkg}
	runCommand("winget", args...)
}

func Install(pkg string) {

	// Custom args for silent and no agreement installs
	args := []string{"install", pkg}

	args = append(args, "--silent", "--accept-source-agreements", "--accept-package-agreements")
	runCommand("winget", args...)
}

func runCommand(name string, args ...string) {

	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	cmd.Run()

	// if err := cmd.Run(); err != nil {
	// 	fmt.Printf("Error running %s: %v\n", name, err)
	// 	os.Exit(1)
	// }
}

// --- helpers ---

func run(name string, args ...string) error {
	c := exec.Command(name, args...)
	c.Stdout, c.Stderr, c.Stdin = os.Stdout, os.Stderr, os.Stdin
	return c.Run()
}

func ugetInstall(id string) error {
	if id == "" {
		return errors.New("empty package id")
	}
	// include agreement flags so it won't prompt
	return run("winget", "install", id,
		"--accept-source-agreements", "--accept-package-agreements")
}

// Parse a single selected row from `winget search` default table.
// The table columns are: Name  Id  Version  Source
// We extract Id = fields[len-3].
func parseWingetIDFromLine(line string) (string, error) {
	line = strings.TrimSpace(line)
	if line == "" {
		return "", errors.New("empty selection")
	}
	// skip separators/headers that fzf could return
	l := strings.ToLower(line)
	if strings.Contains(l, "name") && strings.Contains(l, "version") && strings.Contains(l, "source") {
		return "", errors.New("header selected")
	}
	if strings.HasPrefix(line, "—") || strings.HasPrefix(line, "-") || strings.HasPrefix(line, "=") {
		return "", errors.New("separator selected")
	}

	fields := strings.Fields(line)
	if len(fields) < 3 {
		return "", fmt.Errorf("cannot parse id from line: %q", line)
	}

	// fields: [...NameTokens..., Id, Version, Source]
	id := fields[len(fields)-3]
	return id, nil
}

// Runs `winget search --query <q> | fzf`,
// extracts Id reliably, and installs iff install==true.
func SearchInteractive(query string, install bool) error {
	// Always use --query (even if empty) to avoid winget throwing on empty args.
	args := []string{"search", "--query", query}

	winget := exec.Command("winget", args...)
	fzf := exec.Command("fzf")

	// Pipe winget -> fzf
	stdoutPipe, err := winget.StdoutPipe()
	if err != nil {
		return fmt.Errorf("stdout pipe: %w", err)
	}
	fzf.Stdin = stdoutPipe

	var fzfOut bytes.Buffer
	fzf.Stdout = &fzfOut
	winget.Stderr = os.Stderr
	fzf.Stderr = os.Stderr

	if err := winget.Start(); err != nil {
		return fmt.Errorf("start winget: %w", err)
	}
	if err := fzf.Run(); err != nil {
		// user likely hit ESC / canceled
		// return errors.New("no selection (fzf canceled)")
		return nil
	}
	_ = winget.Wait()

	selected := strings.TrimSpace(fzfOut.String())
	if selected == "" {
		return errors.New("no selection")
	}

	id, err := parseWingetIDFromLine(selected)
	if err != nil {
		return err
	}

	fmt.Println("Selected package ID:", id)

	if install {
		if err := ugetInstall(id); err != nil {
			// return fmt.Errorf("install %s: %w", id, err)
		}
	}
	return nil
}
