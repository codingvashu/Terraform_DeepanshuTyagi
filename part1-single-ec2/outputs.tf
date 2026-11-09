output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "frontend_url" {
  description = "Express frontend URL"
  value       = format("%s://%s:%d", "http", aws_instance.app_server.public_ip, 3000)
}

output "backend_url" {
  description = "Flask backend URL"
  value       = format("%s://%s:%d", "http", aws_instance.app_server.public_ip, 5000)
}
