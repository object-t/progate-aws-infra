resource "aws_security_group" "backend" {
  name        = "${local.name_prefix}-backend-sg"
  description = "Backend Security Group"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "${local.name_prefix}-backend-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_nlb" {
  security_group_id = aws_security_group.backend.id
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.this.cidr_block
  description       = "Allow NLB traffic from VPC"
}

resource "aws_vpc_security_group_egress_rule" "allow_every_outbound" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${local.name_prefix}-vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-vpc-endpoint-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_https" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.this.cidr_block
  description       = "Allow HTTPS traffic from VPC"
}