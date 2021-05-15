resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name        = "my_vpc-${terraform.workspace}"
    environment = terraform.workspace

  }
}

resource "aws_subnet" "public" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.az_names[count.index]
  tags = {
    Name        = "public${count.index}_${terraform.workspace}"
    environment = terraform.workspace
  }
}

resource "aws_subnet" "private" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, local.az_count + count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.az_names[count.index]
  tags = {
    Name        = "private${count.index}_${terraform.workspace}"
    environment = terraform.workspace
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "my_igw"
    environment = terraform.workspace
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "public-rt"
  }
}
resource "aws_route_table_association" "a" {
  count          = local.az_count
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "prirt" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "b" {
  count          = local.az_count
  subnet_id      = local.pri_sub_ids[count.index]
  route_table_id = aws_route_table.prirt.id
}
resource "aws_sns_topic" "status_checks" {
  name = "status_checks"
}
