resource "aws_ebs_volume" "app_ebs" {
  availability_zone = aws_instance.web_server.availability_zone
  size              = 10
  type              = "gp2"

  tags = {
    Name = "app-ebs-volume"
  }
}

resource "aws_volume_attachment" "app_ebs_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.app_ebs.id
  instance_id = aws_instance.web_server.id
}
