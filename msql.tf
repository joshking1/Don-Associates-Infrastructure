# DataBase
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
  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "mysql-database"
  }

  provisioner "local-exec" {
    command = <<-EOT
      mysql -h ${self.endpoint} -P 3306 -u admin -ppassword -e "CREATE DATABASE IF NOT EXISTS mydatabase;"
      mysql -h ${self.endpoint} -P 3306 -u admin -ppassword -e "USE mydatabase; CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL, password VARCHAR(50) NOT NULL);"
    EOT
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




