{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
      "rds-db:connect"
    ],
    "Resource": [
      "arn:aws:rds-db:us-east-2:1234567890:dbuser:${database_name}/${database_user}"
    ]
    }
  ]
}