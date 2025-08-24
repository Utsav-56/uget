/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"uget/uget"

	"github.com/spf13/cobra"
)

// siCmd represents the si command
var siCmd = &cobra.Command{
	Use:     "si [query]",
	Aliases: []string{"search", "find"},
	Short:   "Interactive search and install packages",
	Long: `Search for packages interactively using fuzzy finding (fzf).
This command provides an interactive interface to search through available
packages and optionally install the selected package.

When called without arguments, it shows all available packages.
When called with a search query, it filters packages matching the query.
After selecting a package from the interactive list, you can choose to install it.

Requirements:
  This command requires 'fzf' (fuzzy finder) to be installed.
  If not found, uget will attempt to install it automatically.

Examples:
  uget si                       # Browse all packages interactively
  uget si chrome                # Search for Chrome-related packages
  uget search editor            # Search for text editors
  uget find media               # Find media-related applications`,
	Args: cobra.MaximumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {

		println("")
		CheckRequirements()

		query := ""
		if len(args) == 1 {
			query = args[0]
		}
		install := true // do query !== "" if need like that // install only when an arg was provided
		return uget.SearchInteractive(query, install)
	},
}

func init() {
	rootCmd.AddCommand(siCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// siCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// siCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// func si(cmd *cobra.Command, args []string) {
// 	if len(args) > 0 {
// 		// si <pkg> → search+install
// 		uget.SearchInteractive(args[0], true)
// 	} else {
// 		// si → only search, no install
// 		uget.SearchInteractive("", false)
// 	}
// }
