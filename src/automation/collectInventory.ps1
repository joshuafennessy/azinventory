$tenantId = Get-AutomationVariable -Name 'tenantID'
$subscriptionId = Get-AutomationVariable -Name 'subscriptionID'
$certThumbrint = Get-AutomationVariable -Name 'certThumbprint'
$applicationId = Get-AutomationVariable -Name 'applicationID'

Login-AzureRmAccount -TenantId $tenantId -ServicePrincipal -CertificateThumbprint $certThumbrint -ApplicationId $applicationId
Select-AzureRmSubscription -SubscriptionId $subscriptionId

$subscriptionName = "BG Dev/Test"

#get a list of all the current Azure resources
$resources = Get-AzureRmResource #| Export-Csv "bgdevtest_resources.csv"

#retrive the sql Database connection parameters
$serverInstance = Get-AutomationVariable -Name 'serverInstance'
$databaseName = Get-AutomationVariable -Name 'databaseName'
$dbUserName = Get-AutomationVariable -Name 'dbUserName'
$dbUserPassword = Get-AutomationVariable -Name 'dbUserPassword'

#truncate the staging table
Invoke-Sqlcmd `
    -ServerInstance $serverInstance `
    -Database $databaseName `
    -UserName $dbUserName `
    -Password $dbUserPassword `
    -Query "TRUNCATE TABLE dbo.staging_AzureResources"

#loop through and insert each resource
foreach($resource in $resources) {

    $resourceName = $resource.Name
    $resourceID = $resource.ResourceId
    $resourceKind = $resource.Kind
    $resourceType = $resource.ResourceType
    $resourceTags = ""
    $resourceGroupName = $resource.ResourceGroupName
    $resourceLocation = $resource.Location
    $resourceSubscriptionID = $resource.SusbscriptionId
    $resourceSKU = $resource.Sku

    try
    {
        $insertQuery = "INSERT INTO  dbo.staging_AzureResources VALUES('$resourceName', '$resourceId', '$resourceKind', '$resourceType', '$resourceTags', '$resourceGroupName', '$resourceLocation', '$resourceSubscriptionID', '$resourceSku', '$subscriptionName')"

        Invoke-Sqlcmd `
        -ServerInstance $serverInstance `
        -Database $databaseName `
        -UserName $dbUserName `
        -Password $dbUserPassword `
        -Query $insertQuery `
        -ErrorAction stop
    }
    catch {
        Write-Output "Error writing resource [$resourceName] from resource group [$resourceGroupName] to staging table: $_"
        
    }    
}

Invoke-SqlCmd `
    -ServerInstance $serverInstance `
    -Database $databaseName `
    -UserName $dbUserName `
    -Password $dbUserPassword `
    -Query "exec audit.updateAzureResources"