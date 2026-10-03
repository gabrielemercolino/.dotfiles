package nix

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"

	. "github.com/gabrielemercolino/gab/internals/helpers"
)

var nixpkgsURLRe = regexp.MustCompile(`nixpkgs\.url\s*=\s*"([^"]+)"`)
var nixpkgsInlineURLRe = regexp.MustCompile(`(?s)nixpkgs\s*=\s*\{[^}]*?url\s*=\s*"([^"]+)"`)
var nixpkgsPinRe = regexp.MustCompile(`nixpkgs/([^";]+)`)

type Flake struct {
	Path string
}

func (f Flake) NixpkgsURL() (string, error) {
	content, err := os.ReadFile(f.Path)
	if err != nil {
		return "", err
	}
	if m := nixpkgsURLRe.FindSubmatch(content); m != nil {
		return string(m[1]), nil
	}
	if m := nixpkgsInlineURLRe.FindSubmatch(content); m != nil {
		return string(m[1]), nil
	}
	return "", fmt.Errorf("could not detect nixpkgs.url in %s", f.Path)
}

func (f Flake) NixpkgsPin() string {
	content := Must(os.ReadFile(f.Path))
	matches := nixpkgsPinRe.FindSubmatch(content)
	if matches == nil {
		return ""
	}
	return string(matches[1])
}

func (f Flake) UpdateNixpkgsURL(oldURL, newURL string) error {
	if oldURL == newURL {
		fmt.Printf("nixpkgs already up to date (%s)\n", newURL)
		return nil
	}

	fmt.Println("current:", oldURL)
	fmt.Println("latest: ", newURL)

	fmt.Print("Update nixpkgs in ", f.Path, "? [y/N] ")
	reader := bufio.NewReader(os.Stdin)
	answer, _ := reader.ReadString('\n')
	if strings.ToLower(strings.TrimSpace(answer)) != "y" {
		return nil
	}

	content, err := os.ReadFile(f.Path)
	if err != nil {
		return err
	}
	if !strings.Contains(string(content), oldURL) {
		return fmt.Errorf("could not find nixpkgs url %q in %s", oldURL, f.Path)
	}
	updated := strings.Replace(string(content), oldURL, newURL, 1)
	return os.WriteFile(f.Path, []byte(updated), 0644)
}
