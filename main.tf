provider "aws" {
  region = var.region
}

module "fetchVPC1_Subnet" {
  source           = "digitickets/cli/aws"
  version          = "4.0.0"
  aws_cli_commands = ["ec2", "describe-subnets --filters Name=vpc-id,Values=${var.vpc_id_1}"]
  aws_cli_query    = "'Subnets[*].SubnetId'"
}

module "fetchVPC2_Subnet" {
  source           = "digitickets/cli/aws"
  version          = "4.0.0"
  aws_cli_commands = ["ec2", "describe-subnets --filters Name=vpc-id,Values=${var.vpc_id_2}"]
  aws_cli_query    = "'Subnets[*].SubnetId'"
}

module "fetchVPC1_RTB" {
  source           = "digitickets/cli/aws"
  version          = "4.0.0"
  aws_cli_commands = ["ec2", "describe-route-tables --filters Name=vpc-id,Values=${var.vpc_id_1}"]
  aws_cli_query    = "'RouteTables[0].Associations[0].RouteTableId'"
}

module "fetchVPC2_RTB" {
  source           = "digitickets/cli/aws"
  version          = "4.0.0"
  aws_cli_commands = ["ec2", "describe-route-tables --filters Name=vpc-id,Values=${var.vpc_id_2}"]
  aws_cli_query    = "'RouteTables[0].Associations[0].RouteTableId'"
}

module "fetchVPC1_CIDR" {
  source           = "digitickets/cli/aws"
  version          = "4.0.0"
  aws_cli_commands = ["ec2", "describe-vpcs --filters Name=vpc-id,Values=${var.vpc_id_1}"]
  aws_cli_query    = "'Vpcs[0].CidrBlock'"
}

module "fetchVPC2_CIDR" {
  source           = "digitickets/cli/aws"
  version          = "4.0.0"
  aws_cli_commands = ["ec2", "describe-vpcs --filters Name=vpc-id,Values=${var.vpc_id_2}"]
  aws_cli_query    = "'Vpcs[0].CidrBlock'"
}

resource "aws_ec2_transit_gateway" "superTGW" {
  count       = var.isTGWExist == "no" ? 1 : 0
  description = "superTGW"
  tags = {
    Name = "superTGW"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "TGWA-1" {
  subnet_ids         = local.vpc_1_subnetids
  transit_gateway_id = local.TGW_ID
  vpc_id             = var.vpc_id_1

  tags = {
    Name = "superTGWA-1"
  }
  depends_on = [aws_ec2_transit_gateway.superTGW]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "TGWA-2" {
  subnet_ids         = local.vpc_2_subnetids
  transit_gateway_id = local.TGW_ID
  vpc_id             = var.vpc_id_2

  tags = {
    Name = "superTGWA-2"
  }
  depends_on = [aws_ec2_transit_gateway.superTGW]
}

resource "aws_default_route_table" "VPC_1_RT" {
  default_route_table_id = local.vpc_1_RTBid

  route {
    cidr_block = local.vpc_2_CIDR
    gateway_id = local.TGW_ID
  }
  depends_on = [aws_ec2_transit_gateway.superTGW,
    aws_ec2_transit_gateway_vpc_attachment.TGWA-1,
  aws_ec2_transit_gateway_vpc_attachment.TGWA-2]
}

resource "aws_default_route_table" "VPC_2_RT" {
  default_route_table_id = local.vpc_2_RTBid

  route {
    cidr_block = local.vpc_1_CIDR
    gateway_id = local.TGW_ID
  }
  depends_on = [aws_ec2_transit_gateway.superTGW,
    aws_ec2_transit_gateway_vpc_attachment.TGWA-1,
  aws_ec2_transit_gateway_vpc_attachment.TGWA-2]
}