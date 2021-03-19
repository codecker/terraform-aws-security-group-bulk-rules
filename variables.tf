# Provide the name of your security group
variable "sg_name" {}

# Provide the destination VPC for the security group 
variable "vpc" {}

# Provide a description for your security group
variable "sg_description" {}

# sg_rules should be a map type of the required security group rules
# see example in readme.md
variable "sg_rules" {
  type = map 
}