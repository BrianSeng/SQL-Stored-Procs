
ALTER PROCEDURE [dbo].[ReferralCodes_Insert_v2]
	@UserId nvarchar(128)
	, @Code nvarchar(50)
	, @Value nvarchar(50)
	, @TimeStamp datetime2(7)
	, @CreatedDate datetime2(7) = null
	, @IsAnonymous bit
	, @ExternalReferrer nvarchar(150) = null
	, @TargetPage nvarchar(150) = null
AS
/* TEST CODE

DECLARE @UserId nvarchar(128) = 'dbfffdf4-ee58-44ce-abca-006689ffa842'
		, @Code nvarchar(50) = 'campaign'
		, @Value nvarchar(50) = 'blue'
		, @TimeStamp datetime2(7) = GETUTCDATE()
		, @CreatedDate datetime2(7) = null
		, @IsAnonymous bit = 'False'
		, @ExternalReferrer nvarchar(150) = 'www.wordpress.com'
		, @TargetPage nvarchar(150) = 'lashgirl.dev'

EXECUTE dbo.[ReferralCodes_Insert_v2]
		@UserId
		, @Code
		, @Value
		, @TimeStamp
		, @CreatedDate
		, @IsAnonymous
		, @ExternalReferrer
		, @TargetPage

SELECT * FROM dbo.ReferralCodes
	WHERE UserId = @UserId

*/
BEGIN
	DECLARE @KeywordId int = 
	(SELECT [Id] 
	FROM [dbo].[ReferralCodeLookUp]
	WHERE [Code] = @Code)
	
	IF (@CreatedDate IS NULL)
	BEGIN
		SET @CreatedDate = GETUTCDATE()
	END

	INSERT INTO dbo.ReferralCodes
				([UserId]
				, [KeywordId]
				, [Value]
				, [TimeStamp]
				, [CreatedDate]
				, [IsAnonymous]
				, [ExternalReferrer]
				, [TargetPage])
	VALUES
				(@UserId
				, @KeywordId
				, @Value
				, @TimeStamp
				, @CreatedDate
				, @IsAnonymous
				, @ExternalReferrer
				, @TargetPage)
			
END
