resource "aws_security_group" "sg" {
  name        = "${var.sg_name}_TFmanaged"
  description = var.sg_description
  vpc_id      = var.vpc
}

resource "aws_security_group_rule" "security_group_rules" {
  for_each                 = var.sg_rules
  type                     = each.value.type
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.protocol
  self                     = each.value.source_type == "self" ? each.value.source : null
  cidr_blocks              = each.value.source_type == "cidr" ? [each.value.source] : null
  source_security_group_id = each.value.source_type == "sg" ? each.value.source : null
  description              = each.value.desc
  security_group_id        = aws_security_group.sg.id
}