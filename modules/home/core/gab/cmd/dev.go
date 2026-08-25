package cmd

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/gabrielemercolino/gab/internals/files"
	. "github.com/gabrielemercolino/gab/internals/helpers"
	"github.com/gabrielemercolino/gab/internals/nix"
	"github.com/gabrielemercolino/gab/templates"
	"github.com/spf13/cobra"
)

// command
var dev = &cobra.Command{
	Use:   "dev",
	Short: "Creates a flake.nix and .envrc for a dev env",
	RunE: func(cmd *cobra.Command, args []string) error {
		dotfilesDir := Must(files.ResolveDotfilesDir())
		dotfilesFlake := filepath.Join(dotfilesDir, "flake.nix")

		cwd := Must(os.Getwd())
		home := Must(os.UserCacheDir())

		same := Must(files.SameFile(cwd, home))
		if same {
			return fmt.Errorf("refusing to run in $HOME")
		}

		if !files.Exists(dotfilesFlake) {
			return fmt.Errorf("%s not found", dotfilesFlake)
		}

		storedHash := Must(nix.ExtractNixpkgsPin(dotfilesFlake))
		if storedHash == "" {
			return fmt.Errorf("could not detect nixpkgs url in %s", dotfilesFlake)
		}

		fmt.Println("using nixpkgs rev:", storedHash)

		devFlake := strings.ReplaceAll(templates.FlakeTemplate, "{{NIXPKGS_REV}}", storedHash)
		Check(createIfAllowed("flake.nix", devFlake))
		Check(createIfAllowed(".envrc", templates.EnvrcTemplate))

		fmt.Println()
		fmt.Println("Dev env ready")
		return nil
	},
}

func init() {
	rootCmd.AddCommand(dev)
}

func confirmOverwrite(path string) bool {
	if _, err := os.Stat(path); os.IsNotExist(err) {
		return true
	}
	fmt.Printf("'%s' already present, override? [y/N] ", path)
	reader := bufio.NewReader(os.Stdin)
	answer, _ := reader.ReadString('\n')
	return strings.ToLower(strings.TrimSpace(answer)) == "y"
}

func createIfAllowed(path, content string) error {
	if !confirmOverwrite(path) {
		fmt.Println("skipping", path)
		return nil
	}
	fmt.Println("creating", path)
	return os.WriteFile(path, []byte(content), 0644)
}
