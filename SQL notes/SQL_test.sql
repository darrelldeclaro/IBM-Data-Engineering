USE optum

Select *
From Class_Information


--Using the table Class_Information, write a query that returns the number of students from Cook Islands, Islas Malvinas, Djibouti and Belarus
Select Location, count(student) as totalCount
From Class_Information
where Location IN ('Cook Islands', 'Islas Malvinas', 'Djibouti', 'Belarus')
group by Location


--Using the table Class_Information, Show how many Subjects and Countries each Teachers are handling
Select Teacher, count(Subject) as countSubject,
	count(Location) as countLocation
From Class_Information
group by Teacher


--With table Employee, provide the complete information of each employees using the table Employee_Details

--employee table
select *
from Employee

--employee details
select *
from Employee_Details


Select e.ID, e.[Emp Code], e.Associate, e.[Team Manager], ed.Location,ed.Department,ed.Shift
From Employee e
inner join Employee_Details ed ON
	e.ID = ed.id AND e.[Emp Code]=ed.[Emp Code]
	

--Refering to number 3. Remove Duplicates by keeping the latest information of the employee
select count(associate) - count(distinct(Associate)) +2
from Employee

Select distinct(e.Associate), e.ID, e.[Emp Code]
From Employee e
inner join Employee_Details ed ON
	e.ID = ed.id AND e.[Emp Code]=ed.[Emp Code]
where e.ID >= (select count(associate) - count(distinct(Associate)) +2
				from Employee)
--order by e.ID desc; use to identify the latest ID record and the number of EMP


--Downtime numbers are kept in table Employee. Write a query that selects the employee name and average downtime for each employee with more than 1 downtime.
Select Associate, AVG(Downtime) as avgDowntime
From Employee
Group by Associate


--Write a query to find how many customers visited the Shop app (Table) and didn’t buy any, bought 1 and so on.

Select DISTINCT(Customer), sum(Qty) AS [sum Qty]
From Shop
group by Customer



SELECT Customer, 
	CASE 
		WHEN [sum Qty]>=1 THEN concat('Customer Bought ', [sum Qty])
		ELSE 'Visited Only' 
	END AS [Customer Count]
from	(
			Select DISTINCT(Customer), sum(Qty) AS [sum Qty]
			From Shop
			group by Customer
				) as subquery
ORDER BY [sum Qty] 

	



--Using table Customers, create a query to report how many and what fruits have been ordered on each day of the week
Select cast(date as date) as date_, Fruits, count(Fruits) as ordered
From Customers
group by Date, Fruits
order by Date

Select *
From Customers


--In Employee_Attendance table Identify all employees that has at 2 consecutive absences per month. Provide how many times each employees have exceeded the treshold.
Select *, ([absance per month]/2) as [exceeded treshold]
From (select Employee, count([Attendance Status]) as [absance per month]
	from Employee_Attendance
	group by Employee, [Attendance Status]) as subquery
where [absance per month]>2


select *
from Employee_Attendance

--You are given Employee_Salary table that contains the employee, company name and salaries. From that table, write a query to find the median salary of each company.
Select *
From Employee_Salary

--using union to combine different queries 
select DISTINCT(Company), (PERCENTILE_CONT(.5) within group (order by Salary) over()) as [median salary]
		from
		(select Company, Salary
		from Employee_Salary
		where Company='Company A' 
		) as a
union 
select DISTINCT(Company),	(PERCENTILE_CONT(.5) within group (order by Salary) over()) as [median salary]
		from
		(select Company, Salary
		from Employee_Salary
		where Company='Company B' 
		) as a
union 
select DISTINCT(Company),	(PERCENTILE_CONT(.5) within group (order by Salary) over()) as [median salary]
	from
		(select Company, Salary
		from Employee_Salary
		where Company='Company C' 
		) as a
union 
select DISTINCT(Company),	(PERCENTILE_CONT(.5) within group (order by Salary) over()) as [median salary]
	from
		(select Company, Salary
		from Employee_Salary
		where Company='Company D' 
		) as a

--using over() and partition by 
select distinct(Company),	(PERCENTILE_CONT(.5) within group (order by Salary) over( partition by company)) as [median salary]
from
Employee_Salary
		



