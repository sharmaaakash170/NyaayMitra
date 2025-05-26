resource "aws_ecr_repository" "this" {
  name = "${var.env}-ecr-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(var.tags, {
    Environment = var.env
  })
}