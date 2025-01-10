resource "random_integer" "random" {
  min = 1
  max = 5
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "techsavvybucket${random_integer.random.result}"
}