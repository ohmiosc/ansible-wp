data "aws_route53_zone" "maseducacionDnsZone"{
    name = "maseducacion.com."
}

data "aws_route53_zone" "g3cDnsZone"{
    name = "g3c.pe."
}
