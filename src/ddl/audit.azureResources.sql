SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE SCHEMA audit
GO

CREATE TABLE [audit].[azureResources](
	[resourceID] [varchar](500) NOT NULL,
	[resourceName] [varchar](255) NOT NULL,
	[resourceKind] [varchar](255) NULL,
	[resourceType] [varchar](255) NULL,
	[resourceTags] [varchar](255) NULL,
	[resourceGroupName] [varchar](255) NULL,
	[resourceLocation] [varchar](255) NULL,
	[subscriptionID] [varchar](255) NULL,
	[resourceSku] [varchar](255) NULL,
	[subscriptionName] [varchar](255) NULL,
	[dateCreated] [date] NULL,
	[isDeleted] [bit] NULL,
	[modifiedDate] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [audit].[azureResources] ADD PRIMARY KEY CLUSTERED 
(
	[resourceID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [audit].[azureResources] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
