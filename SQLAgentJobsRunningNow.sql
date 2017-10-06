/* Checks for jobs that are running now, or have previously hung/had an issue */

SELECT 
	sj.Name JobName,
	sj.job_id,
	sj.[Description],
	sja.Start_Execution_date,
	Stop_Execution_Date,
	last_executed_step_ID,
	last_executed_step_date
FROM 
	msdb.dbo.sysjobactivity sja
		INNER JOIN msdb.dbo.sysjobs sj on sja.job_id = sj.job_id
WHERE
	Start_Execution_Date IS NOT NULL
	AND Stop_Execution_Date IS NULL
ORDER BY
	Start_Execution_Date DESC

EXEC msdb.dbo.sp_help_job @Job_name = 'HPSP Adhoc Data to Formscape'
