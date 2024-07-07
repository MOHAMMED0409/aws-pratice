resource "aws_instance" "react-app" {
  ami             = "ami-04b70fa74e45c3917" # Ubuntu Server 20.04 LTS AMI (update to the latest one)
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.react-subnet.id
  security_groups = [aws_security_group.react-sg.id]
  key_name = "key-1"
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nodejs npm",
      "sudo npm install -g pm2",
      "git clone https://github.com/MOHAMMED0409/Weather-API-s-using-ReactJS.git",  # replace with your React app repository
      "cd Weather-API-s-using-ReactJS",
      "npm install",
      "pm2 start npm --name 'react-app' -- start"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/mohammedkhashifs/Downloads/key-1.pem")  # replace with your private key path
      host        = self.public_ip
    }
  }

  tags = {
    Name = "react-server"
  }
}

# Output the instance's public IP address
output "instance_public_ip" {
  value = aws_instance.react-app.public_ip
}