# azinventory
Automated inventory collection and reporting for Azure subscriptions. This is a simple solution that can be run as little as every 5 minutes to be able to capture activity in your Azure subscription.

This solution uses a service principal with a authentication certificate. A RunAsUser created within your Azure Automation Runbook can also be used.

This solution runs in Azure and requries the following resources.

+ Azure Automation Account
+ Azure SQL DB

# Setup Procedure

1. Create Azure SQL DB and deploy database scripts to create the required tables and stored procedures
2. Create an Azure Automation account
3. Create an Azure Service Principal
4. Assign authentication certificated to Azure Service Principal
5. Assign Reader access to entire subscription for Azure Service Principal
6. Create and populate Azure Runbook variables
7. Deploy Azure Automation Runbook and test
8. Open Power BI template and enter in connection info

## Azure Automation Variables
To set up your Azure Automation account create the following variables (encryption recommended)

Variable Name | Description
---|---
tenantID | (guid) Tenant ID of your Azure Subscription
subscriptionID | (guid) Subscription ID to be monitored
certThumbprint | (text) Cert thumbrint of the service principal
applicationID | (guid) The Application ID of the service principal
serverInstance | (text) The server name where the Azure SQL DB is hosted
databaseName | (text) The name of the az inventory collection database
dbUserName | (text) User Name (sql auth) with write and execute access
dbUserPassed | (text) Corresponding user password
