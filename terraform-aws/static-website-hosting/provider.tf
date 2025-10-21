provider "aws" {
  profile = "default"
  region  = "me-central-1"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias   = "virginia"
}
