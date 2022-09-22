create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');

----------------------------------------------------------------
select * from phonelog

go

WITH Cte_Calls as (
select Callerid , Cast(Datecalled as Date) as CalledDate , Min(DateCalled) as FirstCall
, Max(DateCalled) as LastCall
from phonelog
group by Callerid , Cast(Datecalled as Date)
), last_cte as (
select c.* , p.Recipientid as First_Rec , p2.Recipientid as Last_rec  
from Cte_Calls c  inner join phonelog p
on c.Callerid = p.Callerid and c.FirstCall = p.Datecalled
inner Join phonelog p2 
on p2.Callerid = c.Callerid and c.LastCall = p2.Datecalled)
select last_cte.Callerid , last_cte.First_Rec , last_cte.Last_rec from last_cte
where First_Rec = Last_rec


----------------------------------------------------------------------------------------------
GO

SELECT * FROM candidates;

GO 
WITH ALL_cte as (
	SELECT * , SUM(salary) over(partition by experience order by salary) rn from candidates c
) , Senior_Cte as (
select * from ALL_cte
where experience ='Senior' and rn <= 70000 )
, Final_cte as (
select * from ALL_cte 
where experience = 'Junior' and rn <= 70000 - (select sum(salary) from Senior_Cte where experience='Senior')
union 
select * from Senior_Cte)
select *,sum(salary) over(order by salary) as Total_budget  from Final_cte











-------------------------------------------------------------------------
select * from students
select * from Exams


select s.student_id , student_name , e.exam_id ,   e.score 
, max(e.score) over(partition by exam_id order by e.score) Most
from  students s 
join exams e 
on e.student_id = s.student_id



GO
WITH Exams_cte as (

	select exam_id , min(score) as Least , max(score) as Most from Exams e 
	group by exam_id

) , e_cte as (

	select e.exam_id as exam_id, e.Least as Least_Score , e.Most as Most_Score from Exams_cte e 
	join Exams e2
	on e2.exam_id = e.exam_id and e2.score = e.Least
	join Exams e3
	on e3.exam_id = e.exam_id and e3.score = e.Most

)
select s.student_id , s.student_name , e.score , e.exam_id , ec.Least_Score , ec.Most_Score
from students s join Exams e 
on e.student_id = s.student_id
join e_cte ec on e.exam_id = ec.exam_id
where e.score != ec.Least_Score and e.score != ec.Most_Score
-----------------------------------------------------------------------------------------------



create table call_details  (
call_type varchar(10),
call_number varchar(12),
call_duration int
);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);





select * from call_details;

GO
WITH X_CTE AS (
SELECT call_number , 
sum(case when call_type = 'OUT' then call_duration else null end ) as sum_out_duration ,
sum(case when call_type = 'INC' then call_duration else null end ) as sum_inc_duration
from call_details
group by call_number )
SELECT * FROM X_CTE 
WHERE sum_out_duration > sum_inc_duration
AND 
      sum_inc_duration is not null
AND   
      sum_out_duration is not null
      

---------------------------------------------------------------------


create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);


select * from stadium;

-------------------------------------------



select grp , count(*) as num_count from (
	select * , row_number() over(order by visit_date) as rn , 
			   id-row_number() over(order by visit_date) grp
	from stadium
	where no_of_people >= 100) as x 
group by grp 
having count(*) >= 3;

go
with xx as (
select * , row_number() over(order by visit_date) as rn , 
			   id-row_number() over(order by visit_date) grp
	from stadium
	where no_of_people >= 100)












