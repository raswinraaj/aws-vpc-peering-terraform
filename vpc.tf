module "vpc_a" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "vpc-a"
  cidr                 = "15.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1a"]
  public_subnets      = ["15.0.1.0/24", "15.0.2.0/24"]
  private_subnets     = ["15.0.3.0/24", "15.0.4.0/24"]
  enable_dns_support  = true
  enable_dns_hostnames = true 
  create_igw = true  
}

module "vpc_b" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "vpc-b"
  cidr                 = "15.1.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["15.1.1.0/24", "15.1.2.0/24"]
  private_subnets     = ["15.1.3.0/24", "15.1.4.0/24"]
  enable_dns_support  = true
  enable_dns_hostnames = true
  create_igw = true  
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id                 = module.vpc_b.vpc_id
  peer_vpc_id            = module.vpc_a.vpc_id
  auto_accept            = true  
}

resource "aws_route" "route_to_vpc_a" {
  route_table_id         = module.vpc_b.private_route_table_ids[0] 
  destination_cidr_block = module.vpc_a.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_security_group_rule" "outbound_to_vpc_b" {
  security_group_id = module.vpc_a.default_security_group_id
  type              = "egress"
  from_port         = 80
  to_port           = 443
  protocol          = "-1"
  cidr_blocks       = [module.vpc_b.vpc_cidr_block]
}

resource "aws_security_group_rule" "inbound_from_vpc_a" {
  security_group_id = module.vpc_b.default_security_group_id
  type              = "ingress"
  from_port         = 80
  to_port           = 443
  protocol          = "-1"
  cidr_blocks       = [module.vpc_a.vpc_cidr_block]
}