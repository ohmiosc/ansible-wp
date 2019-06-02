module "balancer" {
  source          = "git::ssh://git@bitbucket.org/orbisunt/terraform-module-balancer.git"

  owner           = "maseducacion"
  env             = "${var.env}"
  security_groups = ["${module.sg_balancer.id}"]
  subnets         = ["${var.public}"]
  acm             = "${data.aws_acm_certificate.balancerCertificate.arn}"
  protect         = false
}

module "sg_balancer" {
  source  = "git::ssh://git@bitbucket.org/orbisunt/terraform-module-securitygroup.git"

  owner   = "${var.owner}"
  project = "balancer"
  env     = "${var.env}"
}

module "sg_balancer_rule" {
  source            = "git::ssh://git@bitbucket.org/orbisunt/terraform-module-securitygroup-rule.git"

  ports             = ["80", "443"]
  protocol          = "tcp"
  security_group_id = "${module.sg_balancer.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}