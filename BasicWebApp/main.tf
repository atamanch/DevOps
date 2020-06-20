provider "aws" {
  shared_credentials_file = "%USERPROFILE%\\.aws\\credentials"
  profile = "default"
  region  = var.region
}

# Spin up a t2.micro instance using the key_pair, subnet and VPC defined in other TF files
resource "aws_launch_configuration" "web_server" {
  name = "web-server-launch-config"
  image_id          = "ami-09d95fab7fff3776c"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web_dmz.id]
  associate_public_ip_address = true

  user_data = <<EOF
    #! /bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo systemctl enable docker
    sudo usermod -a -G docker ec2-user
    docker container run -d -p 80:80 atamanch/dockerstore
  EOF

/*
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
      # "sudo reboot",
    ]
  }

  # Second remote-exec for running the docker container for the Python Web App. 
  # Required due to the need for a logout from previous step
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.web_server.public_ip
      private_key = file(var.private_key_path)
      timeout = "30s"
    }
    inline = [
      # Run docker container in detached mode (-d) over port 80 from the latest image in my docker hub
      "docker container run -d -p 80:80 atamanch/dockerstore"
    ]
  }

    tags = {
        Name = "ec2-webserver"
    }
*/
}
