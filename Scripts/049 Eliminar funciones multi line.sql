-- script out the enabling of triggers 
insert into #sql (sql)
select '-----------------------------------------------------------------
IF OBJECT_ID(''tempdb..#FUNCIONESAELIMINAR'') IS NOT NULL DROP TABLE #FUNCIONESAELIMINAR
CREATE TABLE #BACKUPFUNCTIONMULTILINE ( T_SQL_NAME VARCHAR(776), T_SQL VARCHAR(MAX))
CREATE TABLE #FUNCIONESAELIMINAR ( T_SQL_NAME VARCHAR(776))

INSERT INTO #FUNCIONESAELIMINAR 
	select sysS.Name + ''.'' +syso.NAME from sys.objects sysO 
	inner join sys.schemas sysS on sysO.Schema_Id = sysS.schema_Id
	where syso.TYPE = ''TF''

Declare @T_SQL_NAME_function VARCHAR(776)

While (Select Count(1) From #FUNCIONESAELIMINAR) > 0
Begin

    Select Top 1 @T_SQL_NAME_function = T_SQL_NAME From #FUNCIONESAELIMINAR

	IF OBJECT_ID(''tempdb..#tmpTSQLCode'') IS NOT NULL DROP TABLE #tmpTSQLCode
	create table #tmpTSQLCode (T_SQL_code VARCHAR(MAX) )

	INSERT INTO #tmpTSQLCode
	EXEC sp_helptext @T_SQL_NAME_function

	insert into #BACKUPFUNCTIONMULTILINE select DISTINCT @T_SQL_NAME_function, stuff(
																			   ( SELECT  rtrim(ltrim( SUB.T_SQL_code )) AS [text()]
																				 from #tmpTSQLCode SUB FOR XML PATH(''''), TYPE ).value(''.[1]'', ''nvarchar(max)'') ,1,0,'''') from #tmpTSQLCode 
	
	drop table #tmpTSQLCode
	DECLARE @DynamicSql varchar(200) 
	set @DynamicSql = ''drop function '' + @T_SQL_NAME_function;
	exec( @DynamicSql )
	print ''Se elimino la funcíon: '' + @T_SQL_NAME_function
    Delete #FUNCIONESAELIMINAR Where T_SQL_NAME = @T_SQL_NAME_function

End
drop table #FUNCIONESAELIMINAR'
