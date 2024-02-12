use LeetCodePractice;
go

-- Employee bonus

/* Write your T-SQL query statement below */
SELECT  name, bonus
FROM    EMPLOYEE AS E 
		LEFT JOIN 
		BONUS AS B
		ON E.empId = B.empId
WHERE	ISNULL(BONUS, 0) < 1000;


select *
from Bonus

-- Duplicate emails
drop table if exists Person
Create table Person (Id int, Email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'john@example.com')
insert into Person (id, email) values ('2', 'bob@example.com')
insert into Person (id, email) values ('3', 'john@example.com')


begin tran  -- my solution
delete from Person
where Email in (select Email
				from	Person
				group by Email
				having count(Email) > 1)
and Id not in (select min(Id)
			   from Person
			   group by Email
			   having count(Email) > 1)
rollback;

begin tran  -- faster solution
DELETE p1
FROM Person p1, Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id
rollback;

select *
from Person

-- rising temperature

Create table Weather (id int, recordDate date, temperature int)
Truncate table Weather
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10')
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25')
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20')
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30')

select	w1.id
from	Weather as w1
join Weather as w2 on datediff(DAY, w1.recordDate, w2.recordDate) = -1
where	w1.temperature > w2.temperature

-- consecutive numbers
Create table Logs (id int, num int)
Truncate table Logs
insert into Logs (id, num) values ('1', '1')
insert into Logs (id, num) values ('2', '1')
insert into Logs (id, num) values ('3', '1')
insert into Logs (id, num) values ('4', '2')
insert into Logs (id, num) values ('5', '1')
insert into Logs (id, num) values ('6', '2')
insert into Logs (id, num) values ('7', '2')

select	num
from	Logs
group by num
having	count(id) >= 3 

select	distinct l1.num as ConsecutiveNums
from	Logs as l1
join Logs as l2 on l2.id -1 = l1.id
join Logs as l3 on l3.id -1 = l2.id
where	l1.num = l2.num
and		l2.num = l3.num

-- 586. Customer Placing the Largest Number of Orders
drop table if exists orders;
Create table orders (order_number int, customer_number int);
Truncate table orders;
insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');

with cte as(
    select   customer_number, count(order_number) as num_orders
    from	 orders
    group by customer_number
)
select	customer_number
from	cte
where	num_orders in (select	max(num_orders)
						from	cte);

with cte as(
    select   customer_number, count(order_number) as num_orders
    from	 orders
    group by customer_number
)
select	customer_number
from	cte
where	num_orders in (select	top 1 with ties (num_orders)
					   from		cte
					   order by num_orders desc);

-- 607. Sales Person
drop table if exists orders
Create table SalesPerson (sales_id int, name varchar(255), salary int, commission_rate int, hire_date date)
Create table Company (com_id int, name varchar(255), city varchar(255))
Create table Orders (order_id int, order_date date, com_id int, sales_id int, amount int)
Truncate table SalesPerson
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('1', 'John', '100000', '6', '4/1/2006')
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('2', 'Amy', '12000', '5', '5/1/2010')
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('3', 'Mark', '65000', '12', '12/25/2008')
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('4', 'Pam', '25000', '25', '1/1/2005')
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('5', 'Alex', '5000', '10', '2/3/2007')
Truncate table Company
insert into Company (com_id, name, city) values ('1', 'RED', 'Boston')
insert into Company (com_id, name, city) values ('2', 'ORANGE', 'New York')
insert into Company (com_id, name, city) values ('3', 'YELLOW', 'Boston')
insert into Company (com_id, name, city) values ('4', 'GREEN', 'Austin')
Truncate table Orders
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('1', '1/1/2014', '3', '4', '10000')
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('2', '2/1/2014', '4', '5', '5000')
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('3', '3/1/2014', '1', '1', '50000')
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('4', '4/1/2014', '1', '4', '25000')


select	name
from	SalesPerson
where	name not in (select	s.name
					 from		SalesPerson as s
					 join Orders as o
					 		on s.sales_id = o.sales_id
					 join Company as c
					 		on o.com_id = c.com_id
					 where	c.name = 'RED');

-- 619.Biggest Single Number

Create table MyNumbers (num int)
Truncate table MyNumbers
insert into MyNumbers (num) values ('8')
insert into MyNumbers (num) values ('8')
insert into MyNumbers (num) values ('3')
insert into MyNumbers (num) values ('3')
insert into MyNumbers (num) values ('1')
insert into MyNumbers (num) values ('4')
insert into MyNumbers (num) values ('5')
insert into MyNumbers (num) values ('6')

with cte as (
	select	num, count(num) as Num_Occurence
	from	MyNumbers
	group by num)
select max(num) as num
from cte
where Num_Occurence = 1

-- 620. Not Boring Movies
Create table cinema (id int, movie varchar(255), description varchar(255), rating numeric(4, 2))
Truncate table cinema
insert into cinema (id, movie, description, rating) values ('1', 'War', 'great 3D', '8.9')
insert into cinema (id, movie, description, rating) values ('2', 'Science', 'fiction', '8.5')
insert into cinema (id, movie, description, rating) values ('3', 'irish', 'boring', '6.2')
insert into cinema (id, movie, description, rating) values ('4', 'Ice song', 'Fantacy', '8.6')
insert into cinema (id, movie, description, rating) values ('5', 'House card', 'Interesting', '9.1')

select	*
from	cinema
where	id%2 = 1
and		description <> 'boring'
order by rating desc;

-- 627. Swap Salary
Create table Salary (id int, name varchar(100), sex char(1), salary int)
Truncate table Salary
insert into Salary (id, name, sex, salary) values ('1', 'A', 'm', '2500')
insert into Salary (id, name, sex, salary) values ('2', 'B', 'f', '1500')
insert into Salary (id, name, sex, salary) values ('3', 'C', 'm', '5500')
insert into Salary (id, name, sex, salary) values ('4', 'D', 'f', '500')

-- 1050. Actors and Directors Who Cooperated At Least Three Times
Create table ActorDirector (actor_id int, director_id int, timestamp int)
Truncate table ActorDirector
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '0')
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '1')
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '2')
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '3')
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '4')
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '5')
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '6')

select	*
from ActorDirector

select	actor_id, director_id
from	ActorDirector
group by actor_id, director_id
having	count(timestamp) >= 3	

-- 1068. Product Sales Analysis I
drop table if exists Sales;
drop table if exists Product;
Create table Sales (sale_id int, product_id int, year int, quantity int, price int)
Create table Product (product_id int, product_name varchar(10))
Truncate table Sales
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000')
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000')
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000')
Truncate table Product
insert into Product (product_id, product_name) values ('100', 'Nokia')
insert into Product (product_id, product_name) values ('200', 'Apple')
insert into Product (product_id, product_name) values ('300', 'Samsung')

select	product_name, year, price
from	Sales as S
join	Product as p
		on S.product_id = P.product_id

-- 1075. Project Employees I
drop table if exists Project;
drop table if exists Employee;
Create table Project (project_id int, employee_id int)
Create table Employee (employee_id int, name varchar(10), experience_years int)
Truncate table Project
insert into Project (project_id, employee_id) values ('1', '1')
insert into Project (project_id, employee_id) values ('1', '2')
insert into Project (project_id, employee_id) values ('1', '3')
insert into Project (project_id, employee_id) values ('2', '1')
insert into Project (project_id, employee_id) values ('2', '4')
Truncate table Employee
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3')
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2')
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1')
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2')

select  project_id,
		cast(avg(experience_years*1.0) as numeric(8, 2)) as average_years
from	Project as p
join	Employee as e 
		on p.employee_id = e.employee_id
group by project_id

-- 1084. Sales Analysis III

drop table if exists Product;
drop table if exists Sales;

Create table Product (product_id int, product_name varchar(10), unit_price int)
Create table Sales (seller_id int, product_id int, buyer_id int, sale_date date, quantity int, price int)
Truncate table Product
insert into Product (product_id, product_name, unit_price) values ('1', 'S8', '1000')
insert into Product (product_id, product_name, unit_price) values ('2', 'G4', '800')
insert into Product (product_id, product_name, unit_price) values ('3', 'iPhone', '1400')
Truncate table Sales
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '1', '1', '2019-01-21', '2', '2000')
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '2', '2', '2019-02-17', '1', '800')
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('2', '2', '3', '2019-06-02', '1', '800')
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('3', '3', '4', '2019-05-13', '2', '2800')
--NA
(
select	product_id, product_name
from	Product
where	product_id in (select	product_id
					   from		Sales
					   where	sale_date <= '20190331'
					   and		sale_date >= '20190101')
)
except
(
select	product_id, product_name
from	Product
where	product_id in (select	product_id
					   from		Sales
					   where	sale_date >= '20190331'
					   or		sale_date <= '20190101'));
--NA
with cte as
(
select	*
from	Product
where	product_id in (select	product_id
					   from		Sales
					   where	sale_date <= '20190331'
					   and		sale_date >= '20190101')
)
select	product_id, product_name
from	cte
where	product_id not in (select	product_id
					   from		Sales
					   where	sale_date >= '20190331'
					   or		sale_date <= '20190101');
--works
select	p.product_id, p.product_name 
from	Product as p
join	Sales as s
on		p.product_id = s.product_id 
group by p.product_id, p.product_name 
having	min(s.sale_date) >= '2019-01-01' 
and		max(s.sale_date) <= '2019-03-31';

-- 1141. User Activity for the Past 30 Days I
drop table if exists Activity
Create table Activity (user_id int, session_id int, activity_date date, activity_type char(20))
Truncate table Activity
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'open_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'scroll_down')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'end_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-20', 'open_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'send_message')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'end_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'open_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'send_message')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'end_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'open_session')
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'end_session')

select	activity_date as day, 
		count(distinct user_id) as active_users
from	Activity
where	activity_date between ('2019-06-28')
and		('2019-07-27')
group by activity_date
having count(session_id) > 0

select	*
from	Activity

-- 1148. Article Views I
drop table if exists Views;

Create table Views (article_id int, author_id int, viewer_id int, view_date date)
Truncate table Views
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '5', '2019-08-01')
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '6', '2019-08-02')
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '7', '2019-08-01')
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '6', '2019-08-02')
insert into Views (article_id, author_id, viewer_id, view_date) values ('4', '7', '1', '2019-07-22')
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21')
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21')

select	distinct author_id as id
from	Views
where	author_id = viewer_id

-- 1075. Project Employees I
drop table if exists Project;
drop table if exists Employee;

Create table Project (project_id int, employee_id int)
Create table Employee (employee_id int, name varchar(10), experience_years int)
Truncate table Project
insert into Project (project_id, employee_id) values ('1', '1')
insert into Project (project_id, employee_id) values ('1', '2')
insert into Project (project_id, employee_id) values ('1', '3')
insert into Project (project_id, employee_id) values ('2', '1')
insert into Project (project_id, employee_id) values ('2', '4')
Truncate table Employee
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3')
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2')
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1')
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2')


select	project_id,
		cast(avg(experience_years*1.0) as numeric (8,2)) as average_years		
from	Project as p
join	Employee as e
		on p.employee_id = e.employee_id
group by project_id


select	*
from	Project
where	employee_id in (select	employee_id
						from	Employee)