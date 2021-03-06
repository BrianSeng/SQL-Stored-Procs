
ALTER PROC [dbo].[Followers_SelectByPUID_and_Bounds]
			 @ProfileUID nvarchar(128)
			,@Latitude_NE decimal(9,6) 
			,@Longitude_NE decimal(9,6)
			,@Latitude_SW decimal(9,6) 
			,@Longitude_SW decimal(9,6) 

AS

/*			TEST CODE  this is for getting all of the followers of a profile

DECLARE  @ProfileUID nvarchar(128) = '059b95e3-4533-464e-ac9e-0ae88ddade0b'
		,@Latitude_NE decimal(9,6) = 79.663555
		,@Longitude_NE decimal(9,6) = 180
		,@Latitude_SW decimal(9,6) = -80.668435
		,@Longitude_SW decimal(9,6) = -180

EXECUTE dbo.[Followers_SelectByPUID_and_Bounds]
		 @ProfileUID 
		,@Latitude_NE 
		,@Longitude_NE 
		,@Latitude_SW  
		,@Longitude_SW  



*/

BEGIN

SELECT DISTINCT F.[FollowerID]
		,F.[ProfileUID]
		,F.[Latitude]
		,F.[Longitude]
		,AC.[UserId]
		,AC.[Handle]
		,AC.[FirstName]
		,AC.[LastName]
		,AC.[AvatarUrl]
FROM [dbo].[Followers] AS F 
	INNER JOIN [dbo].[AspNetUsers] AS A
		ON F.FollowerID = A.Id
	INNER JOIN [dbo].[Accounts] AS AC
		ON A.Id = AC.UserId

WHERE F.ProfileUID = @ProfileUID AND
	(
		@Latitude_SW < @Latitude_NE AND
		F.Latitude BETWEEN @Latitude_SW AND @Latitude_NE
	)
	OR
	(
		@Latitude_NE < @Latitude_SW AND
		F.Latitude BETWEEN @Latitude_NE AND @Latitude_SW
	) 
	AND
	(
		@Longitude_SW < @Longitude_NE AND
		F.Longitude BETWEEN @Longitude_SW AND @Longitude_NE
	)
	OR
	(
		@Longitude_NE < @Longitude_SW AND
		F.Longitude BETWEEN @Longitude_NE AND @Longitude_SW
	) 

END


