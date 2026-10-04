resource "aws_instance" "web" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.trialKey.key_name
  vpc_security_group_ids = [aws_security_group.trial-sg.id]
  availability_zone      = var.availability_zone

  tags = {
    Name = var.instance_name
  }
}

resource "aws_ec2_instance_state" "web-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}