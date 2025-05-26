USE msdb;
EXEC sp_add_job @job_name = N'DatabaseBackupJob';
--------------------
EXEC sp_add_jobstep 
    @job_name = N'DatabaseBackupJob',
    @step_name = N'BackupAdventureWorks2016',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE AdventureWorks2016 TO DISK = ''C:\Backups\AdventureWorks2016.bak'' WITH INIT, COMPRESSION;',
    @retry_attempts = 3,
    @retry_interval = 5;
------------------------
EXEC sp_add_schedule 
    @schedule_name = N'DailyBackupSchedule',
    @freq_type = 4,  -- günlük
    @freq_interval = 1,
    @active_start_time = 010000;  -- 01:00 AM
------------------------
EXEC sp_attach_schedule 
    @job_name = N'DatabaseBackupJob',
    @schedule_name = N'DailyBackupSchedule';
----------------------
EXEC sp_add_jobserver @job_name = N'DatabaseBackupJob';
---------------------------
CREATE TABLE dbo.BackupHistory (
    BackupID INT IDENTITY(1,1) PRIMARY KEY,
    DatabaseName NVARCHAR(128),
    BackupDate DATETIME DEFAULT GETDATE(),
    BackupFile NVARCHAR(260),
    Success BIT
);
-------------------------
CREATE PROCEDURE dbo.usp_LogBackupResult 
    @DatabaseName NVARCHAR(128), 
    @BackupFile NVARCHAR(260), 
    @Success BIT
AS
BEGIN
    INSERT INTO dbo.BackupHistory (DatabaseName, BackupDate, BackupFile, Success)
    VALUES (@DatabaseName, GETDATE(), @BackupFile, @Success);
END;
-------------------------------
CREATE PROCEDURE dbo.usp_CheckLastBackup
AS
BEGIN
    SELECT TOP 1 * 
    FROM dbo.BackupHistory 
    WHERE DatabaseName = 'AdventureWorks2016' 
    ORDER BY BackupDate DESC;
END;
