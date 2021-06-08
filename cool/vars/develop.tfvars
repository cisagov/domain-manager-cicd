#=================================================
#  PROVIDER
#=================================================
workspace_type = "develop"

#=================================================
#  CORE
#=================================================
env = "develop"
app = "domain-manager"
region = "us-east-1"

#=================================================
#  NETWORKING
#=================================================
private_subnet_ids = [
    "subnet-0153f175feb0dfce5",
    "subnet-02f0f6199dd75238b"
]

public_subnet_ids = [
    "subnet-0a365c16b67a2b6b0",
    "subnet-0ea8f699bed93417c"
]

vpc_id = "vpc-074f7db64238a2d16"

#=================================================
#  EMAILS NOTIFICATIONS
#=================================================
ses_from = "domainmanager-develop@cyber.dhs.gov"
new_user_notification_email_address = "domainmanager-aaaacmecaofdaenpbzd4gkrxoq@cset-group.slack.com"

#=================================================
#  ROUTE 53
#=================================================
hosted_zone_name = "inltesting.xyz"
internal_route53_record = "domain-manager.develop.inltesting.xyz"

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
