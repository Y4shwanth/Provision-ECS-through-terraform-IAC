resource "aws_ecs_cluster" "internal-apps-cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "infra-apps-role" {
  name               = var.infra_apps_role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "infra-apps-policy-docs" {
  name   = var.infra_policy_name
  policy = var.infra_policy_file
}

resource "aws_iam_role_policy_attachment" "role-policy-attach" {
  role       = aws_iam_role.infra-apps-role.name
  policy_arn = aws_iam_policy.infra-apps-policy-docs.arn
}

resource "aws_lb_target_group" "frontend_target_group" {
  name             = var.frontend_target_group_name
  protocol         = var.frontend_target_group_protocol
  port             = var.frontend_target_group_port
  vpc_id           = var.vpc_id_to_create_frontend_target_group
  protocol_version = var.frontend_target_group_protocol_version
  target_type      = var.frontend_target_group_target_type
}

resource "aws_ecs_task_definition" "frontend_task_def" {
  family                = var.frontend_task_def_name
  execution_role_arn    = aws_iam_role.infra-apps-role.arn
  task_role_arn         = aws_iam_role.infra-apps-role.arn
  network_mode          = var.network_mode
  container_definitions = var.frontend_container_definition
}

resource "aws_ecs_service" "frontend_service" {
  name            = var.frontend_service_name
  task_definition = aws_ecs_task_definition.frontend_task_def.arn
  cluster         = aws_ecs_cluster.internal-apps-cluster.id
  desired_count   = var.frontend_service_desired_count
  launch_type     = var.launch_type
  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    container_name   = var.frontend_container_name
    container_port   = var.frontend_container_port
  }
}

resource "aws_lb_target_group" "backend_target_group" {
  name             = var.backend_target_group_name
  protocol         = var.backend_target_group_protocol
  port             = var.backend_target_group_port
  vpc_id           = var.vpc_id_to_create_backend_target_group
  protocol_version = var.backend_target_group_protocol_version
  target_type      = var.backend_target_group_target_type
}

resource "aws_ecs_task_definition" "backend_task_def" {
  family                = var.backend_task_def_name
  execution_role_arn    = aws_iam_role.infra-apps-role.arn
  task_role_arn         = aws_iam_role.infra-apps-role.arn
  network_mode          = var.network_mode
  container_definitions = var.backend_container_definition
}

resource "aws_ecs_service" "backend_service" {
  name            = var.backend_service_name
  task_definition = aws_ecs_task_definition.backend_task_def.arn
  cluster         = aws_ecs_cluster.internal-apps-cluster.id
  desired_count   = var.backend_service_desired_count
  launch_type     = var.launch_type
  load_balancer {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    container_name   = var.backend_container_name
    container_port   = var.backend_container_port
  }
}

data "template_file" "user_data" {
  template = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
  EOF
}

resource "aws_launch_template" "template" {
  name          = var.template_name
  image_id      = var.launch_template_image_id
  instance_type = var.instance_type
  iam_instance_profile {
    arn = var.launch_template_instance_profile_arn
  }
  user_data = base64encode(data.template_file.user_data.rendered)
}

resource "aws_autoscaling_group" "ASG" {
  launch_template {
    id = aws_launch_template.template.id
  }
  name = "internal-apps-asg"
  min_size              = var.asg_min_size
  max_size              = var.asg_max_size
  desired_capacity      = var.asg_desired_capacity
  vpc_zone_identifier   = var.vpc_zone_identifier
  protect_from_scale_in = var.protect_from_scale_in_boolean_value
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = var.ecs_capacity_provider_name
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ASG.arn
    managed_termination_protection = var.managed_termination_protection
    managed_scaling {
      status          = var.managed_scaling_status
      target_capacity = var.managed_scaling_target_capacity
    }
  }

}

resource "aws_ecs_cluster_capacity_providers" "aws_ecs_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.internal-apps-cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
}

resource "aws_lb_listener_rule" "frontens_listener_rule" {
  listener_arn = var.listener_arn
  action {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    type             = var.frontend_target_group_action
  }
  condition {
    host_header {
      values = var.frontend_url
    }
  }
  priority = var.frontend_listener_rule_priority_number
}

resource "aws_lb_listener_rule" "backend_listner_rule" {
  listener_arn = var.listener_arn
  action {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    type             = var.backend_target_group_action
  }
  condition {
    host_header {
      values = var.frontend_url
    }
  }
  condition {
    path_pattern {
      values = var.backend_path_pattern
    }
  }
  priority = var.backend_listener_rule_priority_number
}
