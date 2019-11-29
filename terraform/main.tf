
resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = "hello"
    filename = "dummy.txt"
  }
}

resource "aws_lambda_function" "lambda_fn" {
  filename      = "${data.archive_file.dummy.output_path}"
  function_name = "${var.function_name}"
  role          = "${aws_iam_role.lambda_iam.arn}"
  timeout       = 60
  handler       = "index.handler"
  runtime       = "nodejs8.10"
  depends_on    = ["aws_iam_role_policy_attachment.lambda_logs", "aws_cloudwatch_log_group.lambda_log_group"]
}



resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 1
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.lambda_iam.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
