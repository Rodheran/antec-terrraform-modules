provider "aws" {
  region = "us-east-2"
}
resource "aws_security_group" "ssh_conection" {
  name = var.sg_name
  dynamic "ingress"{
     for_each = var.ingress_rules
     content { 
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks #aws_vpc.main.cidr_block

     }

 }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "anctec-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIe3pkqT0aJjxdc3pV694snRsDsjv7cLA1shWeFrPEQinEL1OfOwDoHuVwLOUpMiosuLF2pqAK39iSO24GV393wewHjfMCfOtAkTAHTO68Vpy8yEAja4PF35A1IqeLbEnRgBJQBUJ5I5Tta2zoXLQnt6RzsmmCfevgD6SDEIGKlWRnMqr8pXPyflvj/PbHI1vqqOT2mjHepYpjsFtw5d9bS0UEzbZKhLWMSl+QkTUaxtwTTrAS/fs1urE4+437/jP/hmfruaVTcEbX/IMtdbLfPZheCPD3Ieyrg65ZKm9jb0Pwxhe1LD/wHZYSV4fFfvQLYGfhMqPdFF+Qn4MtSKT adolf@DESKTOP-U6EP53Q"
}

resource "aws_instance" "platzi-instance" {
  #ami = "ami-076db09ea35d146b6"
  ami = var.ami_id
  instance_type = var.instance_type
  tags= var.tags 
  security_groups = ["${aws_security_group.ssh_conection.name}"]
  
  #{
   # Name = "practica1"
    #Environment = "Dev"
  #}
}