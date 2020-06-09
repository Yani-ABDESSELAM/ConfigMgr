USE MASTER
GO
IF EXISTS (SELECT name FROM sys.databases 
WHERE name = N'CMMonitor')
DROP DATABASE [CMMonitor]
GO
CREATE DATABASE [CMMonitor] ON PRIMARY 
( NAME = N'CMMonitor', 
FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\CMMonitor.mdf' , 
SIZE = 10240KB , MAXSIZE = UNLIMITED, 
FILEGROWTH = 10240KB )
LOG ON 
( NAME = N'CMMonitor_log', 
FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Log\CMMonitor_log.ldf' , 
SIZE = 1024KB , MAXSIZE = 2048GB , 
FILEGROWTH = 5120KB )
GO
ALTER DATABASE [CMMonitor] SET RECOVERY SIMPLE 
GO
