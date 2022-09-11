variable "AWS_REGION" {
  default = "ap-southeast-2"

}
variable "AMI" {
  type = map(any)
  default = {
    "ap-southeast-2" = "ami-0672b175139a0f8f4"
    "us-east-1"      = "ami-0c2a1acae6667e438"
  }
}
variable "PUBLIC_KEY" {
  default = "files/jenkins-aws.pem"
}
locals {
  ssh_private_key_content = file(var.ssh_private_key_file)
}