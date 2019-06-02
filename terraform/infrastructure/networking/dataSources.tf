data "aws_vpc" "vpc_environment" {
  tags{
      Name = "AWS-VPC-16"
  }
}


output "aws_vpc" {
	value = "${data.aws_vpc.vpc_environment.id}"
}
