-- -------------------------
-- İndeks Yönetimi
-- -------------------------
-- Index oluşturma
CREATE INDEX IX_SalesOrderHeader_CustomerID
ON Sales.SalesOrderHeader (CustomerID);

-- Gereksiz indeksin kaldırılması
DROP INDEX IX_SalesOrderHeader_CustomerID ON Sales.SalesOrderHeader;

-- -------------------------
-- Veri Yönetimi
-- -------------------------
-- Kullanıcı rolü oluşturma
CREATE ROLE SalesManager;

-- Kullanıcı oluşturma
CREATE USER JohnDoe FOR LOGIN JohnDoeLogin;

-- Kullanıcıya rol yetkisi verme
ALTER ROLE SalesManager ADD MEMBER JohnDoe;

-- -------------------------
-- İndeks Kullanımı ve Sorgu İzleme
-- -------------------------
-- İndeks kullanımı hakkında bilgi al
SELECT 
    object_name(i.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks AS Seeks,
    s.user_scans AS Scans
FROM 
    sys.indexes AS i
JOIN 
    sys.dm_db_index_usage_stats AS s
ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE 
    objectproperty(i.object_id, 'IsUserTable') = 1;

-- -------------------------
-- Kullanıcı Rolleri ve Yetki Yönetimi
-- -------------------------
-- Yeni bir rol oluşturma
CREATE ROLE SalesManagerRole;

-- Yeni kullanıcı oluşturma
CREATE USER SalesUser FOR LOGIN SalesUserLogin;

-- Kullanıcıya rol atama
ALTER ROLE SalesManagerRole ADD MEMBER SalesUser;

-- -------------------------
-- Rol Silme
-- -------------------------
-- Eğer rolü kaldırmak isterseniz, öncelikle o rolü kullanan kullanıcıları da kaldırmanız gerekir.
-- Kullanıcıyı rolden çıkarma
ALTER ROLE SalesManagerRole DROP MEMBER SalesUser;

-- Rolü silme
DROP ROLE SalesManagerRole;

-- -------------------------
-- Sorgu Optimizasyonu
-- -------------------------
-- Orijinal Sorgu: Yıl filtresi ile
SELECT * 
FROM Sales.SalesOrderHeader 
WHERE YEAR(OrderDate) = 2014;

-- Optimize Edilmiş Sorgu: Yıl filtresi doğrudan sütuna uygulandı
SELECT * 
FROM Sales.SalesOrderHeader 
WHERE OrderDate >= '2014-01-01' AND OrderDate < '2015-01-01';

-- -------------------------
-- İndeks Kullanımı ve Sorgu İzleme
-- -------------------------
-- İndeks kullanımı hakkında bilgi al
SELECT 
    object_name(i.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks AS Seeks,
    s.user_scans AS Scans
FROM 
    sys.indexes AS i
JOIN 
    sys.dm_db_index_usage_stats AS s
ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE 
    objectproperty(i.object_id, 'IsUserTable') = 1;

-- -------------------------
-- Kullanıcı Rolleri ve Yetki Yönetimi
-- -------------------------
-- Yeni bir rol oluşturma
CREATE ROLE SalesManagerRole;

-- Yeni kullanıcı oluşturma
CREATE USER SalesUser FOR LOGIN SalesUserLogin;

-- Kullanıcıya rol atama
ALTER ROLE SalesManagerRole ADD MEMBER SalesUser;

-- -------------------------
-- Sorgu İzleme ve Performans Analizi
-- -------------------------
-- Sorgu izleme için DMV kullanma
SELECT 
    sql_text.text AS SQLText, 
    plan_handle, 
    execution_count,
    total_worker_time, 
    total_elapsed_time
FROM 
    sys.dm_exec_query_stats AS qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.plan_handle) AS sql_text
WHERE 
    sql_text.text LIKE '%SalesOrderHeader%';

-- -------------------------
-- Diğer SQL işlemleri
-- -------------------------
-- Burada diğer işlemleri ekleyebilirsin, örneğin veri güncellemeleri veya silme işlemleri.
