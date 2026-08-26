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

		// Phase 1: basic update
		Check(cli.Run("nix flake update"))

		// Phase 2: retrieve the nixpkgs hash from the dotfiles flake
		if !files.Exists(dotfilesFlake) {
			return fmt.Errorf("%s not found", dotfilesFlake)
		}

		cwd := Must(os.Getwd())

		// if the cwd is the dotfiles' one then we should check for an update
		// oterwise check if the nixpkgs hash in the current flake matches the dotfiles'
		same := Must(files.SameFile(cwd, dotfilesDir))

		if same {
			rev := nix.FetchLatestRev()
			return nix.UpdateNixpkgsPin(dotfilesFlake, rev)
		}

		reference := nix.ExtractNixpkgsPin(dotfilesFlake)
		return nix.UpdateNixpkgsPin("flake.nix", reference)
	},
}

func init() {
	rootCmd.AddCommand(update)
}
