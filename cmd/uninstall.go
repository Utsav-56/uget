/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"uget/uget"

	"github.com/spf13/cobra"
)

// uninstallCmd represents the uninstall command
var uninstallCmd = &cobra.Command{
	Use:     "uninstall <package>",
	Aliases: []string{"del", "remove", "rm"},
	Short:   "Uninstall a package using winget",
	Long: `Uninstall a package that was previously installed through winget.
This command will remove the specified package from your system.

You can specify the package name, ID, or a partial match. The command
will attempt to find and uninstall the package.

Examples:
  uget uninstall chrome         # Uninstall Google Chrome
  uget uninstall "Visual Studio Code"  # Uninstall VS Code
  uget remove firefox           # Alternative: remove Firefox
  uget del vlc                  # Alternative: delete VLC
  uget rm notepad++             # Alternative: remove Notepad++`,
	Args: cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		uget.Uninstall(args[0])
	},
}

func init() {
	rootCmd.AddCommand(uninstallCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// uninstallCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// uninstallCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
