resource "aws_lb_target_group" "ingress" {
  name        = aws_lb.ingress.name
  target_type = "alb"
  port        = aws_lb_listener.http-80.port
  protocol    = "TCP"
  vpc_id      = aws_lb.ingress.vpc_id
}

resource "aws_lb_target_group_attachment" "ingress" {
  target_group_arn = aws_lb_target_group.ingress.arn
  target_id        = aws_lb.ingress.arn
  port             = aws_lb_listener.http-80.port
}

resource "aws_security_group" "lb_security_group" {
  name        = "${var.prefix}-lb-security-group"
  description = "Security group for Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "ingress" {
  name                             = "${var.prefix}-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb_security_group.id]
  subnets                          = var.public_subnet_ids[*]
  ip_address_type = "ipv4"
  preserve_host_header = false

 tags = {
    ManagedBy                                   = "AWS Load Balancer Controller"
    "elbv2.k8s.aws/cluster"                     = "tommy-eks-cluster"
    "ingress.k8s.aws/resource"                  = "LoadBalancer"
    "ingress.k8s.aws/stack"                     = "tommy-alb"
    "kubernetes.io/cluster/tommy-eks-cluster" = "owned"
}

  lifecycle {
    ignore_changes = [security_groups]
  }
}

resource "aws_lb_listener" "http-80" {
  load_balancer_arn = aws_lb.ingress.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    order = 1
    type  = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
     }
}

  tags = {
    ManagedBy                                   = "AWS Load Balancer Controller"
    "elbv2.k8s.aws/cluster"                     = "tommy-eks-cluster"
    "ingress.k8s.aws/resource"                  = "80"
    "ingress.k8s.aws/stack"                     = "tommy-alb"
    "kubernetes.io/cluster/tommy-eks-cluster" = "owned"
  }
}