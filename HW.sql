CREATE DATABASE Academy

use Academy

CREATE TABLE Curators (
Id int NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(MAX) NOT NULL CHECK(LEN(Name) > 0),
Surname nvarchar(MAX) NOT NULL CHECK(LEN(Surname) > 0)
)

CREATE TABLE Departments (
Id INT NOT NULL PRIMARY KEY IDENTITY,
Building INT NOT NULL CHECK(Building >= 1 AND Building <= 5),
Financing money NOT NULL CHECK(Financing >= 0) DEFAULT 0,
Name nvarchar(100) NOT NULL CHECK(LEN(Name) > 0) UNIQUE,
FacultyId INT NOT NULL FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
)

CREATE TABLE Faculties (
Id INT NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(100) NOT NULL CHECK(LEN(Name) > 0) UNIQUE
)

CREATE TABLE Groups (
Id INT NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(10) NOT NULL CHECK(LEN(Name) > 0) UNIQUE,
Year INT NOT NULL CHECK (Year >= 1 AND Year <= 5),
DepartmentId INT NOT NULL FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
)

CREATE TABLE GroupsCurators (
Id INT NOT NULL IDENTITY PRIMARY KEY,
CuratorId INT NOT NULL FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
GroupId INT NOT NULL FOREIGN KEY (GroupId) REFERENCES Groups(Id)
)

CREATE TABLE GroupsLectures (
Id INT NOT NULL IDENTITY PRIMARY KEY,
GroupId INT NOT NULL FOREIGN KEY (GroupId) REFERENCES Groups(Id),
LectureId INT NOT NULL FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
)

CREATE TABLE GroupsStudents (
Id INT NOT NULL IDENTITY PRIMARY KEY,
GroupId INT NOT NULL FOREIGN KEY (GroupId) REFERENCES Groups(Id),
StudentId INT NOT NULL FOREIGN KEY (StudentId) REFERENCES Students(Id)
)

CREATE TABLE Lectures (
Id INT NOT NULL IDENTITY PRIMARY KEY,
Date date NOT NULL CHECK(Date > GETDATE()),
SubjectId INT NOT NULL FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
TeacherId INT NOT NULL FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

CREATE TABLE Students (
Id INT NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(MAX) NOT NULL CHECK(LEN(Name) > 0),
Rating INT NOT NULL CHECK(Rating >= 0 AND Rating <= 5),
Surname NVARCHAR(MAX) NOT NULL CHECK(LEN(Surname) > 0)
)

CREATE TABLE Subjects (
Id INT NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(100) NOT NULL CHECK(LEN(Name) > 0) UNIQUE
)

CREATE TABLE Teachers (
Id INT NOT NULL IDENTITY PRIMARY KEY,
IsProfessor bit NOT NULL DEFAULT 0,
Name nvarchar(MAX) NOT NULL CHECK(LEN(Name) > 0),
Salary MONEY NOT NULL CHECK(Salary > 0),
Surname NVARCHAR(MAX) NOT NULL CHECK(LEN(Surname) > 0)
)

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES (1,1)
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES (2,2)
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES (3,3)

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (1,1)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (2,2)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (3,3)

INSERT INTO Lectures (Date, SubjectId, TeacherId) VALUES (GETDATE() + DATEADD(hh, 1, current_timestamp), 1, 1)
INSERT INTO Lectures (Date, SubjectId, TeacherId) VALUES (GETDATE() + DATEADD(hh, 1, current_timestamp), 2, 2)
INSERT INTO Lectures (Date, SubjectId, TeacherId) VALUES (GETDATE() + DATEADD(hh, 1, current_timestamp), 3, 3)

INSERT INTO GroupsStudents (GroupId, StudentId) VALUES (1,1)
INSERT INTO GroupsStudents (GroupId, StudentId) VALUES (2,2)
INSERT INTO GroupsStudents (GroupId, StudentId) VALUES (3,3)

INSERT INTO Students (Name, Rating, Surname) VALUES ('Vasja', 3, 'Vasylenko')
INSERT INTO Students (Name, Rating, Surname) VALUES ('Darja', 4, 'Semenivna')
INSERT INTO Students (Name, Rating, Surname) VALUES ('Irina', 5, 'Petrova')

INSERT INTO Subjects (Name) VALUES ('Mikro Biologia')
INSERT INTO Subjects (Name) VALUES ('C#')
INSERT INTO Subjects (Name) VALUES ('English')

INSERT INTO Teachers (IsProfessor, Name, Salary, Surname) VALUES (1, 'Denys', 15000, 'Kravchuk')
INSERT INTO Teachers (IsProfessor, Name, Salary, Surname) VALUES (1, 'Olga', 14000, 'Ivanova')
INSERT INTO Teachers (IsProfessor, Name, Salary, Surname) VALUES (0, 'Petro', 10000, 'Semenov')


-- --
INSERT INTO Groups (Name, Year, DepartmentId) VALUES ('D221', 3, 1)
INSERT INTO Groups (Name, Year, DepartmentId) VALUES ('D311', 1, 2)
INSERT INTO Groups (Name, Year, DepartmentId) VALUES ('D541', 4, 3)

INSERT INTO Faculties (Name) VALUES ('Computer Science')
INSERT INTO Faculties (Name) VALUES ('Biologia')
INSERT INTO Faculties (Name) VALUES ('English')

INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES (2, 120000, 'Software Development', 1)
INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES (4, 80000, 'Medicina', 2)
INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES (1, 11000, 'Filologia', 3)

INSERT INTO Curators (Name, Surname) VALUES ('Ivan', 'Ivanov')
INSERT INTO Curators (Name, Surname) VALUES ('Sasha', 'Petrov')
INSERT INTO Curators (Name, Surname) VALUES ('Dmytro', 'Semenov')

-- ---

--	1. Вывести номера корпусов, если суммарный фонд финансирования расположенных в них кафедр превышает 100000.
SELECT Building FROM Departments WHERE Departments.Financing > 100000

--	2. Вывести названия групп 5-го курса кафедры “Software Development”, которые имеют более 10 пар в первую неделю
SELECT g.Name FROM Groups as g
JOIN Departments as d on g.DepartmentId = d.Id
WHERE d.Name = 'Software Development' AND g.Year = 5
-- которые имеют более 10 пар в первую неделю - в базі данних не вказано нічого про пари
--	3. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) больше, чем рейтинг группы “D221”.

SELECT g.Name FROM Groups as g
JOIN GroupsStudents as gs on gs.GroupId = g.Id
JOIN Students as st on st.Id = gs.StudentId
GROUP BY g.Name
HAVING AVG(st.Rating) > (
SELECT AVG(st.Rating) FROM Groups as g
JOIN GroupsStudents as gs on gs.GroupId = g.Id
JOIN Students as st on st.Id = gs.StudentId
GROUP BY g.Name
HAVING g.Name = 'D221')


 
--	4. Вывести фамилии и имена преподавателей, ставка которых выше средней ставки профессоров.

SELECT Name, Surname FROM Teachers as t
WHERE Salary > (SELECT AVG(Salary) FROM Teachers WHERE IsProfessor = 1)

--	5. Вывести названия групп, у которых больше одного куратора.

SELECT g.Name FROM Curators as c
JOIN GroupsCurators as gs on gs.CuratorId = c.Id
JOIN Groups as g on gs.GroupId = g.Id 
GROUP BY g.Name
HAVING COUNT(c.Id) > 1 

--	6. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) меньше, чем минимальный рейтинг групп 4-го курса.

SELECT g.Name FROM Groups as g
JOIN GroupsStudents as gs on gs.GroupId = g.Id
JOIN Students as st on gs.StudentId = st.Id
GROUP BY g.Name
HAVING AVG(st.Rating) < (

SELECT MIN(s.Rating) FROM Students as s
JOIN GroupsStudents as gs on gs.StudentId = s.Id
JOIN Groups as g on gs.GroupId = g.Id
JOIN Departments as d on g.DepartmentId = d.Id
WHERE g.Year = 4)

--	7. Вывести названия факультетов, суммарный фонд финансирования кафедр которых больше суммарного фонда финансирования кафедр факультета “Computer Science”.

SELECT f.Name FROM Faculties as f 
JOIN Departments as d on f.Id = d.FacultyId
GROUP BY f.Name
HAVING SUM(d.Financing) > (

SELECT SUM(d.Financing) FROM Departments as d 
JOIN Faculties as f on d.FacultyId = f.Id
GROUP BY f.Name
HAVING f.Name = 'Computer Science')

--	8. Вывести названия дисциплин и полные имена преподавателей, читающих наибольшее количество лекций по ним

SELECT s.Name, (t.Name + ' ' + t.Surname) as [Fullname of teаcher], COUNT(l.Id) as [Найбільше лекцій у вчителя] FROM Subjects as s
JOIN Lectures as l on l.SubjectId = s.Id
JOIN Teachers as t on l.TeacherId = t.Id
GROUP BY s.Name, t.Name, t.Surname
HAVING COUNT(l.Id) = (

SELECT MAX(o.count) 
FROM (SELECT COUNT(l.Id) as [count] 
FROM Subjects as s JOIN Lectures as l on l.SubjectId = s.Id JOIN Teachers as t on l.TeacherId = t.Id GROUP BY s.Name) as o
)


--	9. Вывести название дисциплины, по которому читается меньше всего лекций.

SELECT s.Name, COUNT(l.Id) as [Количество лекций] FROM Subjects as s
JOIN Lectures as l on l.SubjectId = s.Id
JOIN Teachers as t on l.TeacherId = t.Id
GROUP BY s.Name
HAVING COUNT(l.Id) = (

SELECT MIN(o.count) 
FROM (SELECT COUNT(l.Id) as [count] 
FROM Subjects as s JOIN Lectures as l on l.SubjectId = s.Id JOIN Teachers as t on l.TeacherId = t.Id GROUP BY s.Name) as o
)

--	10. Вывести количество студентов и читаемых дисциплин на кафедре “Software Development”.
SELECT COUNT(st.Id) as [количество студентов], COUNT(s.Id) as [количество читаемых дисциплин] FROM Departments as d
JOIN Groups as g on g.DepartmentId = d.Id
JOIN GroupsStudents as gs on gs.GroupId = g.Id
JOIN Students as st on st.Id = gs.StudentId
JOIN GroupsLectures as gl on gl.GroupId = g.Id
JOIN Lectures as l on l.Id = gl.LectureId
JOIN Subjects as s on s.Id = l.SubjectId
WHERE d.Name = 'Software Development'

