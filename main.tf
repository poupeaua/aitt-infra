

# S3 Bucket - Core
resource "aws_s3_bucket" "s3_bucket_aitt_core" {
  bucket = local.s3_bucket_aitt_core_name

  tags = {
    Name = local.s3_bucket_aitt_core_name
    App  = var.app_core
  }
}

# ECR Repository - Core
resource "aws_ecr_repository" "ecr_repo_aitt_core" {
  name                 = local.ecr_repo_aitt_core_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = local.ecr_repo_aitt_core_name
    App  = var.app_core
  }
}

# S3 Bucket - Angle Symbol Clf
resource "aws_s3_bucket" "s3_bucket_aitt_angle_symbol_clf" {
  bucket = local.s3_bucket_aitt_angle_symbol_clf_name

  tags = {
    Name = local.s3_bucket_aitt_angle_symbol_clf_name
    App  = var.app_angle_symbol_clf
  }
}

# ECR Repository - Angle Symbol Clf
resource "aws_ecr_repository" "ecr_repo_aitt_symbol_clf" {
  name                 = local.ecr_repo_aitt_angle_symbol_clf_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = local.ecr_repo_aitt_angle_symbol_clf_name
    App  = var.app_angle_symbol_clf
  }
}

# IAM Role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = local.iam_ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = local.iam_ec2_role_name
  }
}

# IAM Policy for S3 and ECR access
resource "aws_iam_policy" "ec2_policy" {
  name        = local.iam_ec2_policy_name
  description = "IAM policy for EC2 to access S3 and ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings"
        ],
        "Resource" : [
          "${aws_ecr_repository.ecr_repo_aitt_core.arn}",
          "${aws_ecr_repository.ecr_repo_aitt_symbol_clf.arn}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*"
        ],
        "Resource" : [
          "${aws_s3_bucket.s3_bucket_aitt_angle_symbol_clf.arn}",
        ]
      },
      {
        "Sid" : "CWACloudWatchServerPermissions",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "CWASSMServerPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter"
        ],
        "Resource" : "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# IAM Instance Profile to attach role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.iam_ec2_instance_profile_name
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2_sg" {
  name        = local.ec2_security_group_name
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# EC2 Instance
resource "aws_instance" "my_ec2_instance" {
  ami                         = data.aws_ami.ami_ec2.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.selected.id
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = local.ec2_instance_name
  }

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
}
