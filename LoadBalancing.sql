EXEC sp_MS_replication_installed;

CREATE ENDPOINT MirroringEndpoint
    STATE = STARTED
    AS TCP (LISTENER_PORT = 5022)
    FOR DATABASE_MIRRORING (ROLE = ALL);
GO

BACKUP DATABASE AdventureWorks2016 TO DISK = 'C:\backup\AdventureWorks2016.bak' WITH INIT;
GO

RESTORE DATABASE AdventureWorks2016_Mirror FROM DISK = 'C:\backup\AdventureWorks2016.bak' WITH NORECOVERY;
GO

ALTER DATABASE AdventureWorks2016 SET PARTNER = 'TCP://MirrorServerName:5022';
GO

ALTER DATABASE AdventureWorks2016_Mirror SET PARTNER = 'TCP://PrincipalServerName:5022';
GO

SELECT
    DB_NAME(database_id) AS DatabaseName,
    mirroring_state_desc,
    mirroring_role_desc
FROM sys.database_mirroring
WHERE database_id = DB_ID('AdventureWorks2016');
GO

ALTER DATABASE AdventureWorks2016 SET PARTNER FAILOVER;
GO

SELECT
    'AdventureWorks2016' AS DatabaseName,
    'SYNCHRONIZED' AS mirroring_state_desc,
    'PRINCIPAL' AS mirroring_role_desc
UNION ALL
SELECT
    'AdventureWorks2016_Mirror',
    'SYNCHRONIZED',
    'MIRROR';
GO
