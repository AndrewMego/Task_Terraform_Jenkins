resource "aws_launch_configuration" "example" {
  image_id        = var.ami_id
  instance_type   = var.instance_type
  user_data       = var.user_data // Script to install PHP and deploy the webpage
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = var.desired_capacity
  max_size             = var.desired_capacity + 1
  min_size             = var.desired_capacity - 1
  vpc_zone_identifier  = var.public_subnets
  launch_configuration = aws_launch_configuration.example.name
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.public_subnets, 0)
  key_name      = "your-key-pair-name" // Update with your key pair name

  tags = {
    Name = "Terraform-PHP-Instance"
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
