package cli

import (
	"bytes"
	"os"
	"os/exec"
)

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

type Output struct {
	Stdout string
	Stderr string
}

func RunWithOutput(command string) (Output, error) {
	var stdout, stderr bytes.Buffer

	c := exec.Command("sh", "-c", command)
	c.Stdout = &stdout
	c.Stderr = &stderr

	err := c.Run()
	return Output{
		Stdout: stdout.String(),
		Stderr: stderr.String(),
	}, err
}
