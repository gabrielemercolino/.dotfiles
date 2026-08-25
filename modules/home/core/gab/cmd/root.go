package cmd

import "github.com/spf13/cobra"

var rootCmd = &cobra.Command{
	Use:   "gab",
	Short: "Utility script for managing Nix",
}

func Execute() error {
	return rootCmd.Execute()
}
