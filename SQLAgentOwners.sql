/*

HK - 18/03/2015 Get all sql agent and ssis owners

*/

-- SSIS packages stored in different table 2008 onward, need to detect server version

DECLARE @IsSQL2005 int
DECLARE @IsSQL2008Onward int



IF CHARINDEX('2005',@@VERSION,1) <> 0
BEGIN
	SET @IsSQL2005 = 1
	PRINT 'SQL 2005'
END
ELSE 
	SET @IsSQL2008Onward = 1
	PRINT 'SQL 2008 +'

IF @IsSQL2008Onward = 1
SELECT @@SERVERNAME AS [Server],
	'Job' AS [Type]
    , name as ItemName
   , SUSER_SNAME(owner_sid) AS [Owner] 
FROM msdb.dbo.sysjobs 

UNION
SELECT 
	@@SERVERNAME AS [Server],
	'Package' AS [Type]
    , name as ItemName
   , SUSER_SNAME(ownersid) AS [Owner] 
FROM msdb.dbo.sysssispackages

IF @IsSQL2005 = 1
SELECT @@SERVERNAME AS [Server],
	'Job' AS [Type]
    , name as ItemName
   , SUSER_SNAME(owner_sid) AS [Owner] 
FROM msdb.dbo.sysjobs 

UNION
SELECT 
	@@SERVERNAME AS [Server],
	'Package' AS [Type]
    , name as ItemName
   , SUSER_SNAME(ownersid) AS [Owner] 
FROM msdb.dbo.sysdtspackages90 
