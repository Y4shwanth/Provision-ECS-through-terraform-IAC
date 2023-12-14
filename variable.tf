# name of cluster as defined by user, could be anything.
variable "cluster_name" {}

# launch type here means either EC2 or FARGATE
variable "launch_type" {}

# name of launch template as defined by user, could be anything
variable "template_name" {}

# image-id for creating launch template. format: ami-0c94855ba95c71c99
variable "launch_template_image_id" {}

# type of instance to launch template. format: t3a.medium
variable "instance_type" {}

# minimum number of instances to be in auto scaling group
variable "asg_min_size" {}

# maximum number of instances to be in auto scaling group
variable "asg_max_size" {}

# desired number of instances to be in auto scaling group
variable "asg_desired_capacity" {}

# (Optional) List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with availability_zones
variable "vpc_zone_identifier" {}

# name of  capacity provider as defined by user, could be anything.
variable "ecs_capacity_provider_name" {}

# network mode: bridge or awsvpc
variable "network_mode" {}

#arn of instance profile for launch template 
variable "launch_template_instance_profile_arn" {}

#user defined. could be anything
variable "frontend_task_def_name" {}

#user defined. could be anything
variable "frontend_service_name" {}

#user defined. could be anything
variable "frontend_container_name" {}

#specify the frontend container port,required for load balancer
variable "frontend_container_port" {}

#user defined. could be anything
variable "backend_task_def_name" {}

#user defined. could be anything
variable "backend_service_name" {}

#user defined. could be anything
variable "infra_apps_role_name" {}

#policy document to be assumed by role that we attach to task definitions
variable "assume_role_policy" {}

#json document includes all details related to your container:- what are all the env you need to pass,port mapping if any,.important part
variable "frontend_container_definition" {}

#json document includes all details related to your container:- what are all the env you need to pass,port mapping if any,.important part
variable "backend_container_definition" {}

# desired count for frontend ecs service
variable "frontend_service_desired_count" {}

# desired count for backend ecs service
variable "backend_service_desired_count" {}

#just a name , user defined . could be anything
variable "infra_policy_name" {}

#file contains policies that needs to be assumed by role that we attach to TD
variable "infra_policy_file" {}

#arn of load balancer listener inside which you want to add rule to forward req to appropriate TG
variable "listener_arn" {}

#URL for your frontend that your clients want to use
variable "frontend_url" {}

# name of backend container as defined in container definition
variable "backend_container_name" {}

# port on backend container
variable "backend_container_port" {}

# url for backend service
variable "backend_url" {}

# action to consider while creating rule in listner for frontend(like: forward,redirect)
variable "frontend_target_group_action" {}

# action to consider while creating rule in listner for backend(like: forward,redirect)
variable "backend_target_group_action" {}

#path pattern for backend url
variable "backend_path_pattern" {}

#user defined. could be anything
variable "frontend_target_group_name" {}

#
variable "frontend_target_group_protocol" {}

#
variable "frontend_target_group_port" {}

#
variable "vpc_id_to_create_frontend_target_group" {}

#
variable "frontend_target_group_protocol_version" {}

#
variable "frontend_target_group_target_type" {}

#user defined. could be anything
variable "backend_target_group_name" {}

#
variable "backend_target_group_protocol" {}

#
variable "backend_target_group_port" {}

#
variable "vpc_id_to_create_backend_target_group" {}

#
variable "backend_target_group_protocol_version" {}

#
variable "backend_target_group_target_type" {}

#
variable "frontend_listener_rule_priority_number" {}

#
variable "backend_listener_rule_priority_number" {}

#
variable "protect_from_scale_in_boolean_value" {}

#
variable "managed_termination_protection" {}

#
variable "managed_scaling_status" {}

#
variable "managed_scaling_target_capacity" {}
