Create Database airline

Use airline

Create Table Pilot
(
EmployeeID int NOT NULL,
Airline varchar(20) NOT NULL,
Name char(25) NOT NULL,
Salary int NOT NULL
)

INSERT INTO Pilot (EmployeeID,Airline,Name,Salary)
VALUES	(70007, 'Airbus 380',	'Kim',		60000),
		(70002,	'Boeing',		'Laura',	20000),
		(10027,	'Airbus 380',	'Will',		80050),
		(10778,	'Airbus 380',	'Warren',	80780),
		(115585, 'Boeing',		'Smith',	25000),
		(114070,'Airbus 380',	'Katy',		78000)



WITH totalSalary(Airline, total) as
    (SELECT Airline, sum(Salary)
    FROM Pilot
    GROUP BY Airline),
    airlineAverage(avgSalary) as 
    (SELECT avg(Salary)
    FROM Pilot )
SELECT Airline
FROM totalSalary, airlineAverage
WHERE totalSalary.total > airlineAverage.avgSalary;



