USE Master
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'PubsBISolutionsMetaData')
  BEGIN
     -- Close connections to the DB 
    ALTER DATABASE [PubsBISolutionsMetaData] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    -- and drop the DB
    DROP DATABASE [PubsBISolutionsMetaData]
  END
Go
-- Now re-make the DB
CREATE DATABASE [PubsBISolutionsMetaData]
GO
USE [PubsBISolutionsMetaData]
GO

-- And add the core tables --
CREATE TABLE [dbo].[ObjectTypes](
	[ObjectTypeId] [int] NOT NULL,
	[ObjectTypeName] [nvarchar](1000) NULL,
	[ObjectDescription] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ObjectTypes] PRIMARY KEY CLUSTERED 
  ( [ObjectTypeId] ASC )
)
GO

CREATE TABLE [dbo].[DWObjects](
	[DWObjectId] [int] NOT NULL,
	[DWObjectName] [nvarchar](100) NULL,
	[ObjectTypeId] [int] NULL,
	[CurrentlyUsed] [bit] NULL,
 CONSTRAINT [PK_DWObjects] PRIMARY KEY CLUSTERED 
  ( [DWObjectId] ASC )
) 
GO

CREATE TABLE [dbo].[SSISObjects](
	[SSISObjectId] [int] NOT NULL,
	[SSISObjectName] [nvarchar](100) NULL,
	[ObjectTypeId] [int] NULL,
	[CurrentlyUsed] [bit] NULL,
 CONSTRAINT [PK_SSISObjects] PRIMARY KEY CLUSTERED 
  ( [SSISObjectId] ASC )
)
GO

CREATE TABLE [dbo].[SSASObjects](
	[SSASObjectId] [int] NOT NULL,
	[SSASObjectName] [nvarchar](100) NULL,
	[ObjectTypeId] [int] NULL,
	[CurrentlyUsed] [bit] NULL,
 CONSTRAINT [PK_SSASObjects] PRIMARY KEY CLUSTERED 
  ( [SSASObjectId] ASC )
)
GO

CREATE TABLE [dbo].[ExcelReportObjects](
	[ExcelReportObjectId] [int] NOT NULL,
	[ExcelReportObjectName] [nvarchar](100) NULL,
	[ObjectTypeId] [int] NULL,
	[CurrentlyUsed] [bit] NULL,
 CONSTRAINT [PK_ExcelReportObjects] PRIMARY KEY CLUSTERED 
  ( [ExcelReportObjectId] ASC )
) 
GO

CREATE TABLE [dbo].[SSRSObjects](
	[SSRSObjectId] [int] NOT NULL,
	[SSRSObjectName] [nvarchar](100) NULL,
	[ObjectTypeId] [int] NULL,
	[CurrentlyUsed] [bit] NULL,
 CONSTRAINT [PK_SSRSObjects] PRIMARY KEY CLUSTERED 
( [SSRSObjectId] ASC )
)
GO

-- and their relationship tables --
CREATE TABLE [dbo].[DWToSSISObjects](
	[DWObjectId] [int] NOT NULL,
	[SSIDObjectID] [int] NOT NULL,
 CONSTRAINT [PK_DWToSSISObjects] PRIMARY KEY CLUSTERED 
  ( [DWObjectId] ASC,	[SSIDObjectID] ASC )
)
GO

CREATE TABLE [dbo].[DWToSSASObjects](
	[DWObjectId] [int] NOT NULL,
	[SSASObjectId] [int] NOT NULL,
 CONSTRAINT [PK_DWToSSASObjects] PRIMARY KEY CLUSTERED 
  ( [DWObjectId] ASC,	[SSASObjectId] ASC )
)
GO

CREATE TABLE [dbo].[DWToExcelReportObjects](
	[DWObjectId] [int] NOT NULL,
	[ExcelReportObjectId] [int] NOT NULL,
 CONSTRAINT [PK_DWToExcelReportObjects] PRIMARY KEY CLUSTERED 
  ( [DWObjectId] ASC, [ExcelReportObjectId] ASC ) 
) 
GO
CREATE TABLE [dbo].[DWtoSSRSObjects](
	[DWObjectId] [int] NOT NULL,
	[SSRSObjectId] [int] NOT NULL,
 CONSTRAINT [PK_DWtoSSRSObjects] PRIMARY KEY CLUSTERED 
  ( [DWObjectId] ASC,	[SSRSObjectId] ASC )
)
GO

CREATE TABLE [dbo].[SSASToSSRSObjects](
	[SSASObjectId] [int] NOT NULL,
	[SSRSObjectId] [int] NOT NULL,
 CONSTRAINT [PK_SSASToSSRSObjects] PRIMARY KEY CLUSTERED 
  ( [SSASObjectId] ASC, [SSRSObjectId] ASC )
)
GO

-- Create the FKs to the ObjectTypes domain table --
ALTER TABLE [dbo].[DWObjects]
  ADD CONSTRAINT [FK_DWObjects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
  REFERENCES [dbo].[ObjectTypes] ([ObjectTypeId])
GO

ALTER TABLE [dbo].[SSISObjects]
  ADD  CONSTRAINT [FK_SSISObjects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
  REFERENCES [dbo].[ObjectTypes] ([ObjectTypeId])
GO

ALTER TABLE [dbo].[SSASObjects]
  ADD CONSTRAINT [FK_SSASObjects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
  REFERENCES [dbo].[ObjectTypes] ([ObjectTypeId])
GO

ALTER TABLE [dbo].[ExcelReportObjects]
  ADD CONSTRAINT [FK_ExcelReportObjects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
  REFERENCES [dbo].[ObjectTypes] ([ObjectTypeId])
GO

ALTER TABLE [dbo].[SSRSObjects]
  ADD  CONSTRAINT [FK_SSRSObjects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
  REFERENCES [dbo].[ObjectTypes] ([ObjectTypeId])
GO

-- Create the FKs to the all the relationship tables --
-- From DWToExcelReportObjects
ALTER TABLE [dbo].[DWToExcelReportObjects]
  ADD CONSTRAINT [FK_DWToExcelReportObjects_DWObjects] FOREIGN KEY([DWObjectId])
  REFERENCES [dbo].[DWObjects] ([DWObjectId])
GO

ALTER TABLE [dbo].[DWToExcelReportObjects]
  ADD CONSTRAINT [FK_DWToExcelReportObjects_ExcelReportObjects] FOREIGN KEY([ExcelReportObjectId])
  REFERENCES [dbo].[ExcelReportObjects] ([ExcelReportObjectId])
GO

-- From DWToSSASObjects
ALTER TABLE [dbo].[DWToSSASObjects]
  ADD  CONSTRAINT [FK_DWToSSASObjects_DWObjects] FOREIGN KEY([DWObjectId])
  REFERENCES [dbo].[DWObjects] ([DWObjectId])
GO

ALTER TABLE [dbo].[DWToSSASObjects]
  ADD CONSTRAINT [FK_DWToSSASObjects_SSASObjects] FOREIGN KEY([SSASObjectId])
  REFERENCES [dbo].[SSASObjects] ([SSASObjectId])
GO

-- From DWToSSISObjects
ALTER TABLE [dbo].[DWToSSISObjects]
  ADD CONSTRAINT [FK_DWToSSISObjects_DWObjects] FOREIGN KEY([DWObjectId])
  REFERENCES [dbo].[DWObjects] ([DWObjectId])
GO

ALTER TABLE [dbo].[DWToSSISObjects] 
ADD CONSTRAINT [FK_DWToSSISObjects_SSISObjects] FOREIGN KEY([SSIDObjectID])
REFERENCES [dbo].[SSISObjects] ([SSISObjectId])
GO

-- From DWtoSSRSObjects
ALTER TABLE [dbo].[DWtoSSRSObjects]
  ADD CONSTRAINT [FK_DWtoSSRSObjects_DWObjects] FOREIGN KEY([DWObjectId])
  REFERENCES [dbo].[DWObjects] ([DWObjectId])
GO

ALTER TABLE [dbo].[DWtoSSRSObjects] 
  ADD CONSTRAINT [FK_DWtoSSRSObjects_SSRSObjects] FOREIGN KEY([SSRSObjectId])
  REFERENCES [dbo].[SSRSObjects] ([SSRSObjectId])
GO

-- From SSASToSSRSObjects
ALTER TABLE [dbo].[SSASToSSRSObjects]
ADD  CONSTRAINT [FK_SSASToSSRSObjects_SSASObjects] FOREIGN KEY([SSASObjectId])
REFERENCES [dbo].[SSASObjects] ([SSASObjectId])
GO

ALTER TABLE [dbo].[SSASToSSRSObjects]
ADD  CONSTRAINT [FK_SSASToSSRSObjects_SSRSObjects] FOREIGN KEY([SSRSObjectId])
REFERENCES [dbo].[SSRSObjects] ([SSRSObjectId])
GO


