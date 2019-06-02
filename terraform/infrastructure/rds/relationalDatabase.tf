
module "aurora" {
  source                          = "git::ssh://git@bitbucket.org/orbisunt/terraform-aws-module-rds.git"
  name                            = "maseducacion-${var.environment}"
  engine                          = "${var.database_engine}"
  engine_version                  = "${var.database_engine_version}"
  subnets                         = "${data.aws_subnet_ids.private_subnets}"
  vpc_id                          = "${data.aws_vpc.selected.id}"
  replica_count                   = 1
  instance_type                   = "${var.db_instance_type}"
  apply_immediately               = "${var.apply_inmediately}"
  skip_final_snapshot             = "${var.skip_final_snapshot}"
  db_parameter_group_name         = "${aws_db_parameter_group.maesducacion_db_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.maseducacion_cluster_parameter_group.id}"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
}

resource "aws_db_parameter_group" "maesducacion_db_parameter_group" {
  name        = "maseducacion-db-${var.environment}-parameter-group"
  family      = "${var.parameter_group_family}"
  description = "Parameter Group Optimizado para MásEducación"
}

resource "aws_rds_cluster_parameter_group" "maseducacion_cluster_parameter_group" {
  name        = "maseducacion-cluster-${var.environment}-parameter-group"
  family      = "${var.parameter_group_family}"
  description = "Clúster Parameter Group Optimizado para MásEducación"
}

resource "aws_security_group" "app_servers" {
  name        = "app-servers"
  description = "For application servers"
  vpc_id      = "${data.aws_vpc.selected.id}"
}

resource "aws_security_group_rule" "allow_access" {
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.app_servers.id}"
  security_group_id        = "${module.aurora.this_security_group_id}"
}

# IAM Policy for use with iam_database_authentication = true
resource "aws_iam_policy" "aurora_mysql_policy_iam_auth" {
  name = "test-aurora-db-57-policy-iam-auth"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource": [
        "arn:aws:rds-db:us-east-1:123456789012:dbuser:${module.aurora.this_rds_cluster_resource_id}/jane_doe"
      ]
    }
  ]
}
POLICY
}