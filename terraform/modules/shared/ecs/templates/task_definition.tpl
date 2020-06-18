[
  {
    "name": "${env}-${service_name}",
    "family" : "${product_code}",
    "taskRoleArn": "${role_arn}",
    "image": "${image_url}",
    "cpu": ${cpu},
    "networkMode": "awsvpc",
    "portMappings": [
      {
      "containerPort": ${app_port},
      "hostPort": ${app_port}
      }
    ]
  }
]