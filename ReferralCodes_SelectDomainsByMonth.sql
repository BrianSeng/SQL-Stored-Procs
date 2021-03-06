
ALTER PROCEDURE [dbo].[ReferralCodes_SelectDomainsByMonth]
	@StartDate datetime2(7)
	
AS
/* TEST CODE

DECLARE @StartDate datetime2(7) = '04-01-2017'

EXECUTE [dbo].[ReferralCodes_SelectDomainsByMonth]
		@StartDate

*/
BEGIN
	SELECT TOP (7)
		CASE WHEN CHARINDEX('/',[ExternalReferrer],9) = 0 
			THEN [ExternalReferrer]
			ELSE LEFT ([ExternalReferrer], CHARINDEX('/',[ExternalReferrer],9)-1)
		END AS [Domain]
		, COUNT(*) AS [ReferralCount]

	FROM dbo.ReferralCodes
	WHERE [TimeStamp] >= @StartDate
	AND [TimeStamp] < DATEADD(Month, 1, @StartDate)

	GROUP BY
		CASE WHEN CHARINDEX('/',[ExternalReferrer],9) = 0 
			THEN [ExternalReferrer]
			ELSE LEFT ([ExternalReferrer], CHARINDEX('/',[ExternalReferrer],9)-1)
		END
	ORDER BY [ReferralCount] ASC
END
