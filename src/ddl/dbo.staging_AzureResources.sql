SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[staging_AzureResources](
	[resourceName] [varchar](255) NULL,
	[resourceId] [varchar](255) NULL,
	[resourceKind] [varchar](255) NULL,
	[resourceType] [varchar](255) NULL,
	[resourceTags] [varchar](255) NULL,
	[resourceGroupName] [varchar](255) NULL,
	[resourceLocation] [varchar](255) NULL,
	[subscriptionID] [varchar](255) NULL,
	[resourceSku] [varchar](255) NULL,
	[subscriptionName] [varchar](255) NULL
) ON [PRIMARY]
GO
