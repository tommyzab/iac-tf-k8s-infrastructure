resource "aws_security_group" "alb" {
  name        = "${var.environment}-${var.application}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-alb-sg"
  })

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name               = "${var.environment}-${var.application}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    { Name = "${var.environment}-${var.application}-alb" },
    var.eks_cluster_name != "" ? { "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned" } : {}
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No rules matched"
      status_code  = "404"
    }
  }
}