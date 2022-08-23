resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.ec2_class
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data = file("userdata.sh")

  tags = {
      Name = "${var.product}.${var.environment}-ec2"
  }
}
resource "aws_security_group" "ec2-sg" {

    name = "${var.product}.${var.environment}-ec2-sg"
    vpc_id = "vpc-0f08d1a10e403f785"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ec2-sg"
    }
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${var.product}.${var.environment}-ec2-profile"
    role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "server-role"

  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_db_instance" "db" {
  allocated_storage    = 10
  engine               = "docdb"
  engine_version       = "4.0.0"
  instance_class       = "db.t3.medium"
  db_name              = "phbookdb"
  username             = ""
  password             = ""
  skip_final_snapshot  = true
}
resource "aws_launch_template" "aws_launch" {
  name_prefix   = "aws_launch"
  image_id      = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  user_data = filebase64("${path.module}/userdata.sh")

}

resource "aws_autoscaling_group" "autoscaling" {
  availability_zones = ["us-east-1a", "us-east-1b"]
  max_size           = 10
  desired_capacity   = 4
  min_size           = 2
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.aws_launch.id
    version = "$Default"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2-sg.id]
  subnets = ["subnet-08b2deaca401315f8","subnet-09b46b3bc3d4cd631", "subnet-031f10057e6c694cf"]


  enable_deletion_protection = true
}

