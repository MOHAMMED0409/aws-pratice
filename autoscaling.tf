resource "aws_launch_configuration" "react_launch_configuration" {
  name          = "react-launch-configuration"
  image_id      = "ami-04b70fa74e45c3917"  # Update with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = "key-1"
  security_groups = [aws_security_group.react-sg.id]

  # Optionally, you can define additional configurations such as user data, IAM instance profile, etc.
}

resource "aws_autoscaling_group" "react_autoscaling_group" {
  # Define your autoscaling group configuration here
  # Example configuration:
  name                 = "react-autoscaling-group"
  launch_configuration = aws_launch_configuration.react_launch_configuration.name
  min_size             = 1
  max_size             = 5
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.react-subnet.id, aws_subnet.react-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "react-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.react_autoscaling_group.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.react_autoscaling_group.name
}
