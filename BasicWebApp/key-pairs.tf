resource "aws_key_pair" "deployer" {
  key_name = "deploy"
  public_key = "ssh-rsa insert your public key here"
}