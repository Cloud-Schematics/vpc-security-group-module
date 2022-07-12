# VPC Security Groups Module

Create any number of security groups and rules within those groups in a single VPC.

## Module Variables

Name                                | Type                                                        | Description                                                                                                       | Sensitive | Default
----------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | --------- | ---------------------------------------------
prefix                              | string                                                      | The prefix that you would like to append to your resources                                                        |           | 
resource_group_id                   | string                                                      | ID of the resource group where security groups will be provisioned                                                        |           | null
tags                                | list(string)                                                | List of Tags for the resource created                                                                             |           | null
vpc_id                              | string                                                      | ID of the VPC where security groups will be created                                                                       |           | 

## Security Groups Variable 

```terraform
variable "security_groups" {
  description = "Security groups for VPC"
  type = list(
    object({
      name = string # Name
      rules = list( # List of rules
        object({
          name      = string # name of rule
          direction = string # can be inbound or outbound
          remote    = string # ip address to allow traffic from
          ##############################################################################
          # One or none of these optional blocks can be added
          # > if none are added, rule will be for any type of traffic
          ##############################################################################
          tcp = optional(
            object({
              port_max = number
              port_min = number
            })
          )
          udp = optional(
            object({
              port_max = number
              port_min = number
            })
          )
          icmp = optional(
            object({
              type = number
              code = number
            })
          )
        })
      )
    })
  )
  ...
}
```

## Module Outputs

`groups` - A list of each group created and the group ID

## Example Usage

```terraform
##############################################################################
# Security Groups
##############################################################################

module "security_groups" {
  source            = "github.com/Cloud-Schematics/vpc-security-group-module"
  prefix            = var.prefix
  resource_group_id = data.ibm_resource_group.resource_group.id
  tags              = var.tags
  vpc_id            = ibm_is_vpc.vpc.id
  security_groups   = var.security_groups
}

##############################################################################
```