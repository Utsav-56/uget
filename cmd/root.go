/*
Copyright © 2025 utsav-56
*/
package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "uget",
	Short: "A user-friendly wrapper for Windows Package Manager (winget)",
	Long: `uget is a command-line tool that provides an enhanced interface for Windows Package Manager (winget).
It offers interactive search capabilities, simplified commands, and improved user experience for managing
Windows applications through winget.

Features:
  • Interactive package search with fuzzy finding
  • Simplified install, uninstall, and upgrade commands
  • Automatic dependency checking and installation
  • Enhanced search and discovery capabilities

Examples:
  uget si chrome          # Search and install Chrome interactively
  uget install firefox    # Install Firefox directly
  uget upgrade            # Upgrade all packages
  uget uninstall vlc      # Uninstall VLC media player`,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: run,
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {

	if !CheckWinget() {
		println("Winget is necessary for this script to run.")
		println("Winget should come pre-installed with Windows.")
		println("Unfortunately your system does not have Winget installed, you can install it from the official Microsoft website.")
		return
	}

	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}

}

func init() {
	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.

	// Add -? as an alias for -h (help)
	rootCmd.PersistentFlags().BoolP("help", "?", false, "help for "+rootCmd.Name())

	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.uget.yaml)")

	// Cobra also supports local flags, which will only run
	// when this action is called directly.

}

// func run(cmd *cobra.Command, args []string) {

// }
