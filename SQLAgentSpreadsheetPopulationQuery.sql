SELECT
	@@SERVERNAME,
	name,
	[description],
	MAX(run_date)
FROM
	msdb.dbo.sysjobs
		INNER JOIN msdb.dbo.sysjobhistory on msdb.dbo.sysjobs.job_id = msdb.dbo.sysjobhistory.job_id
WHERE
	[Enabled] = 1
GROUP BY
	name,
	[description]
