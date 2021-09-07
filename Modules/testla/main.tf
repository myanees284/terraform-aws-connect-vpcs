provider "aws" {
  region = "us-east-2"
}

variable "environment" {
  default = ""
}

variable "isVPC" {
  default = ""
}
resource "aws_vpc" "main" {
  count      = "${var.isVPC == "false" ? 1 : 0}"
  cidr_block = "22.0.0.0/16"

  tags = {
    Name = "test if22"
  }
}

locals {
  # tgwID = "${var.isTGW == "false" ? "load" : var.environment}"
  VPC_ID = "${var.isVPC == "false" ? aws_vpc.main[0].id : var.environment}"
  # depends_on = [aws_vpc.main]
}

resource "null_resource" "print_values" {
  provisioner "local-exec" {
    command = "bash ./Modules/testla/run_config.sh ${local.VPC_ID}"
  }
  # depends_on = [aws_vpc.main]
}