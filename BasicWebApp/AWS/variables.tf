variable "region" {
    default = "us-east-1"
}

variable "alb_logs_s3_bucket"{
    default = ""
}

locals {
    availability_zone_a = "${var.region}a"
    availability_zone_b = "${var.region}b"
}