# DataBase-New 
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.44-rds.20240408"
  instance_class       = "db.t3.micro"
  db_name              = "mydatabase"
  username             = "admin"
  password             = "password"
  multi_az             = false
  parameter_group_name = aws_db_parameter_group.mysql.name
  skip_final_snapshot  = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.id

  tags = {
    Name = "mysql-database"
  }
}

resource "aws_db_parameter_group" "mysql" {
  name   = "mysql-parameter-group"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# Creating RDS Instance subnet group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.public_3.id
  ]

  tags = {
    Name = "My DB subnet group"
  }
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}




