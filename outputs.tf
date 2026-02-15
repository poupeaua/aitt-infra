output "ecr_repo_core_uri" {
  description = "The URI of the first ECR repository."
  value       = aws_ecr_repository.ecr_repo_aitt_core.repository_url
}

output "ecr_repo_angle_symbol_clf_uri" {
  description = "The URI of the second ECR repository."
  value       = aws_ecr_repository.ecr_repo_aitt_symbol_clf.repository_url
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.my_ec2_instance.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.my_ec2_instance.public_ip
}
