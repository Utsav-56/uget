/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"uget/uget"

	"github.com/spf13/cobra"
)

// installCmd represents the install command
var installCmd = &cobra.Command{
	Use:     "install <package>",
	Aliases: []string{"i"},
	Short:   "Install a package using winget",
	Long: `Install a package from the Windows Package Manager repository.
This command searches for the specified package and installs it using winget.

You can specify the package name, ID, or search query. The command will
attempt to find and install the best match for your query.

Examples:
  uget install chrome           # Install Google Chrome
  uget install "Visual Studio Code"  # Install VS Code (use quotes for multi-word names)
  uget install Microsoft.VisualStudioCode  # Install using exact package ID
  uget i firefox               # Short form: install Firefox`,
	Args: cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		uget.Install(args[0])
	},
}

func init() {
	rootCmd.AddCommand(installCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// installCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// installCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
