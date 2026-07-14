environment                        = "dev"
vpc_name                           = "myvpc"
vpc_cidr                           = "10.0.0.0/16"
vpc_azs                            = [ "us-east-2a", "us-east-2b", "us-east-2c" ]
public_subnets                     = [ "10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24" ]
private_subnets                    = [ "10.0.161.0/24", "10.0.162.0/24", "10.0.163.0/24" ]
database_subnets                   = [ "10.0.171.0/24", "10.0.172.0/24", "10.0.173.0/24" ]
create_database_subnet_group       = true
create_database_subnet_route_table = true
enable_nat_gateway                 = true
single_nat_gateway                 = true
one_nat_gateway_per_az             = false
instance_type                      = "t3.micro"
key_name                           = "oregon-vn"
private_instance_count             = 2
dns_name                           = "dev-iac.vinodnayan.academy"

