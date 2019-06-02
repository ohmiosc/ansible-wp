
data "aws_vpc" "vpc_environment" {
  tags{
      Name = "${var.vpc_name}"
  }
}

data "aws_subnet_ids" "private_subnets" {
    vpc_id = "${data.aws_vpc.vpc_environment}"

    tags = {
        Tier = "Private"
    }
}
