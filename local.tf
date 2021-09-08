locals {
  vpc_1_subnetids = module.fetchVPC1_Subnet.result
  vpc_2_subnetids = module.fetchVPC2_Subnet.result
  vpc_1_RTBid     = module.fetchVPC1_RTB.result
  vpc_2_RTBid     = module.fetchVPC2_RTB.result
  vpc_1_CIDR      = module.fetchVPC1_CIDR.result
  vpc_2_CIDR      = module.fetchVPC2_CIDR.result
  TGW_ID="${var.isTGWExist == "false" ? aws_ec2_transit_gateway.superTGW[0].id : var.tgwID}"
}