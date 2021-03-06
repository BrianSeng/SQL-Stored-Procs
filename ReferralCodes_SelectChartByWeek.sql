
ALTER PROC [dbo].[ReferralCodes_SelectChartByWeek]
			@Code nvarchar(50)
			, @WeekNumber int

AS

/*		TEST CODE

DECLARE @Code nvarchar(50) = 'campaign'
		, @WeekNumber int = 17

EXECUTE [dbo].[ReferralCodes_SelectChartByWeek]
		@Code
		, @WeekNumber

*/

BEGIN
			
	;with WeekCTE as 
	(
		SELECT  DATEPART(WEEK, [TimeStamp]) AS WeekNumber
				,[Value]

		FROM [dbo].[ReferralCodes] AS RC 
			INNER JOIN [dbo].[ReferralCodeLookUp] AS LU
		ON RC.[KeywordId] = LU.[Id]

		WHERE LU.[Code] = @Code
	)
	Select *
		, Count(1) AS HitCount
	From WeekCTE
	WHERE WeekNumber = @WeekNumber

	Group by WeekNumber, [Value]
	Order by 3 Desc
			
END