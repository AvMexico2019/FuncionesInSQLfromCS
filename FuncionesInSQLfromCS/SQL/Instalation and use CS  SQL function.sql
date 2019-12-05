-- Para poder instalar funciones hay que hacer lo siguiente hasta sql 2012, después cambia el mecanismo se seuridad
USE [ArrendamientoInmueble]
GO
--EXECUTE sp_changedbowner 'sa'

--ALTER DATABASE [Nombre de la base] SET TRUSTWORTHY ON
--GO
--sp_configure 'show advanced options', 1
--GO
--RECONFIGURE
--GO
--sp_configure 'clr enabled', 1
--GO
--RECONFIGURE
--GO
--RECONFIGURE WITH OVERRIDE
--GO
--sp_configure 'show advanced options', 0
--GO

-- Antes que otra cosa es necesario remover las funciones del asssembly
IF EXISTS ( SELECT 1
			FROM	Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'StringRegexFind'
                    AND Routine_Type = 'FUNCTION' )
Begin
	Drop Function [dbo].[StringRegexFind]
end
go

IF EXISTS ( SELECT 1
			FROM	Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'SelloDigitalContratos'
                    AND Routine_Type = 'FUNCTION' )
Begin
	Drop Function [dbo].[SelloDigitalContratos]
end
go

IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'EDS'
                    AND Routine_Type = 'FUNCTION' )
Begin
	Drop Function [dbo].[EDS]
end
go

IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'fncRegexFind'
                    AND Routine_Type = 'FUNCTION' )
Begin
	Drop Function [dbo].[fncRegexFind]
end
go

-- Enseguida se remueve el assembly
if exists(select 1 from sys.assemblies where name = 'FuncionesInSQLfromCS')
begin
	drop assembly [FuncionesInSQLfromCS] with no dependents;
end
go

-- Ahora ya se puede crear el assembly y sus funciones

-- El proceso de instalar una función C# en SQL tiene dos pasos
-- 1) crear un assembly que es el equivalente de decirle a SQL donde está el dll que va a usar
-- 2) Crear las funciones que estan declaradas como [Microsoft.SqlServer.Server.SqlFunction] en el dll
-- La ruta 'Z:\FuncionesInSQLfromCS.dll' corresponde a la ruta donde esta el dll en el servidor que corre el sql server
CREATE ASSEMBLY [FuncionesInSQLfromCS]
AUTHORIZATION [dbo]
FROM 'Z:\FuncionesInSQLfromCS.dll'
WITH PERMISSION_SET = SAFE
go

CREATE FUNCTION dbo.fncRegexFind(@regex AS nvarchar(max), @text AS nvarchar(max)) RETURNS bit
AS EXTERNAL NAME
[FuncionesInSQLfromCS].[UserDefinedFunctions].[fncRegexFind]
go

CREATE FUNCTION dbo.EDS(@string AS nvarchar(max)) RETURNS nvarchar(max)
AS EXTERNAL NAME
[FuncionesInSQLfromCS].[UserDefinedFunctions].[EDS]
go

CREATE FUNCTION dbo.SelloDigitalContratos(@string AS nvarchar(max)) RETURNS nvarchar(max)
AS EXTERNAL NAME
[FuncionesInSQLfromCS].[UserDefinedFunctions].[SelloDigitalContratos]
go

CREATE FUNCTION dbo.StringRegexFind(@regex AS nvarchar(max), @texto AS nvarchar(max)) RETURNS nvarchar(max)
AS EXTERNAL NAME
[FuncionesInSQLfromCS].[UserDefinedFunctions].[StringRegexFind]
go


--
--SELECT [dbo].[fncRegexFind]('DF','DF')