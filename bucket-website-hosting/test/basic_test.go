

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/gcp"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestEndToEndDeploymentScenario(t *testing.T) {
	t.Parallel()
	projectId := gcp.GetGoogleProjectIDFromEnvVar(t)

	fixtureFolder := "../"

	test_structure.RunTestStage(t, "setup", func() {
			terraformOptions := &terraform.Options{
					TerraformDir: fixtureFolder,
					Vars:  map[string]interface{} {
            "project_id": projectId,
        	},
			}

			test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

			terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
			// run validation checks here
			// terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
			// publicIpAddress := terraform.Output(t, terraformOptions, "public_ip_address")
	})

	test_structure.RunTestStage(t, "teardown", func() {
			terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
			terraform.Destroy(t, terraformOptions)
	})
}

