# ubuntu server data in AWS Cloud

data "aws_ami" "ubuntu_server" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.public_1.id             
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }

  user_data = templatefile("configuration3.sh.tpl", {
    db_endpoint = aws_db_instance.mysql.endpoint
  })

  depends_on = [aws_db_instance.mysql]
}

resource "aws_instance" "web_server_2" {
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.public_2.id        # we are going to add this in public_2 subnet
  security_groups = [aws_security_group.web_sg.id]
  user_data      = file("nginx.sh")

  tags = {
    Name = "WebServer-2"
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  description = "Allow web and database traffic"
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
    from_port   = 3306
    to_port     = 3306
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
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.private_1.id
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer1"
  }

  # user_data = file("configuration.sh")
}

resource "aws_instance" "app_server_2" {
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.private_2.id
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer2"
  }

  # user_data = file("configuration.sh")
}

resource "aws_instance" "app_server_3" {
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = var.instance_type
  key_name      = var.keyname
  subnet_id     = aws_subnet.private_3.id
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer3"
  }

  # user_data = file("configuration.sh")
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

