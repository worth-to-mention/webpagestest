USE [master]
GO
/****** Object:  Database [MAD]    Script Date: 09.03.2014 14:48:24 ******/
CREATE DATABASE [MAD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MAD', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\MAD.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MAD_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\MAD_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MAD] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MAD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MAD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MAD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MAD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MAD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MAD] SET ARITHABORT OFF 
GO
ALTER DATABASE [MAD] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MAD] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MAD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MAD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MAD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MAD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MAD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MAD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MAD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MAD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MAD] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MAD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MAD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MAD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MAD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MAD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MAD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MAD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MAD] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MAD] SET  MULTI_USER 
GO
ALTER DATABASE [MAD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MAD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MAD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MAD] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [MAD]
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_CloseAuction]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_CloseAuction]
	@auctionID UNIQUEIDENTIFIER,
	@endDate DATETIME
AS
BEGIN
	
	DECLARE @tranCount INT = @@TRANCOUNT;
	IF @tranCount = 0
		BEGIN TRANSACTION;
	ELSE
		SAVE TRANSACTION CloseAuction;
	BEGIN TRY
		UPDATE [dbo].[Auctions]
		SET [IsClosed] = 1, 
		[EndDate] = @endDate
		WHERE [AuctionID] = @auctionID;

		DECLARE @lotsCount INT;
		DECLARE @currentPos INT;
		DECLARE @lotID UNIQUEIDENTIFIER;

		SELECT @lotsCount = COUNT(1)
		FROM [dbo].[Lots]
		WHERE [AuctionID] = @auctionID;

		SET @currentPos = 0;

		WHILE @currentPos < @lotsCount
		BEGIN
			SELECT @lotID = [LotID]
			FROM [dbo].[Lots]
			WHERE [AuctionID] = @auctionID
			ORDER BY [LotID]
			OFFSET @currentPos ROWS
			FETCH NEXT 1 ROWS ONLY;

			IF EXISTS (
				SELECT TOP 1 1
				FROM [dbo].[Bids]
				WHERE [LotID] = @lotID
			)
			BEGIN
				UPDATE [dbo].[Lots]
				SET [IsSold] = 1
				WHERE [LotID] = @lotID;
			END

			SET @currentPos = @currentPos + 1;
		END

		IF @tranCount = 0
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @tranCount = 0
			ROLLBACK TRANSACTION
		ELSE IF XACT_STATE() <> -1
			ROLLBACK TRANSACTION CloseAuction;

		THROW;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_CreateAuction]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_CreateAuction]
	@userID UNIQUEIDENTIFIER,
	@auctionTitle NVARCHAR(250),
	@startDate DATETIME = null,
	@endDate DATETIME = null,
	@isStarted BIT = 0,
	@auctionID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN 
	DECLARE @auction TABLE ([AuctionID] UNIQUEIDENTIFIER NOT NULL);

	INSERT INTO [dbo].[Auctions] ([AuctionID], [UserID], [Title], [StartDate], [EndDate], [IsStarted])
		OUTPUT INSERTED.[AuctionID]
		INTO @auction
	VALUES (NEWID(), @userID, @auctionTitle, @startDate, @endDate, @isStarted);
	
	SELECT TOP 1 @auctionID = [AuctionID] FROM @auction;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetActiveAuctions]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetActiveAuctions]
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [IsStarted] = 1 AND
	[IsClosed] = 0
	ORDER BY [AuctionID];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetActiveAuctionsRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetActiveAuctionsRange]
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [IsStarted] = 1 AND
	[IsClosed] = 0
	ORDER BY [AuctionID]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetAllAuctions]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetAllAuctions]
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted]
	FROM [dbo].[Auctions]
	ORDER BY [AuctionID];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetAuction]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetAuction]
	@auctionID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT TOP 1 [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [AuctionID] = @auctionID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetAuctionsRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetAuctionsRange]
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted]
	FROM [dbo].[Auctions]
	ORDER BY [AuctionID]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetStartedAuctions]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetStartedAuctions]
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [IsStarted] = 1 
	ORDER BY [AuctionID];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetUserAuction]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetUserAuction]
	@userID UNIQUEIDENTIFIER,
	@auctionID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT TOP 1 [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [AuctionID] = @auctionID AND
	[UserID] = @userID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetUserAuctions]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetUserAuctions]
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [UserID] = @userID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_GetUserAuctionsRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_GetUserAuctionsRange]
	@userID UNIQUEIDENTIFIER,
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [AuctionID],
	[UserID],
	[Title],
	[StartDate],
	[EndDate],
	[IsStarted],
	[IsClosed]
	FROM [dbo].[Auctions]
	WHERE [UserID] = @userID
	ORDER BY [AuctionID]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Auctions_StartAuction]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Auctions_StartAuction]
	@auctionID UNIQUEIDENTIFIER,
	@startDate DATETIME
AS
BEGIN
	DECLARE @started BIT;
	
	SELECT @started = [IsStarted]
	FROM [dbo].[Auctions]
	WHERE [AuctionID] = @auctionID;

	IF @started = 1
	BEGIN
		DECLARE @msg NVARCHAR(250) = 'Can not start already started auction.';
		THROW 50004, @msg, 1;
	END

	UPDATE [dbo].[Auctions]
	SET [IsStarted] = 1,
	[StartDate] = @startDate
	WHERE [AuctionID] = @auctionID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Bids_CreateBid]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Bids_CreateBid]
	@userID UNIQUEIDENTIFIER,
	@lotID UNIQUEIDENTIFIER,
	@price MONEY,
	@bidDate DATETIME,
	@bidID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	DECLARE @bid TABLE ([BidID] UNIQUEIDENTIFIER NOT NULL);

	INSERT INTO [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate])
		OUTPUT INSERTED.[BidID]
		INTO @bid
	VALUES (NEWID(), @userID, @lotID, @price, @bidDate);

	SELECT TOP 1 @bidID = [BidID] FROM @bid;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Bids_GetLotBids]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Bids_GetLotBids]
	@lotID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [BidID],
	[UserID],
	[LotID],
	[Price],
	[BidDate]
	FROM [dbo].[Bids]
	WHERE [LotID] = @lotID
	ORDER BY [BidDate] DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Bids_GetLotBidsRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Bids_GetLotBidsRange]
	@lotID UNIQUEIDENTIFIER,
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [BidID],
	[UserID],
	[LotID],
	[Price],
	[BidDate]
	FROM [dbo].[Bids]
	WHERE [LotID] = @lotID
	ORDER BY [BidDate] DESC
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Bids_GetUserBids]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Bids_GetUserBids]
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [BidID],
	[UserID],
	[LotID],
	[Price],
	[BidDate]
	FROM [dbo].[Bids]
	WHERE [UserID] = @userID
	ORDER BY [BidID];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Bids_GetUserBidsRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Bids_GetUserBidsRange]
	@userID UNIQUEIDENTIFIER,
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [BidID],
	[UserID],
	[LotID],
	[Price],
	[BidDate]
	FROM [dbo].[Bids]
	WHERE [UserID] = @userID
	ORDER BY [BidID]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Credentials_GetUserCredentials]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Credentials_GetUserCredentials]
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [Password],
	[PasswordSalt]
	FROM [dbo].[Credentials]
	WHERE [UserID] = @userID
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_CreateLot]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_CreateLot]
	@auctionID UNIQUEIDENTIFIER,
	@lotTitle NVARCHAR(250),
	@lotDescription NTEXT,
	@StartingPrice MONEY,
	@lotID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	DECLARE @lot TABLE ([LotID] UNIQUEIDENTIFIER NOT NULL);

	INSERT INTO [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold])
		OUTPUT INSERTED.[LotID]
		INTO @lot
	VALUES (NEWID(), @auctionID, @lotTitle, @lotDescription, @StartingPrice, 0);

	SELECT @lotID = [LotID] FROM @lot;	 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_DeleteLot]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_DeleteLot]
	@lotID UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @trancount INT = @@TRANCOUNT;
	IF @trancount = 0
		BEGIN TRANSACTION;
	ELSE
		SAVE TRANSACTION DeleteLot;
	BEGIN TRY
		
		DELETE FROM [dbo].[Bids]
		WHERE [LotID] = @lotID;
		
		DELETE FROM [dbo].[Lots]
		WHERE [LotID] = @lotID;

		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		IF @trancount = 0
			ROLLBACK TRANSACTION;
		ELSE IF XACT_STATE() <> -1
			ROLLBACK TRANSACTION DeleteLot;
		THROW;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_GetAuctionLots]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_GetAuctionLots]
	@auctionID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [LotID],
	[AuctionID],
	[Title],
	[Description],
	[StartingPrice],
	[IsSold]
	FROM [dbo].[Lots]
	WHERE [AuctionID] = @auctionID
	ORDER BY [Title];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_GetAuctionLotsRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_GetAuctionLotsRange]
	@auctionID UNIQUEIDENTIFIER,
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [LotID],
	[AuctionID],
	[Title],
	[Description],
	[StartingPrice],
	[IsSold]
	FROM [dbo].[Lots]
	WHERE [AuctionID] = @auctionID
	ORDER BY [Title]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_GetLot]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_GetLot]
	@lotID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [LotID],
	[AuctionID],
	[Title],
	[Description],
	[StartingPrice],
	[IsSold]
	FROM [dbo].[Lots]
	WHERE [LotID] = @lotID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_GetLotPrice]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_GetLotPrice]
	@lotID UNIQUEIDENTIFIER,
	@lotPrice MONEY OUTPUT
AS
BEGIN
	DECLARE @startingPrice MONEY;
	SELECT @startingPrice = [StartingPrice] 
	FROM [dbo].[Lots]
	WHERE [LotID] = @lotID;

	DECLARE @bidSum MONEY;
	SELECT @bidSum = CASE 
		WHEN SUM([Price]) IS NULL THEN 0
		ELSE SUM([Price])
	END
	FROM [dbo].[Bids]
	WHERE [LotID] = @LotID;

	SELECT @lotPrice = @startingPrice + @bidSum;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lots_SearchByTitle]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Lots_SearchByTitle]
	@searchString NVARCHAR(250)
AS
BEGIN
	SELECT l.[LotID],
	l.[AuctionID],
	l.[Title],
	l.[Description],
	l.[StartingPrice],
	l.[IsSold]
	FROM [dbo].[Auctions] as a
	INNER JOIN [dbo].[Lots] as l
	ON a.[AuctionID] = l.[AuctionID]
	WHERE a.[IsStarted] = 1 AND
	a.[IsClosed] = 0 AND
	l.[Title] LIKE '%' + @searchString + '%';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles_CreateRole]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Roles_CreateRole]
	@roleName NVARCHAR(100),
	@roleID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SELECT @roleID = [RoleID] FROM [dbo].[Roles] WHERE LOWER(@roleName) = LOWER([RoleName]);
	IF @roleID IS NOT NULL
	BEGIN
		DECLARE @msg NVARCHAR(250);
		SET @msg = 'Role with name ' + @roleName + ' already exist in the database.';
		THROW 50001, @msg, 1;
	END
	DECLARE @trancount INT;
	SET @trancount = @@TRANCOUNT;
	IF @trancount = 0
		BEGIN TRANSACTION;
	ELSE
		SAVE TRANSACTION InsertRole;
	BEGIN TRY
		DECLARE @roleTable TABLE ([RoleID] UNIQUEIDENTIFIER NOT NULL);
		
		INSERT INTO [dbo].[Roles] ([RoleID], [RoleName])
			OUTPUT INSERTED.RoleID
				INTO @roleTable
		VALUES (NEWID(), @roleName);

		IF @trancount = 0
			COMMIT TRANSACTION;

		SELECT TOP 1 @roleID = [RoleID] FROM @roleTable;
	END TRY
	BEGIN CATCH
		IF @trancount = 0
			ROLLBACK TRANSACTION;
		ELSE IF XACT_STATE() <> -1
			ROLLBACK TRANSACTION InsertRole;
		THROW;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles_DeleteRole]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Roles_DeleteRole]
	@roleID UNIQUEIDENTIFIER
AS
BEGIN
	DELETE FROM [dbo].[Roles]
	WHERE [RoleID] = @roleID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles_GetAllRoles]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Roles_GetAllRoles]
AS
BEGIN
	SELECT [RoleID],
	[RoleName]
	FROM [dbo].[Roles]
	ORDER BY [RoleID];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles_GetRole]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Roles_GetRole]
	@roleID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [RoleID],
	[RoleName]
	FROM [dbo].[Roles]
	WHERE [RoleID] = @roleID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles_GetRoleByName]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Roles_GetRoleByName]
	@roleName NVARCHAR(100)
AS
BEGIN
	SET @roleName = LTRIM(RTRIM(LOWER(@roleName)));
	SELECT [RoleID],
	[RoleName]
	FROM [dbo].[Roles]
	WHERE [RoleName] = @roleName;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles_GetRolesRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Roles_GetRolesRange]
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [RoleID],
	[RoleName]
	FROM [dbo].[Roles]
	ORDER BY [RoleID]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_CreateUser]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_CreateUser]
	@userName NVARCHAR(50),
	@registrationDate DATETIME,
	@lastActivityDate DATETIME,
	@isLocked BIT,
	@password NVARCHAR(128),
	@passwordSalt NVARCHAR(128),
	@userID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN	
	SELECT @userID = [UserID] FROM [dbo].[Users] WHERE LOWER(@userName) = LOWER([UserName]);
	IF @userID IS NOT NULL 
	BEGIN
		DECLARE @msg NVARCHAR(250);
		SET @msg = 'User with name ' + @userName + ' already exists in the database.';
		THROW 50000, @msg, 1;
	END 
	ELSE
	BEGIN
		DECLARE @trancount INT;
		SET @trancount = @@TRANCOUNT;
		IF @trancount = 0 
			BEGIN TRANSACTION;
		ELSE
			SAVE TRANSACTION InsertUser;
		BEGIN TRY
			DECLARE @userTable TABLE ([UserID] UNIQUEIDENTIFIER NOT NULL);

			INSERT INTO [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked])
				OUTPUT INSERTED.[UserID]
					INTO @userTable
			VALUES (NEWID(), @userName, @registrationDate, @lastActivityDate, @isLocked);
			
			SELECT TOP 1 @userID = [UserID] FROM @userTable;
			
			INSERT INTO [dbo].[Credentials] ([UserID], [Password], [PasswordSalt])
			VALUES (@userID, @password, @passwordSalt);
				
			IF @trancount = 0
				COMMIT TRANSACTION;

		END TRY
		BEGIN CATCH
			IF @trancount = 0
				ROLLBACK TRANSACTION;
			ELSE IF XACT_STATE() <> -1
				ROLLBACK TRANSACTION InsertUser;
			THROW;
		END CATCH

	END;	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_GetAllUsers]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_GetAllUsers]
AS
BEGIN
	SELECT [UserID],
	[UserName],
	[RegistrationDate],
	[LastActivityDate],
	[IsLocked]
	FROM [dbo].[Users]
	ORDER BY [UserID];
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_GetUser]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_GetUser]
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT [UserID],
	[UserName],
	[RegistrationDate],
	[LastActivityDate],
	[IsLocked]
	FROM [dbo].[Users]
	WHERE [UserID] = @userID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_GetUserByUserName]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_GetUserByUserName]
	@userName NVARCHAR(50)
AS
BEGIN
	SELECT TOP 1 [UserID],
	[UserName],
	[RegistrationDate],
	[LastActivityDate],
	[IsLocked]
	FROM [dbo].[Users]
	WHERE LOWER([UserName]) = LOWER(@userName);
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_GetUsersRange]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_GetUsersRange]
	@pageNumber INT = 0,
	@itemsPerPage INT = 20
AS
BEGIN
	SELECT [UserID],
	[UserName],
	[RegistrationDate],
	[LastActivityDate],
	[IsLocked]
	FROM [dbo].[Users]
	ORDER BY [UserID]
	OFFSET @itemsPerPage * @pageNumber ROWS
	FETCH NEXT @itemsPerPage ROWS ONLY;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_LockUser]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_LockUser]
	@userID UNIQUEIDENTIFIER,
	@lockUser BIT = 1
AS
BEGIN
	UPDATE [dbo].[Users]
	SET [IsLocked] = @lockUser
	WHERE [UserID] = @userID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users_SearchUsersByName]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Users_SearchUsersByName]
	@searchString NVARCHAR(50)
AS
BEGIN
	SET @searchString = LTRIM(RTRIM(@searchString));
	SET @searchString = '%' + LOWER(@searchString) + '%';
	SELECT [UserID],
	[UserName],
	[RegistrationDate],
	[LastActivityDate],
	[IsLocked]
	FROM [dbo].[Users]
	WHERE LOWER([UserName]) LIKE @searchString;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_AssignRoleToUser]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_AssignRoleToUser]
	@roleID UNIQUEIDENTIFIER,
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	INSERT INTO [dbo].[Users_Roles] ([UserID], [RoleID])
	VALUES (@userID, @roleID);
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_ExistUsersWithRole]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_ExistUsersWithRole]
	@roleID UNIQUEIDENTIFIER,
	@usersExist int OUTPUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[Users_Roles] WHERE [RoleID] = @roleID)
		SELECT @usersExist = 1;
	ELSE
		SELECT @usersExist = 0;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_GetUserRoles]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_GetUserRoles]
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT r.[RoleID],
	r.[RoleName]
	FROM [dbo].Roles as r
	INNER JOIN [dbo].[Users_Roles] as ur
	ON ur.[RoleID] = r.[RoleID]
	WHERE ur.[UserID] = @userID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_GetUsersWithRole]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_GetUsersWithRole]
	@roleID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT u.[UserID],
	u.[UserName],
	u.[RegistrationDate],
	u.[LastActivityDate],
	u.[IsLocked]
	FROM [dbo].[Users] as u
	INNER JOIN [dbo].[Users_Roles] as ur
	ON ur.[UserID] = u.[UserID] AND
	ur.[RoleID] = @roleID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_RemoveAllRolesFromUser]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_RemoveAllRolesFromUser]
	@userID UNIQUEIDENTIFIER
AS
BEGIN
	DELETE FROM [dbo].[Users_Roles]
	WHERE [UserID] = @userID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_RemoveRoleFromUser]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_RemoveRoleFromUser]
	@userID UNIQUEIDENTIFIER,
	@roleID UNIQUEIDENTIFIER
AS
BEGIN
	DELETE FROM [dbo].[Users_Roles]
	WHERE [UserID] = @userID AND
	[RoleID] = @roleID;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsersRoles_UserHasRole]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsersRoles_UserHasRole]
	@userID UNIQUEIDENTIFIER,
	@roleID UNIQUEIDENTIFIER,
	@result BIT OUTPUT
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Users_Roles]
		WHERE [UserID] = @userID AND
			[RoleID] = @roleID
	)
		SELECT @result = 1;
	ELSE
		SELECT @result = 0;
END
GO
/****** Object:  Table [dbo].[Auctions]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auctions](
	[AuctionID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](250) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsStarted] [bit] NOT NULL,
	[IsClosed] [bit] NOT NULL,
 CONSTRAINT [PK_Auctions] PRIMARY KEY CLUSTERED 
(
	[AuctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bids]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bids](
	[BidID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[LotID] [uniqueidentifier] NOT NULL,
	[Price] [money] NOT NULL,
	[BidDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Bids] PRIMARY KEY CLUSTERED 
(
	[BidID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Credentials]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credentials](
	[UserID] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Lots]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lots](
	[LotID] [uniqueidentifier] NOT NULL,
	[AuctionID] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](250) NOT NULL,
	[Description] [ntext] NOT NULL,
	[StartingPrice] [money] NOT NULL,
	[IsSold] [bit] NOT NULL,
 CONSTRAINT [PK_Lots] PRIMARY KEY CLUSTERED 
(
	[LotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[RegistrationDate] [datetime] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
	[IsLocked] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users_Roles]    Script Date: 09.03.2014 14:48:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_Roles](
	[UserID] [uniqueidentifier] NOT NULL,
	[RoleID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Users_Roles] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Auctions] ([AuctionID], [UserID], [Title], [StartDate], [EndDate], [IsStarted], [IsClosed]) VALUES (N'cb752b19-b59e-4c25-b0e4-431d65bcd85a', N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'Admin auction 2', CAST(0x0000A2E8012F9FF9 AS DateTime), NULL, 1, 0)
INSERT [dbo].[Auctions] ([AuctionID], [UserID], [Title], [StartDate], [EndDate], [IsStarted], [IsClosed]) VALUES (N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'Sample auction', CAST(0x0000A2E50126AA88 AS DateTime), CAST(0x0000A2E80129F688 AS DateTime), 1, 1)
INSERT [dbo].[Auctions] ([AuctionID], [UserID], [Title], [StartDate], [EndDate], [IsStarted], [IsClosed]) VALUES (N'af1b078c-505c-4550-9581-b0933e71b7f1', N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'Admin auction 3', CAST(0x0000A2E900AF7587 AS DateTime), NULL, 1, 0)
INSERT [dbo].[Auctions] ([AuctionID], [UserID], [Title], [StartDate], [EndDate], [IsStarted], [IsClosed]) VALUES (N'b105734c-fe01-4e75-bdf2-ee68a152a27a', N'd5d6a88f-e25c-4623-9ff4-d585a526da26', N'New auction', CAST(0x0000A2E400AF2FBA AS DateTime), CAST(0x0000A2E800B3BE84 AS DateTime), 1, 1)
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'43e67fba-948c-4fb3-929d-032feb6e6452', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C46D53 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'7fe4b4c8-c857-4b95-8cc1-13245b37e8c6', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C466A7 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'40175fed-b7e8-4e0c-bc7a-1424282f3d24', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C477EF AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'6167bfb9-ef8c-4884-b72d-16869436a7b1', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 50.0000, CAST(0x0000A2E600C4589B AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'c2924865-32bd-4f87-8117-1f424ed85887', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C47977 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'c97e346b-37b0-4d49-8c81-239ba89ecae8', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C47635 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'42b0db20-91c3-4e9c-a810-23b252b4c71b', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C46AAA AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'2a8953bd-4797-4138-a336-23d8ca8a0bd7', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C470D7 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'80ef1d10-9a4e-4f47-a41e-27e2e5ce0503', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C460A4 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'733c080f-6313-4537-919c-2d2cbe7e5e5d', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C473AD AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'ab725324-4b1a-4353-bf9c-2d92eca55e86', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 1500.0000, CAST(0x0000A2E600C453CA AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'7d9d713c-f1bd-4f74-b042-486a3edefb13', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C45C18 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'd23c84ac-9510-47ea-a281-5c453943e108', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 1000.0000, CAST(0x0000A2E600C44DA3 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'e206271a-330d-4095-8139-5da1e8e101ee', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C463A1 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'f4c3885f-250a-4a6f-9d26-6a22c1f34ea0', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C46977 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'15675431-2fce-4ce3-9798-80cb6f13c1ca', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C4652E AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'acf6f3a2-50ce-40b9-a658-957fdc5febff', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C46F30 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'4b09316b-433b-458f-9118-987256726873', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C4623D AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'4b3bbdb3-f879-48ae-9a67-9a3ce300c40a', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C43BDA AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'8a249cda-3059-4f7d-b8cd-9c43895f3e98', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C46808 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'f1204af1-1174-4280-9211-c0aacc3f8565', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C4723E AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'02ab91e1-4633-4fa9-9676-c31aea265356', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C45EEC AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'55e63a8c-89e6-40e9-83f2-c46b4fcffe6f', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 200.0000, CAST(0x0000A2E600C46BF0 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'a9d4ecb2-0d13-4465-bbbd-ce987ea0b47a', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'2d2ab4c0-d9b4-4f67-a191-e56074fb3e54', 50000.0000, CAST(0x0000A2E600C6FA03 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'358aab9d-0dc0-406c-a74e-df4d56d18901', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'f8796197-60b9-4816-afc2-05013053a815', 500.0000, CAST(0x0000A2E600CF5512 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'2ed45c59-531e-4795-9a89-e043ebdd100f', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'aeac5fe5-765c-4ff2-8371-db39353899bd', 150.5000, CAST(0x0000A2E600C278F3 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'f7660d72-4fa9-4f84-99c8-eb99820f84cc', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'2d2ab4c0-d9b4-4f67-a191-e56074fb3e54', 5000.0000, CAST(0x0000A2E600C6E95B AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'20878b03-502c-49bb-b8cd-ebc8748f565e', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'43bdf6e2-acc1-4c8f-8e69-d5cb82dfe2fa', 4545.0000, CAST(0x0000A2E900A68381 AS DateTime))
INSERT [dbo].[Bids] ([BidID], [UserID], [LotID], [Price], [BidDate]) VALUES (N'443566bf-e024-44b1-a397-f98f936387c3', N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'8506e64f-29c8-4d4a-9f09-07e2a249e0bb', 250.0000, CAST(0x0000A2E600C698E0 AS DateTime))
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'f6efac10-78a5-445e-8ca0-0d08e1c4766f', N'10A01CCBEAB939EB3FE15AE6906DE184', N'05DF79D88130B14AF855D12890B6C3BA142396765C0403AA6A7602C848105FBBAB1ECF0FA8017A808D2E3C2D94D227A46A6956845A658696C6402C1A7F92B0AE')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'178786663227CEF54A08C294366FED0B', N'668A2F52A8FADDD7A67E11D8113C95E2FDE0D4A0C527CB700DF47E8AC1C7AA7523B53685FB3FD987ED7E6F2B1A4404214684484348E1161BE615E135A035A8A9')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'a8198ffa-7354-478d-9c75-3b95a77bb49f', N'BFA8EAC286A7494076B99A41EDED8B02', N'DB79AFE692CBAD0AB8F4B42E573374CBD414F875784B5615C1DD104A869238A1D2C52DB910730D123AC32D2B50B1F66B8FD7176D9AAF5AFA77C1FF3F4A42958E')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'33eba2b2-3ea0-4196-86fd-7de9463cfe6d', N'6D3B5CF7D961D8ABBC54E80A50D7E2D5', N'414DD8BF1BDD2616E55D5CC688B2146B0C2EA0D10E44DD51BC7CC351EFF3CDEC3ECCF5D6C5E6961ED2850F57EED926CB4CB78FF89A3349CB9D91089B33D3D8CC')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'd8f5f629-93a4-427e-9a14-9a9a0fe1a129', N'CB4147D548EECB8ED818652642EBCF18', N'C3E1DCC76DAF32945EDEF6A604E90FF2A806C87E61E1713C3F14E4CAA77615A3C5FB758BD509F183767B99C3C93730F7109785A4D4DDD13A21D1A92D2AEF16BD')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'd5d6a88f-e25c-4623-9ff4-d585a526da26', N'3137329D629825BE4036E370816BA537', N'55ABCE9E1C100E11B1C99F2B5B8929339BED0DCCA054D0D3C7B7AE1EE0A5194BFDC66FCED91759536B62478FB0AB6A2C3ECDADE707CCD7A13CA72D51CD35857F')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'43005958-b7a8-49df-9ac7-ec33396e6ab3', N'7C18B2020D7DBBC868098DE745289CE0', N'909586477A388CF28B49CEA0202A62645F7746909D4989B94C6116DFFEAA81B7F5C2E5449C10527BAE5B2D01AD15F9909F7A980803B71B07C4EFCCC29EAA7FD3')
INSERT [dbo].[Credentials] ([UserID], [Password], [PasswordSalt]) VALUES (N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'8E3272A3C2B64FCD4D546A8B0D5569D5', N'310EFB72D0FC07F30DF986F4ED510AC2B8C99D181C186F7001BA3AC3091CAC7852545F11876AAA387FA8099E0110799077C0276DE5F0E9997FEE18B8FF0206D1')
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'f8796197-60b9-4816-afc2-05013053a815', N'b105734c-fe01-4e75-bdf2-ee68a152a27a', N'lot 2', N'lot 2 description', 200.0000, 1)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'8506e64f-29c8-4d4a-9f09-07e2a249e0bb', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 10', N'lot 10', 100.0000, 1)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'7543bfd3-8d74-4686-b017-16d3b89e1129', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 19', N'lot 19', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'034497f7-2394-4315-abc0-382e38fbe51d', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 4', N'lot 4', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'95840344-023c-4604-a5e8-3d1a9666e8c0', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 3', N'lot 3', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'ea565cc3-c088-4355-9808-42f0ccb5cbf9', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 13', N'lot 13', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'3c35de09-bb68-4da5-8403-4b6bafa2bd9c', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 18', N'lot 18', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'087ac68a-84ba-42bf-a2a5-511b7e620864', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 9', N'lot 9', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'c0dcc153-1387-434b-adba-6b6ffb2d21b9', N'af1b078c-505c-4550-9581-b0933e71b7f1', N'lot 5', N'lot 5 descr', 600.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'aec02368-e353-432b-86c6-6ca06af788cf', N'af1b078c-505c-4550-9581-b0933e71b7f1', N'lot 1', N'lot 1 descr', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'b52ba64e-bd71-4424-ac20-8634d62c29b4', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 2', N'lot 2', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'8e3fba62-6bd2-49fc-8f11-9bb84174fb16', N'b105734c-fe01-4e75-bdf2-ee68a152a27a', N'lot 1', N'lot 1 description', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'f436cac0-61a0-4d39-b3d4-a1413f5d1470', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 21', N'lot 21', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'ed67de76-35b5-4a2d-add0-a8dc44b259a2', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 7', N'lot 7', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'd9cdd2d6-afa0-423a-a34c-baca672aba71', N'af1b078c-505c-4550-9581-b0933e71b7f1', N'lot 3', N'lot 3 descr', 50.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'2b4dce18-e96c-4142-8c83-bffc15211fcd', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 20', N'lot 20', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'9aacdefb-4548-47f9-b760-c430d8af3346', N'af1b078c-505c-4550-9581-b0933e71b7f1', N'lot 2', N'lot 2 descr', 150.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'3f1cc7b8-f21c-464c-87eb-cbcb40dd0361', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 14', N'lot 14', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'83b8e46f-4404-42a0-a58c-cd20f08d4438', N'af1b078c-505c-4550-9581-b0933e71b7f1', N'lot 4', N'lot 4 descr', 200.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'43bdf6e2-acc1-4c8f-8e69-d5cb82dfe2fa', N'cb752b19-b59e-4c25-b0e4-431d65bcd85a', N'lot 1', N'lot 1 desc', 1000.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'aeac5fe5-765c-4ff2-8371-db39353899bd', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 1', N'lot 1', 100.0000, 1)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'2d2ab4c0-d9b4-4f67-a191-e56074fb3e54', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 11', N'lot 11', 100.0000, 1)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'f0eed953-3a72-4b31-b6fa-e6931202c2cc', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 15', N'lot 15', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'6ab168c9-f22c-4fbf-90bc-e8cbf5a8cf8f', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 17', N'lot 17', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'0c4fcdd8-3ce3-44dd-88bc-ec223ee15aee', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 5', N'lot 5', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'9f4bfe24-a840-4a61-af2c-ed3612a9abbf', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 16', N'lot 16', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'1f5f0408-6eee-4f91-bc5c-f1df51e69a2f', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 12', N'lot 12', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'c85abc33-f24e-43cb-b5f6-f4e94b241587', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 8', N'lot 8', 100.0000, 0)
INSERT [dbo].[Lots] ([LotID], [AuctionID], [Title], [Description], [StartingPrice], [IsSold]) VALUES (N'bc302c30-ea68-4281-b4f2-fc45e7aa9c50', N'ab30a9f2-a128-4e83-9202-a82eb042e1bf', N'lot 6', N'lot 6', 100.0000, 0)
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (N'fda566ac-c1b8-4dea-b393-3d9ffce6aa49', N'Administrators')
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (N'9085222b-f771-4f87-abde-b2a10a59a5b0', N'Bidders')
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (N'662e0958-209c-458c-bbd3-e53b23baaf19', N'Auctioneers')
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'f6efac10-78a5-445e-8ca0-0d08e1c4766f', N'bidder2', CAST(0x0000A2E6012CF89A AS DateTime), CAST(0x0000A2E6012CF89A AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'user', CAST(0x0000A2DF012FA5F4 AS DateTime), CAST(0x0000A2DF012FA5F4 AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'a8198ffa-7354-478d-9c75-3b95a77bb49f', N'bidder3', CAST(0x0000A2E6012D6262 AS DateTime), CAST(0x0000A2E6012D6262 AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'33eba2b2-3ea0-4196-86fd-7de9463cfe6d', N'user3', CAST(0x0000A2E6011A096D AS DateTime), CAST(0x0000A2E6011A096D AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'd8f5f629-93a4-427e-9a14-9a9a0fe1a129', N'auctioneer1', CAST(0x0000A2E6012EF283 AS DateTime), CAST(0x0000A2E6012EF283 AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'd5d6a88f-e25c-4623-9ff4-d585a526da26', N'user2', CAST(0x0000A2E000FEF212 AS DateTime), CAST(0x0000A2E000FEF212 AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'43005958-b7a8-49df-9ac7-ec33396e6ab3', N'bidder', CAST(0x0000A2E6012CBFD5 AS DateTime), CAST(0x0000A2E6012CBFD5 AS DateTime), 0)
INSERT [dbo].[Users] ([UserID], [UserName], [RegistrationDate], [LastActivityDate], [IsLocked]) VALUES (N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'admin', CAST(0x0000A2E501231451 AS DateTime), CAST(0x0000A2E501231451 AS DateTime), 0)
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'f6efac10-78a5-445e-8ca0-0d08e1c4766f', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'fda566ac-c1b8-4dea-b393-3d9ffce6aa49')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'd92bf519-42ac-4533-85f5-27e5a7bbb9b9', N'662e0958-209c-458c-bbd3-e53b23baaf19')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'a8198ffa-7354-478d-9c75-3b95a77bb49f', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'33eba2b2-3ea0-4196-86fd-7de9463cfe6d', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'd8f5f629-93a4-427e-9a14-9a9a0fe1a129', N'662e0958-209c-458c-bbd3-e53b23baaf19')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'd5d6a88f-e25c-4623-9ff4-d585a526da26', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'd5d6a88f-e25c-4623-9ff4-d585a526da26', N'662e0958-209c-458c-bbd3-e53b23baaf19')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'43005958-b7a8-49df-9ac7-ec33396e6ab3', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'fda566ac-c1b8-4dea-b393-3d9ffce6aa49')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'9085222b-f771-4f87-abde-b2a10a59a5b0')
INSERT [dbo].[Users_Roles] ([UserID], [RoleID]) VALUES (N'4391a3ef-5280-4f3f-8cd5-f15bc9fee592', N'662e0958-209c-458c-bbd3-e53b23baaf19')
ALTER TABLE [dbo].[Auctions] ADD  DEFAULT ((0)) FOR [IsStarted]
GO
ALTER TABLE [dbo].[Auctions] ADD  CONSTRAINT [DF_Auctions_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [dbo].[Lots] ADD  DEFAULT (N'Lot title') FOR [Title]
GO
ALTER TABLE [dbo].[Lots] ADD  DEFAULT (N'Lot description') FOR [Description]
GO
ALTER TABLE [dbo].[Lots] ADD  DEFAULT ((0)) FOR [IsSold]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsLocked]  DEFAULT ((0)) FOR [IsLocked]
GO
ALTER TABLE [dbo].[Auctions]  WITH CHECK ADD  CONSTRAINT [FK_Auctions_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Auctions] CHECK CONSTRAINT [FK_Auctions_Users]
GO
ALTER TABLE [dbo].[Bids]  WITH CHECK ADD  CONSTRAINT [FK_Bids_Lots] FOREIGN KEY([LotID])
REFERENCES [dbo].[Lots] ([LotID])
GO
ALTER TABLE [dbo].[Bids] CHECK CONSTRAINT [FK_Bids_Lots]
GO
ALTER TABLE [dbo].[Bids]  WITH CHECK ADD  CONSTRAINT [FK_Bids_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Bids] CHECK CONSTRAINT [FK_Bids_Users]
GO
ALTER TABLE [dbo].[Credentials]  WITH CHECK ADD  CONSTRAINT [FK_Credentials_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Credentials] CHECK CONSTRAINT [FK_Credentials_Users]
GO
ALTER TABLE [dbo].[Lots]  WITH CHECK ADD  CONSTRAINT [FK_Lots_Auctions] FOREIGN KEY([AuctionID])
REFERENCES [dbo].[Auctions] ([AuctionID])
GO
ALTER TABLE [dbo].[Lots] CHECK CONSTRAINT [FK_Lots_Auctions]
GO
ALTER TABLE [dbo].[Users_Roles]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[Users_Roles] CHECK CONSTRAINT [FK_Users_Roles_Roles]
GO
ALTER TABLE [dbo].[Users_Roles]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Users_Roles] CHECK CONSTRAINT [FK_Users_Roles_Users]
GO
USE [master]
GO
ALTER DATABASE [MAD] SET  READ_WRITE 
GO
