
ALTER PROCEDURE [dbo].[ReferralCodes_SelectReferrersByMonth] 
				@StartDate datetime2(7)
AS

/*		TEST CODE

DECLARE @StartDate datetime2(7) = '2017-05-01'

EXECUTE [dbo].[ReferralCodes_SelectReferrersByMonth]
		@StartDate

*/

BEGIN
	;with RefCTE as 
	(
		SELECT  [Value]
				,COUNT([Value]) AS [TotalReferralCount]
				,SUM(CASE [KeywordId] WHEN 1 THEN 1 ELSE 0 END) AS [CampaignCount]
				,SUM(CASE [KeywordId] WHEN 2 THEN 1 ELSE 0 END) AS [SourceCount]
				,SUM(CASE [KeywordId] WHEN 3 THEN 1 ELSE 0 END) AS [ReferrerCount]
				,SUM(CASE [KeywordId] WHEN 4 THEN 1 ELSE 0 END) AS [RegistrationCount]

		FROM dbo.ReferralCodes
		WHERE [TimeStamp] >= @StartDate
		AND [TimeStamp] < DATEADD(Month, 1, @StartDate)
		GROUP BY [Value]
	)

	Select TOP (10) *
	From RefCTE

	ORDER BY [TotalReferralCount] DESC
END
