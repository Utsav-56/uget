package main

import (
	"strings"
	"uget/ucmd"
	"uget/uget"
)

func CheckWinget() bool {
	if !ucmd.Exists("winget") {
		if ucmd.FileExists(ucmd.WingetPath()) {
			println("Winget is installed but not in PATH.")
			ucmd.AddToPath(ucmd.WingetPath())
		}
	}

	return ucmd.Exists("winget")
}

func CheckRequirements() bool {
	requiredPackages := []string{"fzf"}

	exists, missing := ucmd.ExistsAll(requiredPackages...)
	if !exists {
		println("Uget relies on the following packages: ")
		println("Missing packages: " + strings.Join(missing, ", "))

		installMissingPackages(missing)

		return false
	}

	return true

}

func installMissingPackages(missing []string) {

	println("\n\n Installing missing packages...")

	for _, pkg := range missing {
		println("Installing " + pkg + "...")
		uget.Install(pkg)
	}
}
