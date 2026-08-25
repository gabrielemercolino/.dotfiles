package files

import (
	"fmt"
	"os"
	"path/filepath"
)

func Exists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
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
