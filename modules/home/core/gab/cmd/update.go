package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/gabrielemercolino/gab/internals/cli"
	"github.com/gabrielemercolino/gab/internals/files"
	. "github.com/gabrielemercolino/gab/internals/helpers"
	"github.com/gabrielemercolino/gab/internals/nix"
	"github.com/spf13/cobra"
)

// command
var update = &cobra.Command{
	Use:   "update",
	Short: "Executes 'nix flake update' and updates nixpkgs hash",
	RunE: func(cmd *cobra.Command, args []string) error {
		dotfilesDir := Must(files.ResolveDotfilesDir())
		dotfilesFlake := filepath.Join(dotfilesDir, "flake.nix")

		// Skip if flake.nix is not in the cwd
		if !files.Exists("flake.nix") {
			fmt.Println("no flake.nix found, nothing more to update")
			return nil
		}

		if !files.Exists(dotfilesFlake) {
			return fmt.Errorf("%s not found", dotfilesFlake)
		}

		cwd := Must(os.Getwd())

		// if the cwd is the dotfiles' one then we should check for an update
		// oterwise check if the nixpkgs hash in the current flake matches the dotfiles'
		same := Must(files.SameFile(cwd, dotfilesDir))

		// Phase 1: update the nixpkgs pin
		if same {
			rev := nix.FetchLatestRev()
			if err := nix.UpdateNixpkgsPin(dotfilesFlake, rev); err != nil {
				return err
			}
		} else {
			reference := nix.ExtractNixpkgsPin(dotfilesFlake)
			if err := nix.UpdateNixpkgsPin("flake.nix", reference); err != nil {
				return err
			}
		}

		// Phase 2: update the remaining flake inputs
		Check(cli.Run("nix flake update --accept-flake-config"))

		return nil
	},
}

func init() {
	rootCmd.AddCommand(update)
}
