# Domain Manager Data Dictionary #

This document is the data dictionary for Domain Manager stored in a MongoDB
database. This information is organized by collection (table).

## Collections ##

- [Application](#applications)
- [Domain](#domains)
- [Logs](#logs)
- [Template](#templates)
- [User](#users)

### Applications ###

This collection contains applications that can use the domain manager.
Each application is treated as a group. Individuals can be assigned to
an application group and receive permissions based on the application
groups assigned.

- _id: uuid = Dynamically produced UUID for a application.
- created: datetime = The date the application was created.
- created_by: string = The username of the user that created the
  application.
- updated: datetime = The date the application was last updated.
- updated_by: string = The username of the user that last updated the
  application.
- name: string = The name of the application as it will be displayed in
  the application.
- requester_name: string = The name of the individual requesting the
  application be added to the system.
- contact_name: string = The name of the user to contact for information
  or permissions for a given application.
- contact_email: string = The email of the user to contact for information
  or permissions for a given application.
- contact_phone: string =The phone number of the user to contact for
  information or permissions for a given application.

### Domains ###

This is the information for standing up and securing a domain. Its current
status, related records, and history are stored here as well.

- _id: uuid = Dynamically produced UUID for a domain.
- created: datetime = The date the domain was created.
- created_by: string = The username of the user that created the domain.
- updated: datetime = The date the domain was last updated.
- updated_by: string = The username of the user that last updated the domain.
- name: string = The name of the domain. Will be used as the URL and as a
  value to append to the appropriate routing records.
- category: string = The name of the template base that is assigned ot the
  domain.
- s3_url: string = The AWS S3 URL of the domains site. The site is a
  combination of the base template that has been assigned and the profile data
  associated with this domain.
- application_id: string = The UUID associated with the currently assigned
  application.
- is_active: boolean = If the domain is currently active.
- is_approved: boolean = If the current template and profile data combination
  has been approved by an admin.
- is_available: boolean = If the domain is available for use or if its currently
  being used.
- is_launching: boolean = If the domain is in the process of being launched.
  Used to ensure a domain is not attempted to be launched multiple times.
- is_delaunching: boolean = If the domain is in the process of being taken down.
  Used to prevent attempting to take down the domain more than once.
- is_generating_template: boolean =If the domain is in the process of generating
  a template from a template base and profile data.
- is_email_active: boolean = If the domain has an active AWS SES email profile
  active.
- profile: list of dictionaries = Context data that will has been applied to the
  domains template. Will be substituted into the template to allow for domain
  specific customization.
  - name: string = The name value that will be substituted into the template
    at the name tag.
  - city: string = The city value that will be substituted into the template
    at the city tag.
  - domain: string = The domain value that will be substituted into the
    template at the domain name tag.
  - description: string = The description value that will be substituted into
    the template at the description tag.
  - email: string = The email value that will be substituted into the template at
    the email tag.
  - phone: string = The phone number value that will be substituted into the template
    at the phone tag.
  - state: string = The state value that will be substituted into the template at
    the state tag.
- history: list of dictionaries = A log of the domain tracking when it has been used,
  including when the domain was launched and taken down.
  - application: list of dictionaries = The Application as it existed at this moment
    in time that the domain had assigned.
  - start_date: datetime = The date and time of when the domain was launched.
  - end_date: datetime = The date and time the domain was taken down after the
    history objects start_date value.
- cloudfront: list of dictionaries = The deployed domains AWS cloudfront distribution
  information.
  - distribution_endpoint: string = The AWS cloudfront distribution endpoint name.
  - id: string = The ID for the cloudfront distribution endpoint as for reference
    to the AWS API.
- route53: list of dictionaries = The domains collection of AWS route 53 ID's.
  - id: string = A route 53 hosted zone ID.
- acm: list of dictionaries = The ACM ARN certificates associated with the domain.
  - certificate_arn: string = The string value for the ACM ARN provided by AWS
    certificate manager api.
- records: list of dictionaries = A collection of domain records associated with the
  domain.
  - record_type: string = The type of record associated with this entry. One of
    the following types (A,AAAA,CNAME,MX,PTR,NS,SRV,TXT,REDIRECT).
  - record_id: string = The record ID used by AWS Route 53 to track this record.
  - name: string = The name of the record.
  - ttl: integer = The Time To Live value associated with the record.
  - config: list of dictionaries =  Configuration settings for the record, including
    values and protocol type.
    - value: string = The value associated with this record that will be used by
      AWS route 53.
    - protocol: string = The protocol type used by this record (http, https).
- category_results: list of dictionaries = A list of the domains current category proxy
  results with individuals proxy categorization services.
  - proxy: string = the name of the proxy categorization service.
  - is_submitted: boolean = If the domain has been submitted to the proxy for
    categorization.
  - manually_submitted: boolean = If the domain has been manually submitted or
    if it was dynamically submitted.
  - submitted_category: string = The category that the domain was submitted as
    for categorization.
  - categorize_url: string = The URL for the proxy service that is being submitted
    to.
  - check_url: string = The URL for checking what this proxy service has the domain
    currently categorized as.
  - category: string = The category that this proxy has set for the domain.
- submitted_category: string = The category that the domain has been or will be
  used to categorize with the proxy categorization services.

### Logs ###

This is a record of actions taken by users to allow for accurate histories to be
made for the system.

- _id: uuid = Dynamically produced UUID for a log.
- created: datetime = The date the log entry was created.
- created_by: string = The username of the user that created the log entry (will
  default to system user).
- username: string = The username associated with the action that caused the log
  entry to be created.
- is_admin: boolean = If the user had admin permissions at time of attempting the
  logs action.
- status_code: integer = The status code result of the action (ex. 200 for OK,
  400 for denied)
- path: string = The url associated with the action. Corresponds with the API call
  made by the user.
- method: string = The method the API call was using (ex. get, put, post, etc)
- args: list of dictionaries = The arguments associated with the API call. typically
  an ID associated with an object in the database.
- json: list of dictionaries = A JSON formatted object provided by the user in the
  call. Contains the data of whatever the user was trying to send for that API call.
- error: string = If an error occurs during the action, it will be logged here.

### Templates ###

This is the set of templates available within the system. Templates will be html
pages or sites that have tags imbedded to allow for template customization when
a templates is assigned to a domain.

- _id: uuid = Dynamically produced UUID for a template.
- created: datetime = The date the template was created.
- created_by: string = The username of the user that created the template.
- updated: datetime = The date the template was last updated.
- updated_by: string = The username of the user that last updated the template.
- name: string = The name of the template as it will be displayed on the user
  interface.
- s3_url: string = The AWS S3 Object URL for the template files. Used to
  display a demo of the template on the user interface and as the source for
  when a domain uses this template.
- is_approved: boolean = If this template has been approved by an admin for
  use by all users within a domain.

### Users ###

This is a collection of the systems users. It allows for tracking of user permissions,
history, and current status within the system.

- _id: uuid = Dynamically produced UUID for a user.
- created: datetime = The date the user was created.
- created_by: string = The username of the user that created the user (defaults
  to system made).
- updated: datetime = The date the user was last updated.
- updated_by: string = The username of the user that last updated this users
  information.
- Attributes: list of dictionaries = AWS Cognito attributes associated with the user.
  - Name: string = The name of the Cognito attribute associated with the user.
  - Attribute: string = The value of the attribute
- Enabled: boolean = If the user is currently enabled within the system.
- UserCreateDate: datetime = The date the user was created within the system.
- UserLastModifiedDate: datetime = The date the user was last modified.
- UserStatus: string = The users current status within the system.
- Username: string = The username associated with the user. Used for sign in and
  will be displayed on the user interface.
- Groups: list of dictionaries = Groups the user has assigned to them. Tied to
  applications.
- HashedAPI: string = An hashed API key to use for authorization with the CLI
  version of Domain Manager.
- HasAPIKey: boolean = If the user has an API key assigned to them.
