# Set up a Domain for Con-PCA

1. If you haven't already, purchase your domain at a registrar (i.e. NameCheap, GoDaddy, etc)
2. Login to Domain Management and click on `Domains` on the left
3. Click on `Add New Domain` button on the top right and type in the domain you've purchased

    <img src="images/add-new-domain.png" width="250">

    - This will create a hosted zone for your domain so that Domain Management can manage your domain's DNS records and content.

4. Once your domain has been created, click on your domain and then click the `Hosted Zone` tab

    <img src="images/hosted-zones.png" width="250">

    - You'll find four nameservers (NS) similar to the ones highlighted in the picture above.
    - Copy these nameservers, without the `.` period at the end of each line, and paste them into your registrar under your purchased domain.

5. You can now manage DNS records for the domain under the `DNS Records` tab

    <img src="images/dns-records.png" width="250">

    - You can add Email records that can be used with Con-PCA