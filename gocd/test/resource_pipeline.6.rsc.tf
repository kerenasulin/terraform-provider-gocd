locals {
  "group" = "test-pipelines"
}

resource "gocd_pipeline" "pipe-Z" {
  name      = "pipe-Z"
  group     = "${local.group}"
  materials = [{
    type = "git"
    attributes {
      url = "github.com/gocd/gocd"
    }
  }]
}

resource "gocd_pipeline_stage" "stage-Z" {
  name     = "stage-Z"
  pipeline = "${gocd_pipeline.pipe-Z.name}"
  jobs     = ["${data.gocd_job_definition.list.json}"]
}

resource "gocd_pipeline" "pipe-Y" {
  name      = "pipe-Y"
  group     = "${local.group}"
  materials = [{
    type = "git"
    attributes {
      url = "github.com/gocd/gocd"
    }
  }]
}

resource "gocd_pipeline_stage" "stage-Y" {
  name     = "stage-Y"
  pipeline = "${gocd_pipeline.pipe-Y.name}"
  jobs     = ["${data.gocd_job_definition.list.json}"]
}

data "gocd_job_definition" "list" {
  name  = "list"
  tasks = ["${data.gocd_task_definition.list.json}"]
}

data "gocd_task_definition" "list" {
  type    = "exec"
  command = "ls"
}

#data "template_file" "pipeline_materials" {
#  template = <<JSON
#[{
#  "type": "dependency",
#  "attributes": {
#    "pipeline": "$${pipeline_A_name}",
#    "stage": "$${pipeline_A_stage_name}"
#  }
#},
#{
#  "type": "dependency",
#  "attributes": {
#    "pipeline": "$${pipeline_B_name}",
#    "stage": "$${pipeline_B_stage_name}"
#  }
#}]
#JSON
#
#  vars {
#    pipeline_A_name = "${gocd_pipeline.pipe-A.name}"
#    pipeline_A_stage_name = "${gocd_pipeline_stage.stage-A.name}"
#    pipeline_B_name = "${gocd_pipeline.pipe-B.name}"
#    pipeline_B_stage_name = "${gocd_pipeline_stage.stage-B.name}" 
#
#  }
#}

resource "gocd_pipeline" "pipe-X" {
  name      = "pipe-X"
  group     = "${local.group}"

  materials = [{
    type = "git"
    attributes {
      url = "github.com/gocd/gocd"
    }
  }]

  materials_json = <<EOF
[{
  "type": "dependency",
  "attributes": {
    "pipeline": "${gocd_pipeline.pipe-Y.name}",
    "stage": "${gocd_pipeline_stage.stage-Y.name}"
  }
},
{
  "type": "dependency",
  "attributes": {
    "pipeline": "${gocd_pipeline.pipe-Z.name}",
    "stage": "${gocd_pipeline_stage.stage-Z.name}"
  }
}]
EOF

}
