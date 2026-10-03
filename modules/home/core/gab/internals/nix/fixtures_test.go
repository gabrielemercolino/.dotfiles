package nix_test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gabrielemercolino/gab/internals/nix"
)

func TestNixpkgsDetectionFixtures(t *testing.T) {
	cases := []struct {
		name     string
		url      string
		unstable string
		pin      string
	}{
		{"indirect_branch", "nixpkgs/nixos-unstable", "nixpkgs/nixos-unstable", "nixpkgs/deadbeef"},
		{"indirect_pinned", "nixpkgs/b6c8664de9b6cc07fe5666a29f91884ba81197c4", "nixpkgs/nixos-unstable", "nixpkgs/deadbeef"},
		{"indirect_bare", "nixpkgs", "nixpkgs/nixos-unstable", "nixpkgs/deadbeef"},
		{"github_branch", "github:nixos/nixpkgs/nixos-unstable", "github:nixos/nixpkgs/nixos-unstable", "github:nixos/nixpkgs/deadbeef"},
		{"github_pinned", "github:nixos/nixpkgs/b6c8664de9b6cc07fe5666a29f91884ba81197c4", "github:nixos/nixpkgs/nixos-unstable", "github:nixos/nixpkgs/deadbeef"},
		{"github_bare", "github:nixos/nixpkgs", "github:nixos/nixpkgs/nixos-unstable", "github:nixos/nixpkgs/deadbeef"},
		{"github_dot_com", "github.com/nixos/nixpkgs/nixos-unstable", "github:nixos/nixpkgs/nixos-unstable", "github:nixos/nixpkgs/deadbeef"},
		{"gitlab_branch", "gitlab:owner/repo/nixos-unstable", "gitlab:owner/repo/nixos-unstable", "gitlab:owner/repo/deadbeef"},
		{"git_https_branch", "git+https://forgejo.example/owner/nixpkgs?ref=nixpkgs-unstable", "git+https://forgejo.example/owner/nixpkgs?ref=nixos-unstable", "git+https://forgejo.example/owner/nixpkgs?ref=deadbeef"},
		{"git_https_rev_dir", "git+https://forgejo.example/owner/nixpkgs?rev=abc123&dir=sub", "git+https://forgejo.example/owner/nixpkgs?dir=sub&ref=nixos-unstable", "git+https://forgejo.example/owner/nixpkgs?dir=sub&ref=deadbeef"},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			path := filepath.Join(t.TempDir(), "flake.nix")
			content := "{\n  inputs.nixpkgs.url = \"" + tc.url + "\";\n  outputs = _: { };\n}\n"
			if err := os.WriteFile(path, []byte(content), 0644); err != nil {
				t.Fatal(err)
			}

			gotURL, err := nix.Flake{Path: path}.NixpkgsURL()
			if err != nil {
				t.Fatal(err)
			}
			if gotURL != tc.url {
				t.Fatalf("NixpkgsURL = %q, want %q", gotURL, tc.url)
			}

			ref, err := nix.ParseNixpkgsRef(gotURL)
			if err != nil {
				t.Fatal(err)
			}
			if got := ref.UnstableRef(nix.UnstableNixos); got != tc.unstable {
				t.Fatalf("UnstableRef = %q, want %q", got, tc.unstable)
			}
			if got := ref.Pin("deadbeef"); got != tc.pin {
				t.Fatalf("Pin = %q, want %q", got, tc.pin)
			}
		})
	}
}
