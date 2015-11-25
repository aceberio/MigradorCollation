-- script out the enabling of triggers 
insert into #sql (sql)
select 'IF OBJECT_ID(''tempdb..#BACKUPFUNCTIONMULTILINE'') IS NOT NULL 
begin
	Declare @FunctionToProcess VARCHAR(776)
	Declare @tSQLToProcess VARCHAR(max)

	While (Select Count(1) From #BACKUPFUNCTIONMULTILINE) > 0
	Begin
		SELECT @FunctionToProcess = T_SQL_NAME, @tSQLToProcess = T_SQL FROM #BACKUPFUNCTIONMULTILINE
		
		exec( @tSQLToProcess )
		print ''Se creo la funcíon: '' + @FunctionToProcess
		Delete #BACKUPFUNCTIONMULTILINE Where T_SQL_NAME = @FunctionToProcess
	end
	drop table #BACKUPFUNCTIONMULTILINE
end'