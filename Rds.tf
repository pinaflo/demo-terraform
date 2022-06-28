# Create RDS Instance
resource "aws_db_instance" "mydbtritek" {
  allocated_storage    = 12
  engine               = "mysql"
  db_subnet_group_name = aws_db_subnet_group.mydbsubgroup.name
  engine_version       = "5.7"
  port                 = "3306"
  instance_class       = "db.t2.micro"
  name                 = "mydbtritek"
  username             = "pinaflo"
  password             = "Jjfloberkoh"
vpc_security_group_ids = [aws_security_group.my-security-group.id]
  multi_az             = false
  skip_final_snapshot  = true
}


# Create DB Subnet Group
resource "aws_db_subnet_group" "mydbsubgroup" {
  name       = "mydbsubgroup"
  subnet_ids = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id, aws_subnet.private-subnet-3.id]


  tags = {
    Name = "mydbsubgroup"
  }
}
