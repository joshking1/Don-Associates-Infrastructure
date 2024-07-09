resource "aws_instance" "web_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.public_1.id
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }

  user_data = file("configuration2.sh")
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server_1" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.private_1.id
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer1"
  }

  #user_data = file("configuration.sh")
}

resource "aws_instance" "app_server_2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.private_2.id
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer2"
  }

  #user_data = file("configuration.sh")
}

resource "aws_instance" "app_server_3" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.private_3.id
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer3"
  }

  #user_data = file("configuration.sh")
}

resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg-"
  description = "Allow SSH traffic for updates and package installations"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
