package nix

import (
	"encoding/json"
	"fmt"
	"net/url"
	"regexp"
	"strings"

	"github.com/gabrielemercolino/gab/internals/cli"
	. "github.com/gabrielemercolino/gab/internals/helpers"
)

const (
	UnstableNixos   = "nixos-unstable"
	UnstableNixpkgs = "nixpkgs-unstable"
)

var (
	githubRe    = regexp.MustCompile(`^(github|gitlab):([^/?#]+)/([^/?#]+)(?:/([^?#]*))?(?:\?(.*))?$`)
	githubComRe = regexp.MustCompile(`^github\.com/([^/?#]+)/([^/?#]+)(?:/([^?#]*))?(?:\?(.*))?$`)
	indirectRe  = regexp.MustCompile(`^([A-Za-z0-9._-]+)(?:/([^?#]+))?$`)
)

type Kind string

const (
	indirect Kind = "indirect"
	github   Kind = "github"
	gitlab   Kind = "gitlab"
	git      Kind = "git"
)

type NixpkgsRef struct {
	kind  Kind
	id    string
	owner string
	repo  string
	query string // raw query without leading '?'
	u     *url.URL
}

func ParseNixpkgsRef(rawRef string) (*NixpkgsRef, error) {
	if strings.HasPrefix(rawRef, "git+") {
		u, err := url.Parse(rawRef)
		if err != nil {
			return nil, err
		}
		return &NixpkgsRef{kind: git, u: u}, nil
	}

	if m := githubRe.FindStringSubmatch(rawRef); m != nil {
		return &NixpkgsRef{
			kind:  Kind(m[1]),
			owner: m[2],
			repo:  m[3],
			query: m[5],
		}, nil
	}

	if m := githubComRe.FindStringSubmatch(rawRef); m != nil {
		return &NixpkgsRef{
			kind:  github,
			owner: m[1],
			repo:  m[2],
			query: m[4],
		}, nil
	}

	if m := indirectRe.FindStringSubmatch(rawRef); m != nil {
		return &NixpkgsRef{kind: indirect, id: m[1]}, nil
	}

	return nil, fmt.Errorf("unsupported nixpkgs url: %s", rawRef)
}

func (r *NixpkgsRef) UnstableRef(branch string) string { return r.withRef(branch) }
func (r *NixpkgsRef) Pin(rev string) string            { return r.withRef(rev) }

func (r *NixpkgsRef) LatestRev(branch string) string {
	flakeRef := r.UnstableRef(branch)
	queryRef := flakeRef
	if strings.HasPrefix(flakeRef, "git+") {
		queryRef = appendQueryParam(flakeRef, "shallow", "1")
	}
	fmt.Printf("fetching latest nixpkgs rev from %s...\n", queryRef)
	result := Must(cli.RunWithOutput(fmt.Sprintf("nix flake metadata '%s' --json", queryRef)))

	var meta struct {
		Locked struct {
			Rev string `json:"rev"`
			URL string `json:"url"`
		} `json:"locked"`
	}
	Check(json.Unmarshal([]byte(result.Stdout), &meta))

	rev := meta.Locked.Rev
	if rev == "" && meta.Locked.URL != "" {
		if u, err := url.Parse(meta.Locked.URL); err == nil {
			rev = u.Query().Get("rev")
		}
	}
	if rev == "" {
		Check(fmt.Errorf("could not determine nixpkgs rev from %s", flakeRef))
	}
	return rev
}

func (r *NixpkgsRef) withRef(ref string) string {
	switch r.kind {
	case indirect:
		return r.id + "/" + ref
	case github, gitlab:
		return fmt.Sprintf("%s:%s/%s/%s%s", r.kind, r.owner, r.repo, ref, querySuffix(r.query))
	case git:
		u := *r.u
		q := u.Query()
		q.Del("rev")
		q.Set("ref", ref)
		u.RawQuery = q.Encode()
		return u.String()
	}
	return ""
}

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

func querySuffix(query string) string {
	if query == "" {
		return ""
	}
	return "?" + query
}
