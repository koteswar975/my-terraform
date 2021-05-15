//resource "aws_launch_configuration" "webapp_config" {
//name            = "web_config"
//image_id        = "ami-0217a85e28e625474"
//instance_type   = "t2.micro"
//key_name        = "koti keypair"
//security_groups = [aws_security_group.web_sg.id]
//}
//resource "aws_autoscaling_group" "asg" {
//name                      = "asg-terraform"
//max_size                  = 5
//min_size                  = 1
//health_check_grace_period = 300
//health_check_type         = "ELB"
//desired_capacity          = 1
//force_delete              = true
//launch_configuration      = aws_launch_configuration.webapp_config.name
//vpc_zone_identifier       = local.pub_sub_ids
//}
//resource "aws_autoscaling_policy" "cpu_utilization" {
//name                   = "cpu_utilization"
//scaling_adjustment     = 2
//adjustment_type        = "ChangeInCapacity"
//cooldown               = 30
//autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
//}
