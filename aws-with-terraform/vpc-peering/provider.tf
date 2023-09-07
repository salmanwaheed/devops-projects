provider "aws" {
  profile = "default"
  region  = local.region # me-central-1 does not support AWS Network Manager (Reachability Analyzer)
}
