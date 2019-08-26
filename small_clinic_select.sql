use small_clinic;



-- продажи за сегодня
create view today_ernings as 
	select price, discount, total_price, payment_method FROM main_service  where date(created_at) = date(now())
	union
	select price, discount, total_price, payment_method  FROM extra_service  where date(created_at) = date(now());

select payment_method from today_ernings;
select avg(total_price) from today_ernings;



-- Выборка общей выручки на дату 
select 
	(select SUM(total_price) FROM main_service  where year(created_at) = 2019 and month(created_at) = 8 ) 
	+ 
	(select SUM(total_price)  FROM extra_service where year(created_at) = 2019 and month(created_at) = 8 )
as day_total;

-- Выборка общей выручки за месяц
select 
	(select SUM(total_price) FROM main_service  where year(created_at) = 2019 and month(created_at) = 8) 
	+ 
	(select SUM(total_price)  FROM extra_service where year(created_at) = 2019 and month(created_at) = 8)
as month_total;

-- Выборка общей выручки за год
select 
	(select SUM(total_price) FROM main_service  where year(created_at) = 2019) 
	+ 
	(select SUM(total_price)  FROM extra_service where year(created_at) = 2019)
as year_total;

-- Выбор посетителей иностранцев
select id, name from patients where id in (select patient_id from patients_under_18 where nationality <> 'rus')
	union
select id, name from patients where id in (select patient_id from patients_upper_18 where nationality <> 'rus');


-- Сумму выплат по договору за месяц
select truncate(sum(payment), 2) 
from extra_price where id in 
	(select id from  extra_service where year(created_at) = 2019 and month(created_at) = 8) 
as month_payment; 




-- Услуги оказанные определенным врачом и на дату

select doctor_id, sum(price)  from main_service
	where  doctor_id = (select id from doctors where name = 'Русских Евстигней Яковович');

select sum(price) from main_service
	where id in (select id FROM main_service  where year(created_at) = 2019 and month(created_at) = 8)
	and  doctor_id = (select id from doctors where name = 'Русских Евстигней Яковович');



-- Продажи администраторов. Средний чек администратора и продажи на дату
select user_id, sum(price)  from main_service group by user_id;

select user_id, sum(price)  from main_service
where  user_id = (select id from users where name = 'Смолянинова Юнона Геннадиевна');

select user_id, truncate(avg(price), 2)  from main_service
where  user_id = (select id from users where name = 'Смолянинова Юнона Геннадиевна');

select sum(price) from main_service
where id in (select id FROM main_service  where year(created_at) = 2019 and month(created_at) = 8)
and  user_id = (select id from users where name = 'Смолянинова Юнона Геннадиевна');



-- Возрастные категории пацинтов-детей
select * from patients_under_18 where birthday between '2013-08-26' and '2018-08-26';



-- Ошибка, если не внесли паспортные данные 
delimiter //
drop trigger if exists passport_trigger//
create trigger  passport_trigger before insert on representatives
for each row
begin
	if (new.passport = ' ' or new.passport is null)
	then
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
	end if;
end//

delimiter //
drop trigger if exists passport_trigger//
create trigger  passport_trigger before insert on patients_upper_18
for each row
begin
	if (new.passport = ' ' or new.passport is null)
	then
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
	end if;
end//




