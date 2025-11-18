###############################################
# AWS ZERO TRUST NETWORK MODULE
###############################################

module "aws_zero_trust" {
  source          = "../../modules/aws-network"
  vpc_id          = aws_vpc.main.id
  private_subnets = [aws_subnet.private.id]
  region          = var.aws_region
}
