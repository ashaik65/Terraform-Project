resource "aws_instance" "ansible-controller" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

  provisioner "file" {
    source      = "C:/Users/Anis/Downloads/terraform.pem"
    destination = "/home/ubuntu/terraform.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/Anis/Downloads/terraform.pem")
      host        = self.public_ip
    }
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo apt update
            sudo apt install -y software-properties-common
            sudo add-apt-repository --yes --update ppa:ansible/ansible
            sudo apt install -y ansible
            chmod 400 /home/ubuntu/terraform.pem
            chown ubuntu:ubuntu /home/ubuntu/terraform.pem
            EOF

  tags = {
    Name = "ansible-controller-instance"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "jenkins-instance"
  }
}



resource "aws_security_group" "sg" {
  name        = "terraform_sg"
  description = "Security Group managed by Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_sg"
  }
}