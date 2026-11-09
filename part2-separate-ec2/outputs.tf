output "frontend_public_ip" {
  description = "Public IP of Express frontend EC2"
  value       = aws_instance.frontend.public_ip
}

output "backend_public_ip" {
  description = "Public IP of Flask backend EC2"
  value       = aws_instance.backend.public_ip
}

output "backend_private_ip" {
  description = "Private IP used by frontend to reach Flask"
  value       = aws_instance.backend.private_ip
}

output "frontend_url" {
  description = "Express frontend URL"
  value       = "http://${aws_instance.frontend.public_ip}:3000"
}

output "backend_health_url" {
  description = "Internal Flask health endpoint"
  value       = "http://${aws_instance.backend.private_ip}:5000/health"
}
