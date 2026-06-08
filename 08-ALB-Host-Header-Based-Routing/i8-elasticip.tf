resource "aws_eip" "public_elastic_ip" {
  # The elastic ip needs to be attached to the ec2 instance so it needs to wait till the instance comes up
  # The eip also needs to send traffic outside the vpc via the igw so it needs to wait till the vpc with the igw to come up
  depends_on = [ module.ec2_bastion, module.vpc ]  

  instance   = module.ec2_bastion.id
  domain     = "vpc"
  tags       = local.common_tags


  provisioner "local-exec" {
    command     = "echo Destroy time provider `date` >> destroy-time-provider.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure = continue
}

}

