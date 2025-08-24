/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"uget/uget"

	"github.com/spf13/cobra"
)

// upgradeCmd represents the upgrade command
var upgradeCmd = &cobra.Command{
	Use:     "upgrade [package]",
	Aliases: []string{"update", "up"},
	Short:   "Upgrade packages using winget",
	Long: `Upgrade packages to their latest versions using winget.
This command can upgrade a specific package or all upgradeable packages.

When called without arguments, it will upgrade all packages that have
available updates. When called with a package name, it will upgrade
only that specific package.

Examples:
  uget upgrade                  # Upgrade all packages
  uget upgrade chrome           # Upgrade only Google Chrome
  uget update firefox           # Alternative: update Firefox
  uget up                       # Short form: upgrade all packages`,
	Args: cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		pkg := ""
		if len(args) > 0 {
			pkg = args[0]
		}
		uget.Upgrade(pkg)
	},
}

func init() {
	rootCmd.AddCommand(upgradeCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// upgradeCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// upgradeCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
