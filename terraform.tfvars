org_name="organization"

roles=["admin", "developer"]
sub_accounts=["operations","production","staging","testing","development","forensics"]

//workspace_roles = {
//  operations  = "arn:aws:iam::OPERATIONS-ACCOUNT-ID:role/terraform"
//  production  = "arn:aws:iam::PRODUCTION-ACCOUNT-ID:role/terraform"
//  staging     = "arn:aws:iam::STAGING-ACCOUNT-ID:role/terraform"
//  testing     = "arn:aws:iam::TESTING-ACCOUNT-ID:role/terraform"
//  devemopment = "arn:aws:iam::DEVELOPMENT-ACCOUNT-ID:role/terraform"
//  forensics   = "arn:aws:iam::FORENSICS-ACCOUNT-ID:role/terraform"
//}

state_profile = "test-tf" # TODO revisit in docs
