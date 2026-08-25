package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/gabrielemercolino/gab/internals"
	"github.com/spf13/cobra"
)

// command
var update = &cobra.Command{
	Use:   "update",
	Short: "Executes 'nix flake update' and updates nixpkgs hash",
	RunE: func(cmd *cobra.Command, args []string) error {
		dotfilesDir := internals.Must(internals.ResolveDotfilesDir())
		dotfilesFlake := filepath.Join(dotfilesDir, "flake.nix")

		// Skip if flake.nix is not in the cwd
		if !internals.Exists("flake.nix") {
			fmt.Println("no flake.nix found, nothing more to update")
			return nil
		}

		// Phase 1: basic update
		internals.Check(internals.Run("nix flake update"))

		// Phase 2: retrieve the nixpkgs hash from the dotfiles flake
		if !internals.Exists(dotfilesFlake) {
			return fmt.Errorf("%s not found", dotfilesFlake)
		}

		cwd := internals.Must(os.Getwd())

		// if the cwd is the dotfiles' one then we should check for an update
		// oterwise check if the nixpkgs hash in the current flake matches the dotfiles'
		same := internals.Must(internals.SameFile(cwd, dotfilesDir))

		if same {
			rev := internals.Must(internals.FetchLatestRev())
			return internals.UpdateNixpkgsPin(dotfilesFlake, rev)
		}

		reference := internals.Must(internals.ExtractNixpkgsPin(dotfilesFlake))
		if reference == "" {
			return fmt.Errorf("could not determine target nixpkgs rev")
		}
		return internals.UpdateNixpkgsPin("flake.nix", reference)
	},
}

func init() {
	rootCmd.AddCommand(update)
}
