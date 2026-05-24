provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "myfirstinstance" {
    ami           = "ami-0b6c6ebed2801a5cb"
    instance_type = "m7i-flex.large"
    subnet_id     = "subnet-0f356ddbb0f90faa9"

    tags = {
        Name = "first-instance"
    }
}
