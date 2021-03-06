
ALTER PROC [dbo].[ReferralCodes_SelectUserBreakdown]

AS

/*		TEST CODE

EXECUTE [dbo].[ReferralCodes_SelectUserBreakdown]

*/

BEGIN
			
SELECT 
    COUNT(*) AS Total,
    SUM(unregistered) AS unregistered_total,
    SUM(registered) AS registered_total
FROM 
(
	SELECT  
		ROW_NUMBER() OVER (PARTITION BY userId ORDER BY userid) as num,
	UserId, 
		CASE WHEN IsAnonymous = 1 THEN 1 ELSE 0 END AS unregistered,
		CASE WHEN IsAnonymous = 0 THEN 1 ELSE 0 END AS registered
		FROM [dbo].[ReferralCodes]
) AS tbl 
WHERE num=1
GROUP by unregistered, registered
			
END