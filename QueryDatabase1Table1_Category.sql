USE [SportGoods]
GO

/****** Object:  Table [dbo].[Category]    Script Date: 20.11.2022 14:50:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Category](
	[categoryID] [int] NOT NULL,
	[categoryName] [varchar](30) NOT NULL,
	[description] [varchar](50) NOT NULL,
	[departmentID] [int] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[categoryID] ASC,
	[categoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Category] ADD  DEFAULT ('Сергей') FOR [categoryName]
GO

ALTER TABLE [dbo].[Category] ADD  DEFAULT ('Петров') FOR [description]
GO

-----------------------------------------------------------
USE [SportGoods]
GO

SELECT TOP 5000
	   [categoryID]
      ,[categoryName]
      ,[description]
      ,[departmentID]
  FROM [dbo].[Category]

GO