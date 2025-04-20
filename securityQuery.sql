-- 1. TDE (Transparent Data Encryption) Uygulama:
-- Şifreleme anahtarını oluşturma
CREATE DATABASE ENCRYPTION KEY;
GO

-- Veritabanını şifreleme ile etkinleştirme
ALTER DATABASE AdventureWorks2016 SET ENCRYPTION ON;
GO

-- 2. Windows Authentication ile Kullanıcı Oluşturma:
-- Windows Authentication kullanarak oturum açma
USE [master];
GO
CREATE LOGIN [domain\username] FROM WINDOWS;
GO

-- 3. SQL Server Authentication ile Kullanıcı Oluşturma:
-- SQL Server Authentication için kullanıcı oluşturma
CREATE LOGIN sqluser WITH PASSWORD = 'password';
GO

-- 4. SQL Injection Testi İçin Parametreli Sorgu Kullanma:
-- Parametreli sorgu kullanımı
DECLARE @PersonID INT;
SET @PersonID = 5;

SELECT * FROM Person.Person WHERE BusinessEntityID = @PersonID;
GO

-- 5. Audit Logları Oluşturma ve Başlatma:
-- master veritabanını kullanma
USE master;
GO

-- Audit log dosyasının geçerli bir yol ile oluşturulması
CREATE SERVER AUDIT Audit_User_Login
TO FILE (FILEPATH = 'C:\SQLServerLogs\');  -- Geçerli bir dosya yolu kullanın
GO

-- Audit'i başlatma
ALTER SERVER AUDIT Audit_User_Login
WITH (STATE = ON);
GO
