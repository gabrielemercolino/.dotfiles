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
		same := Must(files.SameFile(cwd, dotfilesDir))

		target := "flake.nix"
		branch := nix.UnstableNixpkgs
		if same {
			target = dotfilesFlake
			branch = nix.UnstableNixos
		}

		flake := nix.Flake{Path: target}
		url := Must(flake.NixpkgsURL())
		ref := Must(nix.ParseNixpkgsRef(url))

		rev := ref.LatestRev(branch)
		if err := flake.UpdateNixpkgsURL(url, ref.Pin(rev)); err != nil {
			return err
		}

		// Phase 2: update the remaining flake inputs
		Check(cli.Run("nix flake update --accept-flake-config"))

		return nil
	},
}

func init() {
	rootCmd.AddCommand(update)
}
