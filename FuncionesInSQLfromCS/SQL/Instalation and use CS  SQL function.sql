-- Para poder instalar funciones hay que hacer lo siguiente hasta sql 2012, después cambia el mecanismo se seuridad
USE [DataBase]
GO
EXECUTE sp_changedbowner 'sa'

ALTER DATABASE [Nombre de la base] SET TRUSTWORTHY ON
GO
sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO
RECONFIGURE WITH OVERRIDE
GO
sp_configure 'show advanced options', 0
GO

-- El proceso de instalar una función C# en SQL tiene dos pasos
-- 1) crear un assembly que es el equivalente de decirle a SQL donde está el dll que va a usar
-- 2) Crear las funciones que estan declaradas como [Microsoft.SqlServer.Server.SqlFunction] en el dll


CREATE ASSEMBLY [FuncionesInSQLfromCS]
AUTHORIZATION [dbo]
FROM 'Z:\FuncionesInSQLfromCS.dll'
WITH PERMISSION_SET = SAFE
GO
CREATE FUNCTION dbo.EDS(@string AS nvarchar(max)) RETURNS nvarchar(max)
AS EXTERNAL NAME
[FuncionesInSQLfromCS].[UserDefinedFunctions].[EDS]
go



SELECT [dbo].[fncRegexFind]('DF','DF')


