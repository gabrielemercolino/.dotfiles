package internals

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

var nixpkgsPinRe = regexp.MustCompile(`nixpkgs/([^";]+)`)

func Run(command string) error {
	c := exec.Command("sh", "-c", command)
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr

	// Uses the command error code if it fails
	if err := c.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			os.Exit(exitErr.ExitCode())
		}
		return err
	}
	return nil
}

func Exists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func Must[T any](val T, err error) T {
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	return val
}

func Check(err error) {
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
}

func ResolveDotfilesDir() (string, error) {
	if dir, ok := os.LookupEnv("DOTFILES_DIR"); ok {
		return dir, nil
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	dir := filepath.Join(home, ".dotfiles")
	fmt.Fprintln(os.Stderr, "warning: DOTFILES_DIR undefined, using:", dir)
	return dir, nil
}

func ExtractNixpkgsPin(path string) (string, error) {
	content, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	m := nixpkgsPinRe.FindSubmatch(content)
	if m == nil {
		return "", nil
	}
	return string(m[1]), nil
}

func FetchLatestRev() (string, error) {
	fmt.Println("fetching latest nixpkgs rev...")
	out, err := exec.Command("nix", "flake", "metadata", "github:nixos/nixpkgs/nixpkgs-unstable", "--json").Output()
	if err != nil {
		return "", err
	}
	var meta struct {
		Locked struct {
			Rev string `json:"rev"`
		} `json:"locked"`
	}
	if err := json.Unmarshal(out, &meta); err != nil {
		return "", err
	}
	return meta.Locked.Rev, nil
}

func UpdateNixpkgsPin(target, newHash string) error {
	currentPin, err := ExtractNixpkgsPin(target)
	if err != nil {
		return err
	}
	if currentPin == "" {
		return fmt.Errorf("could not detect nixpkgs url in %s", target)
	}

	if currentPin == newHash {
		fmt.Printf("nixpkgs already up to date (%s)\n", newHash)
		return nil
	}

	fmt.Println("current:", currentPin)
	fmt.Println("latest: ", newHash)

	fmt.Print("Update nixpkgs in ", target, "? [y/N] ")
	reader := bufio.NewReader(os.Stdin)
	answer, _ := reader.ReadString('\n')
	if strings.ToLower(strings.TrimSpace(answer)) == "y" {
		content, err := os.ReadFile(target)
		if err != nil {
			return err
		}
		updated := strings.Replace(string(content), "nixpkgs/"+currentPin, "nixpkgs/"+newHash, 1)
		if err := os.WriteFile(target, []byte(updated), 0644); err != nil {
			return err
		}
		fmt.Println("updated nixpkgs pin in", target)
	}
	return nil
}

func SameFile(a, b string) (bool, error) {
	infoA, err := os.Stat(a)
	if err != nil {
		return false, err
	}
	infoB, err := os.Stat(b)
	if err != nil {
		return false, err
	}
	return os.SameFile(infoA, infoB), nil
}
