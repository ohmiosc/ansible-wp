module "certificate_alb" {
  source = "git::ssh://git@bitbucket.org/orbisunt/terraform-aws-module-certificate.git"
  domain_name           = "*.maseducacion.com"
  subject_alternative_names = "${var.domain_for_certificate_product}"
  hosted_zone_id        = "${data.aws_route53_zone.maseducacionDnsZone.zone_id}"
  validation_record_ttl = "60"
}

module "certificate_cdn" {
  source = "git::ssh://git@bitbucket.org/orbisunt/terraform-aws-module-certificate.git"
  domain_name           = "*.maseducacion.g3c.pe"
  subject_alternative_names = ["${var.domain_for_certificate_cdn}"]
  hosted_zone_id        = "${data.aws_route53_zone.g3cDnsZone.zone_id}"
  validation_record_ttl = "60"
}