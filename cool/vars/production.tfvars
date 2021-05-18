#=================================================
#  PROVIDER
#=================================================
shared_services_role = "arn:aws:iam::121087745329:role/ProvisionPrivateDNSRecords"
workspace_type = "production"
account_id = "779871898657"

#=================================================
#  CORE
#=================================================
env = "prod"
app = "domain-manager"
region = "us-east-1"

#=================================================
#  EMAILS NOTIFICATIONS
#=================================================
new_user_notification_email_address = "CISA.CSD.VM_Assessments_DomainManagement@cisa.dhs.gov"

#=================================================
#  ROUTE 53
#=================================================
internal_route53_record = "domain-manager.cool.cyber.dhs.gov"

#=================================================
#  DOCKER
#=================================================
image_url = "779871898657.dkr.ecr.us-east-1.amazonaws.com"

#=================================================
#  LOGS
#=================================================
log_retention_days = 7

#=================================================
#  LOAD BALANCING
#=================================================
idle_timeout = 600

#=================================================
#  DOCUMENTDB
#=================================================
documentdb_cluster_size = 1
documentdb_instance_class = "db.r5.large"

#=================================================
#  API
#=================================================
api_image_repo = "domain-manager-api"
api_cpu = 2048
api_memory = 4096
api_desired_count = 1

#=================================================
#  UI
#=================================================
ui_image_repo = "domain-manager-ui"
ui_cpu = 2048
ui_memory = 4096
ui_desired_count = 1

#=================================================
#  BROWSERLESS
#=================================================
browserless_cpu = 512
browserless_memory = 1024
browserless_count = 1