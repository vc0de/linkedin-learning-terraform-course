variable "web_image_id" {
  type = string
}
variable "whitelist" {
  type = list(string)
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = number
}
variable "web_min_size" {
  type = number
}
variable "web_max_size" {
  type = number
}

provider "aws" {
  profile = "tf_test_course"
  region = "eu-north-1"
}

module "securityGroupModule" {
  source = "./modules/security_group"
  cidr_blocks = var.whitelist
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-cource-20211019-2"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-north-1a"
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-north-1b"
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prod_web" {
  name            = "prod-web"
  subnets         = [ aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id ]
  security_groups = [ module.securityGroupModule.aws_security_group_prod_web ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_launch_template" "prod_web" {
  name_prefix            = "prod_web"
  image_id               = var.web_image_id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [ module.securityGroupModule.aws_security_group_prod_web ]
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_autoscaling_group" "prod_web" {
  desired_capacity    = var.web_desired_capacity
  min_size            = var.web_min_size
  max_size            = var.web_max_size
  vpc_zone_identifier = [ aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id ]

  launch_template {
    id      = aws_launch_template.prod_web.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform" 
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "prod_web" {
  autoscaling_group_name = aws_autoscaling_group.prod_web.id
  elb                    = aws_elb.prod_web.id
}
