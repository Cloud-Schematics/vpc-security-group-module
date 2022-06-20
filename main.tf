##############################################################################
# Security Group Dynamic Values
##############################################################################

module "security_group_map" {
  source = "./config_modules/list_to_map"
  list = [
    for group in var.security_groups :
    merge(group, { vpc_id = var.vpc_id })
  ]
}

##############################################################################

##############################################################################
# Security Group
##############################################################################

resource "ibm_is_security_group" "security_group" {
  for_each       = module.security_group_map.value
  name           = "${var.prefix}-${each.value.name}"
  vpc            = each.value.vpc_id
  resource_group = var.resource_group_id
  tags           = var.tags
}

##############################################################################

##############################################################################
# Security Group Rules
##############################################################################

module "security_group_rules" {
  source               = "github.com/Cloud-Schematics/vpc-security-group-rules-module"
  for_each             = module.security_group_map.value
  security_group_id    = ibm_is_security_group.security_group[each.value.name].id
  security_group_rules = each.value.rules
}

##############################################################################