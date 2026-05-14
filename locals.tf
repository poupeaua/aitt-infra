locals {
  # app angle symbol clf
  s3_bucket_aitt_angle_symbol_clf_name = "${var.project}-${var.app_angle_symbol_clf}-${var.env}"
  ecr_repo_aitt_angle_symbol_clf_name  = "${var.project}/${var.app_angle_symbol_clf}-${var.env}"

  # app core
  s3_bucket_aitt_core_name = "${var.project}-${var.app_core}-${var.env}"
  ecr_repo_aitt_core_name  = "${var.project}/${var.app_core}-${var.env}"

  # ec2 instance
  ec2_instance_name     = "${var.project}-${var.env}-ec2-01"
  iam_ec2_role_name     = "${var.project}-${var.env}-ec2-role"
  iam_ec2_policy_name   = "${var.project}-${var.env}-ec2-policy"
  iam_ec2_instance_profile_name = "${var.project}-${var.env}-ec2-instance-profile"
  ec2_security_group_name = "${var.project}-${var.env}-ec2-sg"
}