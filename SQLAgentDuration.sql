SELECT	
	sjh.instance_id,
	sj.Name,
	Sj.[description],
	[RunDateTime] = msdb.dbo.agent_datetime(sjh.run_date,sjh.run_time),
	CASE len(sjh.run_duration)
      WHEN 1 THEN cast('00:00:0'
            + cast(sjh.run_duration as char) as char (8))
      WHEN 2 THEN cast('00:00:'
            + cast(sjh.run_duration as char) as char (8))
      WHEN 3 THEN cast('00:0' 
            + Left(right(sjh.run_duration,3),1) 
            +':' + right(sjh.run_duration,2) as char (8))
      WHEN 4 THEN cast('00:' 
            + Left(right(sjh.run_duration,4),2) 
            +':' + right(sjh.run_duration,2) as char (8))
      WHEN 5 THEN cast('0' 
            + Left(right(sjh.run_duration,5),1) 
            +':' + Left(right(sjh.run_duration,4),2) 
            +':' + right(sjh.run_duration,2) as char (8))
      WHEN 6 THEN cast(Left(right(sjh.run_duration,6),2) 
            +':' + Left(right(sjh.run_duration,4),2) 
            +':' + right(sjh.run_duration,2) as char (8))
   END as 'Duration',
   GETDATE() AS LogDate,
   CASE WHEN run_status = 0
   THEN '*******FAILED********'
   ELSE 'OK'
   END AS MessageDetails,
   CASE WHEN run_status = 0
   THEN 1
   ELSE 0
   END AS EvaluationRequired
FROM msdb.dbo.sysjobs sj
	INNER JOIN msdb.dbo.sysjobhistory sjh on sj.job_id = sjh.job_id
WHERE
	sjh.step_id = 0
ORDER BY
	RunDateTime DESC