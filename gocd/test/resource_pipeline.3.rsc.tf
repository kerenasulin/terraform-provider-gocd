## START pipeline.test-pipeline3
# CMD terraform import gocd_pipeline.test-pipeline3 "test-pipeline3"
resource "gocd_pipeline" "test-pipeline3" {
  name = "test-pipeline3"
  group = "defaultGroup"
  label_template  = "$${COUNT}"
  materials = [
    {
      type = "git"
      attributes {
        url = "https://github.com/drewsonne/terraform-provider-gocd.git"
        branch = "master"
        auto_update = true
      }
    },
  ]
}

# CMD terraform import gocd_pipeline_stage.test "test"
resource "gocd_pipeline_stage" "test" {
  name = "test"
  pipeline_template = "test-pipeline3"
  fetch_materials = true
  jobs = [
    "${data.gocd_job_definition.test.json}"
  ]
}
data "gocd_job_definition" "test" {
  name = "test"
  tasks = [
    "${data.gocd_task_definition.test-pipeline3_test_test_0.json}",
  ]
}
data "gocd_task_definition" "test-pipeline3_test_test_0" {
  type = "exec"
  run_if = ["success"]
  arguments = [
    "test"]
}

## END