resource "aws_db_subnet_group" "this" {
  name = "${var.env}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = var.tags 
}

resource "aws_db_instance" "this" {
  identifier = "${var.env}-mysql-db"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  username = var.db_username
  password = var.db_password
  db_name = var.db_name 
  skip_final_snapshot = true
  publicly_accessible = false 
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [ var.db_security_group_id ]
  tags = var.tags 
}