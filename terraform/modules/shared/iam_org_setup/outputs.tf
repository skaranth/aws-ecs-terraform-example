output "microservice_role_policy_arn" {
  value = aws_iam_policy.microservice_role_policy.arn
}

output "devops_role_policy_arn" {
  value = aws_iam_policy.devops_role_policy.arn
}

output "cd_role_policy_arn" {
  value = aws_iam_policy.cd_role_policy.arn
}