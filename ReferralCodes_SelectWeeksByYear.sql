USE [C32_LashGirl]
GO
/****** Object:  StoredProcedure [dbo].[ReferralCodes_SelectWeeksByYear]    Script Date: 6/9/2017 2:10:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ReferralCodes_SelectWeeksByYear]
			@LookUpYear int
AS

/*		TEST CODE

DECLARE @LookUpyear int = 2016

EXECUTE [dbo].[ReferralCodes_SelectWeeksByYear]
		@LookUpyear

*/

BEGIN
	
	;with WeekCTE as 
	(
		SELECT  DATEPART(WEEK, [TimeStamp]) AS WeekNumber
				,convert(char(10), DATEADD(dd, -(DATEPART(dw, [TimeStamp])-1), [TimeStamp]), 101) AS [WeekStart]
				,convert(char(10), DATEADD(dd, 7-(DATEPART(dw, [TimeStamp])), [TimeStamp]), 101) AS [WeekEnd]
				,convert(varchar(5), DATEADD(dd, -(DATEPART(dw, [TimeStamp])-1), [TimeStamp]), 101) AS [fWeekStart]
				,convert(varchar(5), DATEADD(dd, 7-(DATEPART(dw, [TimeStamp])), [TimeStamp]), 101) AS [fWeekEnd]

		FROM [dbo].[ReferralCodes] AS RC 
		INNER JOIN [dbo].[ReferralCodeLookUp] AS LU
		ON RC.[KeywordId] = LU.[Id]
	)

	Select *
	From WeekCTE
	WHERE DATEPART(YEAR, [WeekStart]) = @LookUpYear

	Group by WeekNumber, [WeekStart], [WeekEnd], [fWeekStart], [fWeekEnd]
	Order by [WeekStart] ASC
			
END