# Define el proveedor de nube
provider "aws" {
  #Establece una region 
  region = "us-east-2"
}
# Indica la definicion de un security group, y le asigna un nombre para poder ser llamdo en el main.tf
resource "aws_security_group" "anctec_instance_centos" {
  #Nombre que será asignado al sg en aws
  name = var.sg_name
  dynamic "ingress"{#reglas de ingreso al sg que serán leidas desde el archivo de variables prod.tfvars
     for_each = var.ingress_rules
     content { 
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks #aws_vpc.main.cidr_block

     }

 }
  dynamic "egress"{#reglas de Egreso al sg que serán leidas desde el archivo de variables prod.tfvars
    for_each = var.egress_rules
     content { 
        from_port   = egress.value.from_port
        to_port     = egress.value.to_port
        protocol    = egress.value.protocol
        cidr_blocks = egress.value.cidr_blocks #aws_vpc.main.cidr_block

     }

 }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_instance" "centos-instance" {# declara un  recurso instacia aws, y le asigna un nombre para acceso local en el codigo fuente
  ami = var.ami_id # Asigna una ami que pasada por variable y que debe existir en Aws
  instance_type = var.instance_type # Typo de instancia, para la capa gratuita de aws, utilzar t2.micro
  key_name = var.key_pair_name  # define la llave que será utilizada para acceder a la instancia y que fue creada previamente en la consola aws
  tags = var.tags # Buscando definicion 
  security_groups = ["${aws_security_group.anctec_instance_centos.name}"] # Asigna a la instancia el SG definido al comienzo el archivo
  #provisioner "remote-exec"{ # hace una coneccion remota a la instancia una vez que se encuentra corriendo, falta afinar coneccion 
  #  connection{
  #    type =  "ssh"
  #    user = "centos"
  #    #private_key = file("~/.ssh/id_rsa")
  #    host = self.public_ip
  #  }
  #  inline = ["echo hello "]
  #} 
  #{
   # Name = "practica1"
    #Environment = "Dev"
  #}
}
