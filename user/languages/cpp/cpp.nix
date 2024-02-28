{ ... }:

{
	imports = [
		#./clang.nix
		./gcc.nix
		./meson.nix
		./cmake.nix
		./pkg_config.nix

		./development_libs.nix
	];
}