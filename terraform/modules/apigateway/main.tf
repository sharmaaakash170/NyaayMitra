resource "aws_apigatewayv2_api" "this" {
  name = "${var.env}-http-api"
  protocol_type = "HTTP"
  tags = merge(var.tags, {
    Environment = var.env
  })
}