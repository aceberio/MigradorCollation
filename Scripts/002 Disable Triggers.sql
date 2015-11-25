/*script out the disabling of triggers */
--TODO: when disabling triggers what happens with triggers on views & ddl triggers

insert into #sql (sql)
--feedback from ianderson - added code to handle triggers on views

select 'alter table ['+SCHEMA_NAME(o2.schema_id	)+'].[' + o2.name + '] disable trigger [' +o1.name+']'
from 	sys.objects o1
join 	sys.objects o2 on	o1.parent_object_id = o2.object_id
where 	o1.type = 'TR' 
and 	OBJECTPROPERTY(o1.object_id,'ExecIsTriggerDisabled')=0
and 	OBJECTPROPERTY(o2.object_id, 'IsTable')=1