variable "region" {
    default = "us-east-1"
}

variable "ssh_public_key"{
    default = "C:/AWS/Keys/MyKP.pub"
}

variable "alb_logs_s3_bucket"{
    default = ""
}

locals {
    availability_zone_a = "${var.region}a"
    availability_zone_b = "${var.region}b"
}