package main
import rego.v1

# Rule: every resource must have an Environment tag
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"
  not resource.change.after.tags.Environment
  msg := sprintf("DENY: aws_instance '%v' is missing required 'Environment' tag", [resource.address])
}

# Rule: t2.micro not allowed in prod
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"
  resource.change.after.instance_type == "t2.micro"
  resource.change.after.tags.Environment == "Prod"
  msg := "DENY: t2.micro is not permitted in prod — use t3.small or larger"
}