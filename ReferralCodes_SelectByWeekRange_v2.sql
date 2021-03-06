
ALTER PROC [dbo].[ReferralCodes_SelectByWeekRange_v2]
			@Code nvarchar(50)
			, @WeekNumber int
			, @WeekNumber2 int
			, @LookUpYear int = null
AS

/*		TEST CODE

DECLARE @Code nvarchar(50) = 'campaign'
		, @WeekNumber int = 17
		, @WeekNumber2 int = 23
		, @LookUpyear int = 2016

EXECUTE [dbo].[ReferralCodes_SelectByWeekRange_v2]
		@Code
		, @WeekNumber
		, @WeekNumber2
		, @LookUpyear

*/

BEGIN
	IF @LookUpYear IS null
	SET @LookUpYear = DATEPART(YEAR, getdate())	

	;with WeekCTE as 
	(
		SELECT  DATEPART(WEEK, [TimeStamp]) AS WeekNumber
				,[Value]
				--,DATEADD(dd, -(DATEPART(dw, [TimeStamp])-1), [TimeStamp]) AS [WeekStart]
				--,DATEADD(dd, 7-(DATEPART(dw, [TimeStamp])), [TimeStamp]) AS [WeekEnd]
				,convert(char(10), DATEADD(dd, -(DATEPART(dw, [TimeStamp])-1), [TimeStamp]), 101) AS [WeekStart]
				,convert(char(10), DATEADD(dd, 7-(DATEPART(dw, [TimeStamp])), [TimeStamp]), 101) AS [WeekEnd]
				--,convert(varchar(5), DATEADD(dd, -(DATEPART(dw, [TimeStamp])-1), [TimeStamp]), 101) AS [FormattedWeekStart]
				--,convert(varchar(5), DATEADD(dd, 7-(DATEPART(dw, [TimeStamp])), [TimeStamp]), 101) AS [FormattedWeekEnd]

		FROM [dbo].[ReferralCodes] AS RC 
		INNER JOIN [dbo].[ReferralCodeLookUp] AS LU
		ON RC.[KeywordId] = LU.[Id]

		WHERE LU.[Code] = @Code
	)

	Select *
		, Count(1) AS HitCount
	From WeekCTE
	WHERE WeekNumber 
	BETWEEN @WeekNumber AND @WeekNumber2
	AND DATEPART(YEAR, [WeekStart]) = @LookUpYear

	Group by WeekNumber, [Value], [WeekStart], [WeekEnd]
	Order by WeekNumber ASC
			
END