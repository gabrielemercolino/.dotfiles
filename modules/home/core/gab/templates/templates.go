package templates

import _ "embed"

//go:embed flake.nix.tpl
var FlakeTemplate string

//go:embed .envrc.tpl
var EnvrcTemplate string
