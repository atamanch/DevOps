# Variables

variable "location" {
    default = "EastUS"
}

variable "ssh_public_key" {
    default = "C:/Azure/keys/MyUSE1KP.pub"
}

variable "tags" {
    type = map

    default = {
        Environment = "Production"
        Group = "Finance"
        Criticality = "Critical"
    }
}