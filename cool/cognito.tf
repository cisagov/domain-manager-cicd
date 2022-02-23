#=================================================
#  COGNITO
#=================================================
resource "aws_cognito_user_pool" "pool" {
  name = "${var.app}-${var.env}-users"
  tags = local.tags

  #auto_verified_attributes = ["email"]
  #email_verification_subject = "[Domain Manager] Verify your Email"
  #email_verification_message = "Thank you for signing up on Domain Manager. Please verify your email address within 24 hours. Your verification code is: {####}"
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "${var.app}-${var.env}-client"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin", "email", "openid", "phone", "profile"]
  callback_urls                        = ["https://${aws_lb.alb.dns_name}", "https://${aws_route53_record.sharedservices_internal_domainmanager.name}"]
  explicit_auth_flows                  = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
  logout_urls                          = ["https://${aws_lb.alb.dns_name}", "https://${aws_route53_record.sharedservices_internal_domainmanager.name}"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.app}-${var.env}"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Managed by Terraform"
}
