# Terraform AWS connect VPCs
This independent module creates connectivity between 2 VPCs in same region through transit gateway, creating the transit gateway attachment and updating the default route table's entry.

If the transit gateway already exists, substitute isTGWExist as "yes" and tgwID as "existing_transit_gateway_id".
Otherwise isTGWExist as "no" and tgwID as ""
## Usage
~~~
module "connect-vpcs" {
  source     = "github.com/myanees284/terraform-aws-connect-vpcs"
  region     = "us-east-2"
  vpc_id_1   = "vpc-123456"
  vpc_id_2   = "vpc-654321"
  isTGWExist = "yes"
  tgwID      = "existing_transit_gateway_id"
}
~~~
