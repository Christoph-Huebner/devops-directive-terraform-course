package test

import (
	"crypto/tls"
	"fmt"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	// retryable errors in terraform testing.
	terraformDir := "../../examples/hello-world"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: terraformDir,
	})

	// cleanupTerraformArtifacts deletes the .terraform directory and the .terraform.lock.hcl file
	// defer: LIFO principle, so this will run after the test completes.
	defer cleanupTerraformArtifacts(t, terraformDir)
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	instanceURL := terraform.Output(t, terraformOptions, "url")
	tlsConfig := tls.Config{}
	maxRetries := 30
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t, instanceURL, &tlsConfig, maxRetries, timeBetweenRetries, validate,
	)
}

func validate(status int, body string) bool {
	fmt.Println(body)
	return status == 200
}

func cleanupTerraformArtifacts(t *testing.T, dir string) {
	lockFile := filepath.Join(dir, ".terraform.lock.hcl")
	tfDir := filepath.Join(dir, ".terraform")

	// .terraform löschen
	if err := os.RemoveAll(tfDir); err != nil {
		t.Logf("Warning: Could not delete the dir .terraform: %v", err)
	} else {
		t.Log("Deleted successfully the .terraform dir")
	}

	if err := os.Remove(lockFile); err != nil {
		if !os.IsNotExist(err) {
			t.Logf("Warning: Could not delete the Lockfile: %v", err)
		}
	} else {
		t.Log("Deleted successfully the .terraform.lock.hcl file")
	}
}
