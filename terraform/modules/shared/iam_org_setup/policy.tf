resource "aws_iam_policy" "devops_role_policy" {
  name        = "${var.env}-devops_role_policy"
  path        = "/"
  description = "Policy for Devops roles"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cd_role_policy" {
  name        = "${var.env}-cd_role_policy"
  path        = "/"
  description = "Policy for CD roles"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

