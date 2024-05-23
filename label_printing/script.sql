select o."name" as "Название компании", o.inn as "ИНН", ipr.id, ipr.deadline, ipr.started_at, ipr.finished_at, ipr.added_at,
ipr.finalized_at, ipr.session_finished_at, er."type", er."timestamp" 
from events_resolved er inner join
processing.inspections_pool_resolved ipr 
on er.inspection_id = ipr.id 
inner join structures.organizations o 
on o.id = ipr.org_id 
where ipr.started_at between '2024-01-30 00:00:00.000 +0300' and '2024-01-30 23:59:59.999 +0300'