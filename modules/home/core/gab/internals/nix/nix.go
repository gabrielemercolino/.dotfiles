package nix

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

var nixpkgsPinRe = regexp.MustCompile(`nixpkgs/([^";]+)`)

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
