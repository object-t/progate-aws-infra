locals {
  name_prefix = "progate"

  availability_zones = {
    "1a" = {
      az_name       = "ap-northeast-1a"
      public_octet  = 1
      private_octet = 11
    },
    "1c" = {
      az_name       = "ap-northeast-1c"
      public_octet  = 2
      private_octet = 12
    }
  }
}