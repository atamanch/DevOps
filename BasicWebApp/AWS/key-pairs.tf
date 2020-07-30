resource "aws_key_pair" "deployer" {
  key_name = "deploy"
  public_key = file(var.ssh_public_key)
}