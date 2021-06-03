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
#  Resources
#=================================================
cpu = 2048
memory = 4096
desired_count = 1

#=================================================
#  API
#=================================================
api_image_repo = "domain-manager-api"

#=================================================
#  UI
#=================================================
ui_image_repo = "domain-manager-ui"
