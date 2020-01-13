SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [audit].[updateAzureResources]
AS
BEGIN

--insert new resources not currently in the table
INSERT INTO [audit].[azureResources]
SELECT
	b.resourceId,
	b.resourceName,
	b.resourceKind,
	b.resourceType,
	b.resourceTags,
	b.resourceGroupName,
	b.resourceLocation,
	b.subscriptionId,
	b.resourceSku,
	b.subscriptionName,
	CONVERT(DATE, GETDATE()) as dateCreated,
	0 AS isDeleted,
	GETDATE() as modifiedDate
FROM
	[audit].azureResources a
RIGHT JOIN
	dbo.staging_AzureResources b on a.ResourceId = b.ResourceId
WHERE
	a.ResourceId IS NULL

--mark any non-existent resources as deleted
UPDATE [audit].azureResources
SET isDeleted = 1,
    modifiedDate = GETDATE()
WHERE
	resourceID NOT IN (SELECT DISTINCT resourceId FROM dbo.staging_AzureResources)
AND 
	isDeleted = 0

--undelete any resources that have previously been deleted
UPDATE [audit].azureResources
SET isDeleted = 0,
    modifiedDate = GETDATE()
WHERE
	resourceID IN (SELECT DISTINCT resourceId FROM dbo.staging_AzureResources)
AND isDeleted = 1


END
GO
