{ config, pkgs, ... }:

{
	imports = [
		cpp/meson.nix
		cpp/gcc.nix
		java/jdk.nix
	];
}