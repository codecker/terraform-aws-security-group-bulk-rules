# Terraform AWS Security Group bulk rules
This Terraform AWS module is for managing bulk AWS security group rules. This module allows large volumes of rules to be defined in a concise [Terraform map type](https://www.terraform.io/docs/language/expressions/types.html).  The map is then looped through using [For_Each meta-argument](https://www.terraform.io/docs/language/meta-arguments/for_each.html) to define individual [AWS Security Group Rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule). These rules are deployed into an [AWS Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group).


## Features
Current version supports:
- IPv4 CIDR source
- Security Group source
- Self source
- Ingress and Egress rules
- Description fields
- Rules limited only by [AWS quota](https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html#vpc-limits-security-groups)

### Upcoming features
- IPv6 CIDR support
- [Named rules](https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf)
- Tags


## Usage
In a local map type define your required rules, with one rule per line.

Allowed values:
type: "ingress", "egress"
protocol: "tcp", "udp", "icmp", "all", "-1"
source_type: "cidr" "sg" "self"

### Example
```
locals {
  web_server_rules = {
    1 = { type = "ingress", protocol = "tcp", from = 443,  to = 443,  source_type = "cidr", source = "0.0.0.0/0", desc = "Inbound Public HTTPS web traffic" },
    2 = { type = "ingress", protocol = "tcp", from = 80,   to = 80,   source_type = "cidr", source = "0.0.0.0/0", desc = "Inbound Public HTTP web traffic" },
    3 = { type = "ingress", protocol = "tcp", from = 22,   to = 22,   source_type = "sg",   source = "sg-000000000", desc = "Inbound SSH from Security Group" },
    4 = { type = "ingress", protocol = "tcp", from = 8001, to = 8009, source_type = "self", source = true, desc = "Inbound service traffic from security group" },
    5 = { type = "egress",  protocol = "all",  from = -1,   to = -1,   source_type = "cidr", source = "0.0.0.0/0", desc = "Outbound all ports and protocols" },
  }
}

module "bulk-aws-security-groups-rules" {
  source = "./modules/bulk-aws-security-groups-rules"
  sg_name = "webserver_sg"
  vpc = "vpc-0aa00aa0"
  sg_description = "Web server cluster security rules"
  sg_rules = web_server_rules
} 

```
