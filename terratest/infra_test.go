package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformInfra(t *testing.T) {
  terraformOptions := &terraform.Options{
    TerraformDir: "../terraform/envs/dev",
  }

  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)
}