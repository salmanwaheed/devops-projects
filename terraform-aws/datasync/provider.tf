provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

provider "aws" {
  profile = "default"
  region  = "me-central-1"
  alias   = "uae"
}
