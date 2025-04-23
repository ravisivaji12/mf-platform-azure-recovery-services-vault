package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMultipleRecoveryVaults(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vaultNames := terraform.OutputList(t, terraformOptions, "vault_names")
	rgNames := terraform.OutputList(t, terraformOptions, "vault_rg_names")

	for i, vaultName := range vaultNames {
		rg := rgNames[i]

		exists := azure.RecoveryServicesVaultExists(t, vaultName, rg, "")
		assert.True(t, exists)

		t.Logf("Validated Recovery Services Vault %s exists in resource group %s", vaultName, rg)
	}
}
