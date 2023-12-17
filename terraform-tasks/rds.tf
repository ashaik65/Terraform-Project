
resource "aws_db_instance" "my_rds" {
  identifier            = "my-rds-instance"
  engine                = "mysql"
  instance_class        = "db.t2.micro"
  allocated_storage     = 20
  storage_type          = "gp2"
  username              = "admin"
  password              = var.db_password
  publicly_accessible   = false
  db_subnet_group_name  = aws_db_subnet_group.my_db_subnet_group.name
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]

  tags = {
    Name = "my-rds-instance"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}


