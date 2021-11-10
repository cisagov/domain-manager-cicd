# CON-PCA Data Dictionary #

This document is the data dictionary for Domain Manager stored in a MongoDB
database. This information is organized by collection (table).

## Collections ##

- [_applications_ Collection](#_applications_)
- [_domains_ Collection](#_domains_)
- [_logs_ Collection](#_logs_)
- [_templates_ Collection](#_templates_)
- [_user_ Collection](#_users_)

### _applications_ ###

This collection contains applications that can use the domain manager.
Each application is treated as a group. Individuals can be assigned to
an application group and receive permissions based on the application
groups assigned.

- _id [*UUID*]: Dynamically produced UUID for a application.
- created [*DateTime*]: The date the application was created.
- created_by [*String*]: The username of the user that created the
  application.
- updated [*DateTime*]: The date the application was last updated.
- updated_by [*String*]: The username of the user that last updated the
  application.
- name [String]: The name of the application as it will be displayed in
  the application.
- requester_name [String]: The name of the indiviudal requesting the
  application be added to the system.
- contact_name [*String*] : The name of the user to contact for information
  or permissions for a given application.
- contact_email [*String*] : The email of the user to contact for information
  or permissions for a given application.
- contact_phone [*String*] :The phone number of the user to contact for
  information or permissions for a given application.

### _domains_ ###

This is the information for standing up and securing a domain. Its current
status, related records, and history are stored here as well.

- _id [*UUID*]: Dynamically produced UUID for a domain.
- created [*DateTime*]: The date the domain was created.
- created_by [*String*]: The username of the user that created the domain.
- updated [*DateTime*]: The date the domain was last updated.
- updated_by [*String*]: The username of the user that last updated the domain.
- name [*String*]: The name of the domain. Will be used as the URL and as a
  value to append to the appropriate routing records.
- category [*String*]: The name of the template base that is assigned ot the
  domain.
- s3_url [*String*] The AWS S3 URL of the domains site. The site is a
  combination of the base template that has been assigned and the profile data
  associated with this domain.
- application_id [*String*]: The UUID associated with the currently assigned
  application.
- is_active [*Boolean*]: If the domain is currently active.
- is_approved [*Boolean*]: If the current template and profile data combination
  has been approved by an admin.
- is_available [*Boolean*]: If the domain is available for use or if its currently
  being used.
- is_launching [*Boolean*]: If the domain is in the process of being launched.
  Used to ensure a domain is not attempted to be launched multiple times.
- is_delaunching [*Boolean*]: If the domain is in the process of being taken down.
  Used to prevent attempting to take down the domain more than once.
- is_generating_template [*Boolean*]:If the domain is in the process of generating
  a template from a template base and profile data.
- is_email_active [*Boolean*]: If the domain has an active AWS SES email profile
  active.
- profile [*List(Dictionary)*]: Context data that will has been applied to the
  domains template. Will be subsituted into the template to allow for domain
  specific customization.
  - name [*String*]: The name value that will be subsituted into the template
    at the name tag.
  - city [*String*]: The city value that will be subsituted into the template
    at the city tag.
  - domain [*String*]: The domain value that will be subsituted into the
    template at the domain name tag.
  - description [*String*]: The description value that will be subsituted into
    the template at the description tag.
  - email [*String*]: The email value that will be subsituted into the template at
    the email tag.
  - phone [*String*]: The phone number value that will be subsituted into the template
    at the phone tag.
  - state [*String*]: The state value that will be subsituted into the template at
    the state tag.
- history [*List(Dictionary)*]: A log of the domain tracking when it has been used,
  including when the domain was launched and taken down.
  - application [*List(Dictionary)*]: The Application as it existed at this moment
    in time that the domain had assigned.
  - start_date [*DateTime*]: The date and time of when the domain was launched.
  - end_date [*DateTime*]: The date and time the domain was taken down after the
    history objects start_date value.
- cloudfront [*List(Dictionary)*]: The deployed domains AWS cloudfront distribution
  information.
  - distibution_endpoint [*String*]: The AWS clodfront distribution endpoint name.
  - id [*String*]: The ID for the cloudfront distribution endpoint as for reference
    to the AWS API.
- route53 [*List(Dictionary)*]: The domains collection of AWS route 53 ID's.
  - id [*String*]: A route 53 hosted zone ID.
- acm [*List(Dictionary)*]: The ACM ARN certificates associated with the domain.
  - certificate_arn [*String*]: The string value for the ACM ARN provided by AWS
    certificate manager api.
- records [*List(Dictionary)*]: A collection of domain records associated with the
  domain.
  - record_type [*String*]: The type of record associated with this entry. One of
    the following types (A,AAAA,CNAME,MX,PTR,NS,SRV,TXT,REDIRECT).
  - record_id [*String*]: The record ID used by AWS Route 53 to track this record.
  - name [*String*]: The name of the record.
  - ttl [*Integer*]: The Time To Live value associated with the record.
  - config [*List(Dictionary)*]:  Configuration setttings for the record, including
    values and protocol type.
    - value [*String*]: The value associated with this record that will be used by
      AWS route 53.
    - protocol [*String*]: The protocol type used by this record (http, https).
- category_results [*List(Dictionary)*]: A list of the domains current category proxy
  results with individuals proxy categorization services.
  - proxy [*String*]: the name of the proxy categorization service.
  - is_submitted [*Boolean*]: If the domain has been submitted to the proxy for
    categorization.
  - manually_submitted [*Boolean*]: If the domain has been manually submitted or
    if it was dynamically submitted.
  - submitted_category [*String*]: The category that the domain was submitted as
    for categorization.
  - categorize_url [*String*]: The URL for the proxy service that is being submitted
    to.
  - check_url [*String*]: The URL for checking what this proxy serivice has the domain
    currently categorized as.
  - category [*String*]: The category that this proxy has set for the domain.
- submitted_category [*String*]: The category that the domain has been or will be
  used to categorize with the proxy categorization services.

### _logs_ ###

This is a record of actions taken by users to allow for accurate histories to be
made for the system.

- _id [*UUID*]: Dynamically produced UUID for a log.
- created [*DateTime*]: The date the log entry was created.
- created_by [*String*]: The username of the user that created the log entry (will
  default to system user).
- username [*String*]: The username associated with the action that caused the log
  entry to be created.
- is_admin [*Boolean*]: If the user had admin permissions at time of attempting the
  logs action.
- status_code [*Integer*]: The status code result of the action (ex. 200 for OK,
  400 for denied)
- path [*String*]: The url associated with the action. Corresponds with the API call
  made by the uesr.
- method [*String*]: The method the API call was using (ex. get, put, post, etc)
- args [*List(Dictionary)*]: The arguments associated with the API call. typically
  an ID associated with an object in the database.
- json [*List(Dictionary)*]: A JSON formatted object provided by the user in the
  call. Contains the data of whatever the user was trying to send for that API call.
- error [*String*]: If an error occurs during the action, it will be logged here.

### _templates_ ###

This is the set of templates available within the system. Tempaltes will be html
pages or sites that have tags imbedded to allow for template customization when
a templates is assigned to a domain.

- _id [*UUID*]: Dynamically produced UUID for a template.
- created [*DateTime*]: The date the template was created.
- created_by [*String*]: The username of the user that created the template.
- updated [*DateTime*]: The date the template was last updated.
- updated_by [*String*]: The username of the user that last updated the template.
- name [*String*]: The name of the template as it will be displayed on the user
  interface.
- s3_url [*String*]: The AWS S3 Object URL for the template files. Used to
  display a demo of the template on the user interface and as the source for
  when a domain uses this template.
- is_approved [*Boolean*]: If this template has been approved by an admin for
  use by all users within a domain.

### _users_ ###

This is a collection of the systems users. It allows for tracking of user permissions,
history, and current status within the system.

- _id [*UUID*]: Dynamically produced UUID for a user.
- created [*DateTime*]: The date the user was created.
- created_by [*String*]: The username of the user that created the user (defaults
  to system made).
- updated [*DateTime*]: The date the user was last updated.
- updated_by [*String*]: The username of the user that last updated this users
  information.
- Attributes [*List(Dictionary)*]: AWS Cognito attributes associated with the user.
  - Name [*String*]: The name of the Cognito attribute associated with the user.
  - Attribute [*String*]: The value of the attribute
- Enabled [*Boolean*]: If the user is currently enabled within the systen.
- UserCreateDate [*DateTime*]: The date the user was created within the system.
- UserLastModifiedDate [*DateTime*]: The date the user was last modified.
- UserStatus [*String*]: The users current status within the system.
- Username [*String**]: The username associated with the user. Used for sign in and
  will be displayed on the user interface.
- Groups [*List(Dictionary)*]: Groups the user has assigned to them. Tied to
  applications.
- HashedAPI [*String*]: An hashed API key to use for authorization with the CLI
  version of Domain Manager.
- HasAPIKey [*Boolean*]: If the user has an API key assigned to them.
