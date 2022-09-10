resource "aws_internet_gateway" "test-igw" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    tags = {
        Name = "test-igw"
    }
}

resource "aws_route_table" "test-public-crt" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.test-igw.id}" 
    }
    
    tags = {
        Name = "test-public-crt"
    }
}

resource "aws_route_table_association" "test-crta-public-subnet"{
    subnet_id = "${aws_subnet.test-subnet-public.id}"
    route_table_id = "${aws_route_table.test-public-crt.id}"
}


resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh-allowed"
    }
}

resource "aws_instance" "web" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"
    # VPC
    subnet_id = "${aws_subnet.test-subnet-public.id}"
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.sydney-region-key-pair.id}"
    # nginx installation
    provisioner "file" {
        source = "nginx.sh"
        destination = "/tmp/nginx.sh"
    }
    provisioner "remote-exec" {
        inline = [
             "chmod +x /tmp/nginx.sh",
             "sudo /tmp/nginx.sh"
        ]
    }
    connection {
        user = "${var.EC2_USER}"
        private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
    }
}

// Sends your public key to the instance
resource "aws_key_pair" "sydney-region-key-pair" {
    key_name = "sydney-region-key-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}