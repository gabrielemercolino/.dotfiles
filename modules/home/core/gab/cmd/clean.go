package cmd

import (
	"fmt"

	"github.com/gabrielemercolino/gab/internals"
	"github.com/spf13/cobra"
)

const BASE_CMD = "nh clean all --keep-one"

// flags
var all bool

// command
var clean = &cobra.Command{
	Use:   "clean",
	Short: "Deletes unreachable store objects and profiles older than 7 days",
	RunE: func(cmd *cobra.Command, args []string) error {
		var command string
		if !all {
			command = fmt.Sprint(BASE_CMD, " --keep-since 7d")
		} else {
			command = BASE_CMD
		}

		return internals.Run(command)
	},
}

func init() {
	clean.Flags().BoolVarP(&all, "all", "a", false, "deletes every profile except the current one")
	rootCmd.AddCommand(clean)
}
