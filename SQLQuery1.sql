-- Data Cleaning Project

-- Data is fetched at each cleaning phase to understand how data is cleaned at each stage

--Unclean Data

Select * from [dbo].[Nashville_housing_data_2013_201$]

--Remove duplicate, unwanted columns and Rename columns

EXEC sp_rename '[dbo].[Nashville_housing_data_2013_201$]','NashvilleHousingData';

ALTER TABLE [dbo].[NashvilleHousingData] DROP COLUMN F1, image,city

EXEC sp_rename '[dbo].[NashvilleHousingData].[Unnamed: 0]','ID','COLUMN';

EXEC sp_rename '[dbo].[NashvilleHousingData].[Suite/ Condo   #]', 'PresentCondosSuits','COLUMN';

Select * from [dbo].[NashvilleHousingData]

--Remove decimals from ParcelID and Replace Null values with 0 for Present Suits Or Condos

--The data type of Parcel ID is nvarchar

UPDATE [dbo].[NashvilleHousingData] SET [Parcel ID] = REPLACE([Parcel ID],'.','')

UPDATE [dbo].[NashvilleHousingData] SET [Parcel ID]=  REPLACE([Parcel ID],' ','') 

Select SUBSTRING([Parcel ID],1,LEN([Parcel ID])-2), ISNULL([PresentCondosSuits],0) from [dbo].[NashvilleHousingData]

UPDATE [dbo].[NashvilleHousingData] SET [Parcel ID] = SUBSTRING([Parcel ID],1,LEN([Parcel ID])-2)

UPDATE [dbo].[NashvilleHousingData] SET [PresentCondosSuits] = ISNULL([PresentCondosSuits],0)

Select * from [dbo].[NashvilleHousingData] 

--Removing duplicate Parcel entries

Select  [Parcel ID], COUNT([Parcel ID]) FROM [dbo].[NashvilleHousingData] group by [Parcel ID] having COUNT([Parcel ID]) >1

DELETE  FROM [dbo].[NashvilleHousingData] WHERE [ID] IN ( Select MAX([ID]) FROM [dbo].[NashvilleHousingData] Group by [Parcel ID] Having COUNT([Parcel ID])>1 )

-- Populating the Address data in reference to Property Address Data

Select [Property Address],[Address],ISNULL([Address],[Property Address]) AS OwnerAddress FROM [dbo].[NashvilleHousingData]

UPDATE [dbo].[NashvilleHousingData] SET [Address] = ISNULL([Address],[Property Address])

Select * from [dbo].[NashvilleHousingData]

--Changing the Sale Date and Sale Price Format

Select [Sale Date], CONVERT(Date, [Sale Date]) FROM [dbo].[NashvilleHousingData]

ALTER TABLE [dbo].[NashvilleHousingData] ADD SaleDateNew Date

UPDATE [dbo].[NashvilleHousingData] SET [SaleDateNew] = CONVERT(Date, [Sale Date])

ALTER TABLE [dbo].[NashvilleHousingData] DROP COLUMN [Sale Date]

Select FORMAT([Sale Price],'C') FROM [dbo].[NashvilleHousingData]

ALTER TABLE [dbo].[NashvilleHousingData] ADD SalePriceNew NVARCHAR(25)

UPDATE [dbo].[NashvilleHousingData] SET [Sale Price]= CAST([Sale Price] AS NVARCHAR(30))

UPDATE [dbo].[NashvilleHousingData] SET [SalePriceNew] = FORMAT([Sale Price],'C')

ALTER TABLE [dbo].[NashvilleHousingData] DROP COLUMN  [Sale Price]

Select * from [dbo].[NashvilleHousingData]

--Dividing the Property Address into Plot Number and Street Name

Select TRIM(TRANSLATE([Property Address],'0123456789', '          ')) AS StreetName, TRANSLATE([Property Address], TRANSLATE([Property Address],'0123456789', '          '), SPACE(LEN(TRANSLATE([Property Address],'0123456789', '          ')))) AS PlotNumber FROM [dbo].[NashvilleHousingData]

ALTER TABLE [dbo].[NashvilleHousingData] ADD  StreetName NVARCHAR(100)

ALTER TABLE [dbo].[NashvilleHousingData] ADD PlotNumber NVARCHAR(50)

UPDATE [dbo].[NashvilleHousingData] SET [StreetName] = TRIM(TRANSLATE([Property Address],'0123456789', '          ' ))

UPDATE [dbo].[NashvilleHousingData] SET [PlotNumber] =  TRANSLATE([Property Address], TRANSLATE([Property Address],'0123456789', '          '), SPACE(LEN(TRANSLATE([Property Address],'0123456789', '          '))))

ALTER TABLE [dbo].[NashvilleHousingData] DROP COLUMN [Address]

Select * from [dbo].[NashvilleHousingData]

-- Cleaned Dataset

Select * from [dbo].[NashvilleHousingData]


















