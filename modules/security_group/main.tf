resource "aws_security_group" "this" {
  name        = "prod_web"
  description = "Allow standard HTTP and HTTPS inbound and everethying outbound"

  ingress = [ {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = [ "::/0" ]
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  }, {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = [ "::/0" ]
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  } ]

  egress = [ {
    description      = "Allow everething"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  } ]

  tags = {
    "Terraform" : "true"
  }

}