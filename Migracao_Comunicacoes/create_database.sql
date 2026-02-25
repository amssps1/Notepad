CREATE DATABASE [Comunicacoes]
 ON  PRIMARY 
( NAME = N'Comunicacoes', FILENAME = N'G:\DATA\Comunicacao.mdf' , SIZE = 20GB , FILEGROWTH = 2GB )
 LOG ON 
( NAME = N'Comunicacoes_log', FILENAME = N'Y:\log\Comunicacao.ldf' , SIZE = 5GB , FILEGROWTH = 1GB )


USE [master]
GO
ALTER DATABASE [Comunicacoes] ADD FILEGROUP [USER_FG]
GO
ALTER DATABASE [Comunicacoes] ADD FILE ( NAME = N'Comunicacoes_Data', FILENAME = N'G:\DATA\Comunicacao_Data.ndf' , SIZE = 130GB , FILEGROWTH = 2GB ) TO FILEGROUP [USER_FG]
GO

USE [master]
GO
ALTER DATABASE [Comunicacoes] ADD FILEGROUP [INDICE_FG]
GO
ALTER DATABASE [Comunicacoes] ADD FILE ( NAME = N'Comunicacoes_IDX', FILENAME = N'G:\DATA\Comunicacao_IDX.ndf' , SIZE = 10GB , FILEGROWTH = 1GB ) TO FILEGROUP [INDICE_FG]
GO

USE [Comunicacoes]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'USER_FG') 
   ALTER DATABASE [Comunicacoes] MODIFY FILEGROUP [USER_FG] DEFAULT
GO
 