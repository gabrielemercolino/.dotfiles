package cmd

import (
	"fmt"

	"github.com/gabrielemercolino/gab/internals/cli"
	"github.com/gabrielemercolino/gab/internals/files"
	. "github.com/gabrielemercolino/gab/internals/helpers"
	"github.com/spf13/cobra"
)

// flags
var profile string

// command
var sync = &cobra.Command{
	Use:   "sync",
	Short: "Synchronizes the system based on the config",
	RunE: func(cmd *cobra.Command, args []string) error {
		dotfilesDir := Must(files.ResolveDotfilesDir())

		// System sync
		command := fmt.Sprintf("nh os switch %s -H '%s'", dotfilesDir, profile)
		Check(cli.Run(command))

		// Home-manager sync
		command = fmt.Sprintf("nh home switch ~/.dotfiles -c '%s'", profile)
		return cli.Run(command)
	},
}

func init() {
	sync.Flags().StringVarP(&profile, "profile", "p", "", "the profile to use")
	sync.MarkFlagRequired("profile")
	rootCmd.AddCommand(sync)
}
