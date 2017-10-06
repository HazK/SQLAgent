
SELECT 
	msdb.dbo.sysjobs.Job_ID,
	msdb.dbo.sysjobs.Name AS JobName,
--	MIN(Last_run_date),
--	MIN(Last_run_time),
	MIN(LEFT(CONVERT(nvarchar,last_run_date),4) + '-'
	 + SUBSTRING(CONVERT(nvarchar,last_run_date),5,2) + '-' 
	 + SUBSTRING(CONVERT(nvarchar,last_run_date),7,2)) + ' T' 
	 +  MIN(
		CASE 
			WHEN LEN(last_run_time) = 3
			THEN LEFT('000' +  CONVERT(nvarchar(20),last_run_time),2) + ':' + SUBSTRING( '000' + CONVERT(nvarchar,last_run_time),3,2) + ':' + SUBSTRING('000' + CONVERT(nvarchar,last_run_time),5,2)
			WHEN LEN(last_run_time) = 4
			THEN LEFT('00' +  CONVERT(nvarchar(20),last_run_time),2) + ':' + SUBSTRING( '00' + CONVERT(nvarchar,last_run_time),3,2) + ':' + SUBSTRING('00' + CONVERT(nvarchar,last_run_time),5,2)
			WHEN LEN(last_run_time) = 5
			THEN LEFT('0' +  CONVERT(nvarchar(20),last_run_time),2) + ':' + SUBSTRING('0' + CONVERT(nvarchar,last_run_time),3,2) + ':' + SUBSTRING('0' +CONVERT(nvarchar,last_run_time),5,2)
			ELSE LEFT(CONVERT(nvarchar(20),last_run_time),2) + ':' + SUBSTRING( CONVERT(nvarchar,last_run_time),3,2) + ':' + SUBSTRING(CONVERT(nvarchar,last_run_time),5,2)
			END
		)
	AS LastRunTime
FROM
	msdb.dbo.sysJobSteps
		INNER JOIN msdb.dbo.Sysjobs ON msdb.dbo.SysJobSteps.Job_ID = msdb.dbo.Sysjobs.Job_ID
WHERE 
	Last_Run_Date <> 0
	AND Last_Run_Time <> 0
	AND [Enabled] = 1

GROUP BY
	msdb.dbo.sysjobs.Job_ID,
	msdb.dbo.sysjobs.Name 

