package nix

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/gabrielemercolino/gab/internals/cli"
	. "github.com/gabrielemercolino/gab/internals/helpers"
)

var nixpkgsPinRe = regexp.MustCompile(`nixpkgs/([^";]+)`)

const defaultNixpkgsFlake = "github:nixos/nixpkgs/nixpkgs-unstable"

func appendQueryParam(query, key, value string) string {
	if strings.Contains(query, key+"=") {
		return query
	}
	sep := "?"
	if strings.Contains(query, "?") {
		sep = "&"
	}
	return query + sep + key + "=" + value
}

func ResolveNixpkgsFlake() string {
	flake := defaultNixpkgsFlake
	if v, ok := os.LookupEnv("NIXPKGS_FLAKE"); ok && v != "" {
		flake = v
	}
	if strings.HasPrefix(flake, "git+") {
		flake = appendQueryParam(flake, "shallow", "1")
	}
	return flake
}

func FetchLatestRev() string {
	flake := ResolveNixpkgsFlake()
	fmt.Printf("fetching latest nixpkgs rev from %s...\n", flake)
	result := Must(cli.RunWithOutput(fmt.Sprintf("nix flake metadata '%s' --json", flake)))
	var meta struct {
		Locked struct {
			Rev string `json:"rev"`
		} `json:"locked"`
	}
	Check(json.Unmarshal([]byte(result.Stdout), &meta))
	return meta.Locked.Rev
}

func ExtractNixpkgsPin(path string) string {
	content := Must(os.ReadFile(path))
	matches := nixpkgsPinRe.FindSubmatch(content)
	if matches == nil {
		return ""
	}
	return string(matches[1])
}

func UpdateNixpkgsPin(target, newHash string) error {
	currentPin := ExtractNixpkgsPin(target)
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
		content := Must(os.ReadFile(target))
		updated := strings.Replace(string(content), "nixpkgs/"+currentPin, "nixpkgs/"+newHash, 1)
		Check(os.WriteFile(target, []byte(updated), 0644))
		fmt.Println("updated nixpkgs pin in", target)
	}
	return nil
}
