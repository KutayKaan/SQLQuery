-- 1. Full Backup (Tam Yedekleme)
BACKUP DATABASE [YourDatabaseName]
TO DISK = 'C:\Backups\YourDatabaseName_full.bak'
WITH FORMAT, MEDIANAME = 'DbBackup', NAME = 'Full Backup of YourDatabaseName';
GO

-- 2. Differential Backup (Fark Yedekleme)
BACKUP DATABASE [YourDatabaseName]
TO DISK = 'C:\Backups\YourDatabaseName_diff.bak'
WITH DIFFERENTIAL, MEDIANAME = 'DbBackup', NAME = 'Differential Backup of YourDatabaseName';
GO

-- 3. Transaction Log Backup (Transaction Log Yedekleme)
BACKUP LOG [YourDatabaseName]
TO DISK = 'C:\Backups\YourDatabaseName_log.bak'
WITH MEDIANAME = 'DbLogBackup', NAME = 'Transaction Log Backup of YourDatabaseName';
GO

-- 4. Yedekleme Durumunu Kontrol Etme
RESTORE FILELISTONLY
FROM DISK = 'C:\Backups\YourDatabaseName_full.bak';
GO

-- 5. Veritabanını Yedekten Geri Yükleme (Restore)
-- Full Backup
RESTORE DATABASE [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_full.bak'
WITH REPLACE;
GO

-- Differential Backup
RESTORE DATABASE [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_full.bak'
WITH NORECOVERY;
GO

RESTORE DATABASE [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_diff.bak'
WITH RECOVERY;
GO

-- Transaction Log Backup
RESTORE LOG [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_log.bak'
WITH RECOVERY;
GO

-- 6. Veritabanını Belirli Bir Zaman Noktasına Geri Yükleme (Point-in-Time Restore)
RESTORE DATABASE [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_full.bak'
WITH NORECOVERY;
GO

RESTORE LOG [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_log.bak'
WITH STOPAT = '2025-04-20 13:30:00', RECOVERY;
GO

-- 7. Yedekleme Durumu
SELECT database_id, name, state_desc, recovery_model_desc
FROM sys.databases
WHERE name = '[YourDatabaseName]';
GO
