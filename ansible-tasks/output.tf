output "public_ip" {
  value = aws_instance.ansible-controller.public_ip
}
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}
