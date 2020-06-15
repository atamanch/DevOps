variable "region" {
    default = "us-east-1"
}
variable "private_key_path"{
    default = "C:/AWS/Keys/MyUSE1KP"
}
locals {
    availability_zone = "${var.region}a"
}