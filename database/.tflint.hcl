config {
    module = true
    force = false
    disabled_by_default = false
    varfile = ["example1.tfvars", "example2.tfvars"]
}
 
plugin "aws" {
    enabled = true
    version = "0.4.0"
    source = "github.com/terraform-linters/tflint-ruleset-aws"
}
 
rule "aws_instance_invalid_type" { enabled = false }