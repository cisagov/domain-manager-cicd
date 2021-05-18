#=================================================
#  PROVIDER
#=================================================
workspace_type = "staging"

#=================================================
#  CORE
#=================================================
env = "staging"
app = "domain-manager"
region = "us-east-1"

#=================================================
#  EMAILS NOTIFICATIONS
#=================================================
new_user_notification_email_address = "domainmanager-aaaacmecaofdaenpbzd4gkrxoq@cset-group.slack.com"

#=================================================
#  ROUTE 53
#=================================================
internal_route53_record = "domain-manager.staging.cool.cyber.dhs.gov"

#=================================================
#  DOCKER
#=================================================
image_url = "719488448316.dkr.ecr.us-east-1.amazonaws.com"

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
documentdb_instance_class = "db.t3.medium"

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