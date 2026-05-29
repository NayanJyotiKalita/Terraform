# We can provide different values for different configurations if we want and these values will overtake the values mentioned in the variables.tf file
# We have kept the values same as what we kept in the variables file but we can change them however we want 
vpc_name = "myvpc"
vpc_cidr_block = "10.0.0.0/16"
vpc_azs = ["us-west-2a", "us-west-2b"]
vpc_public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
vpc_database_subnets= ["10.0.21.0/24", "10.0.22.0/24"]
vpc_create_database_subnet_group = true 
vpc_create_database_subnet_route_table = true   
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = false
vpc_one_nat_gateway_per_az = true
