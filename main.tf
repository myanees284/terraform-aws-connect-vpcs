provider "aws"{
    region="us-east-2"
}

# variable "environment" {
#   default = "eww"
# }

module "my_sample" {
  source   = "./Modules/testla"
  isVPC= "false"
  environment = "VPC_not_created"
}