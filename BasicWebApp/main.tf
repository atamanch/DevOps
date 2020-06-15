provider "aws" {
  shared_credentials_file = "%USERPROFILE%\\.aws\\credentials"
  profile = "default"
  region  = var.region
  
}

resource "aws_instance" "web_server" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.main-public-1.id
  # TODO - fix this such that it dynamically grabs the security group ID
  # vpc_security_group_ids = ["aws_security_group.web_dmz.id",]
  vpc_security_group_ids = ["sg-04287210de3a2e2fc"]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.web_server.public_ip
      private_key = file(var.private_key_path)
      timeout = "30s"
    }
    inline = [
      "sudo sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user",
      # TODO - figure out how to reboot an instance and wait until the instance is back up
      "sudo reboot",
    ]
  }

  # Second remote-exec for running the docker container for the Python Web App
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.web_server.public_ip
      private_key = file(var.private_key_path)
      timeout = "30s"
    }
    inline = [
      "docker container run -p 80:80 atamanch/dockerstore"
    ]
  }

  tags = {
        Name = "ec2-webserver1"
    }
}