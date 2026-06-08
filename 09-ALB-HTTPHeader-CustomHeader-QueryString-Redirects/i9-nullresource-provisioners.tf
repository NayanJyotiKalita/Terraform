# Create a Null Resource and Provisioners
resource "null_resource" "cluster" {
  depends_on    = [ module.ec2_bastion ]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.public_elastic_ip.public_ip
    user        = "ec2-user"  # use ubuntu if you are using ubuntu linux for your ami or you can use root if you are using the root user
    password    = ""
    private_key = file("oregon-key.pem")
  }

# File Provisioner: Copies the oregon-key.pem file to /tmp/oregon-key.pem
  provisioner "file" {
    source      = "oregon-key.pem"
    destination = "/tmp/oregon-key.pem"
  }

# Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" { 
    inline      = [
      "sudo chmod 400 /tmp/oregon-key.pem"
    ]
  } 

# Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command     = "echo Public EC2 created on Instance ID: ${module.ec2_bastion.id} and `data`  >> creation-time-public-ec2-id"
    working_dir = "local-exec-output-files/"
  }

/*
# Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command = "echo Destroy time prov `date` >> destroy-time-provider.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    #on_failure = continue
  }  
*/
}
# Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)