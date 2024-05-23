select CONCAT(e.surname, ' ', e."name" , ' ', e.patronymic , ' ', e.dob::text) AS "ФИО водителя",
h.license as "ПАК", avg(pulse::float) as "Средний пульс", stddev_pop(pulse::float) as "Ст.откл пульса",
avg(ad_sys::float) as "Среднее сАД", stddev_pop(ad_sys::float) as "Ст.откл сАД",
avg(ad_dis::float) as "Среднее дАД", stddev_pop(ad_dis::float) as "Ст.откл дАД",
avg(temperature::float) as "Средняя температура", stddev_pop(temperature::float) as "Ст.откл температуры",
count(*)
from processing.inspections_pool_resolved a
inner join structures.hosts h
on a.host_id = h.id
inner join structures.employees e
on e.id = a.employee_id
inner join (SELECT
json_data->'result'->'value'->>'pulse' AS pulse,
json_data->'result'->'value'->'pressure'->>'systolic' AS ad_sys,
json_data->'result'->'value'->'pressure'->>'diastolic' AS ad_dis,
ipr.id as "id"
FROM
processing.inspections_pool_resolved ipr ,
jsonb_array_elements(ipr.steps) AS json_data
WHERE
json_data->>'type' = 'tonometry') t
on t.id = a.id
inner join (SELECT
json_data->'result'->>'value' AS temperature,
ipr.id as id
FROM
processing.inspections_pool_resolved ipr ,
jsonb_array_elements(ipr.steps) AS json_data
WHERE
json_data->>'type' = 'temperature') t1
on t1.id = a.id
where a.started_at between '2023-12-01' and '2023-12-31'
group by  CONCAT(e.surname, ' ', e."name" , ' ', e.patronymic , ' ', e.dob::text),
h.license;