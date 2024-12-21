module "cart" {
  source              = "git::https://github.com/rajashekhar-a/terraform-mutable.git//app-module"
  SPOT_INSTANCE_TYPE  = var.SPOT_INSTANCE_TYPE
  INSTANCE_TYPE       = var.INSTANCE_TYPE
  SPOT_INSTANCE_COUNT = var.SPOT_INSTANCE_COUNT
  OD_INSTANCE_COUNT   = var.OD_INSTANCE_COUNT
  COMPONENT           = "cart"
  PORT                = 8080
  IS_PRIVATE_LB       = "true"
}
