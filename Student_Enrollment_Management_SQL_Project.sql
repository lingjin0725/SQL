-- File: D324_HW4_LingJin.sql
-- DATA324 Homework 4
-- Name: Ling Jin
-- WSU ID: 011880184

--1.
SELECT DISTINCT C.courseno, C.credits
FROM Course C, Enroll E, Student S
WHERE C.courseno = E.courseno AND E.sID = S.sID
   AND S.major='CptS' 
   AND S.trackcode = 'SYS'
   ORDER BY courseno;

--2.
SELECT S.sName, S.sID,S.major, S.trackcode, SUM(credits)
FROM Course C, Enroll E, Student S
WHERE C.courseno = E.courseno AND E.sID = S.sID
GROUP BY S.sID
HAVING SUM(credits)>18
ORDER BY S.sName,S.sID;

--3.
SELECT distinct E1. courseno 
FROM Student S1, Enroll E1
WHERE S1.sID = E1.sID 
AND S1.trackcode='SE' 
AND S1.major='CptS' 
AND NOT EXISTS (
    SELECT 1
    FROM Enroll e2
    JOIN Student s2 ON e2.sID = s2.sID
    WHERE e1.courseno = e2.courseno
    AND (s2.major != 'CptS' OR s2.trackcode != 'SE')
	);

--4.
SELECT S2.sname, S2.sID, S2.major, E2.courseno, E2.grade
FROM Student S1, Enroll E1, Enroll E2, Student S2
WHERE S1.sname='Diane' AND S1.sid=E1.sid AND E1.courseno=E2.courseno AND S2.sid=E2.sid AND E1.grade=E2.grade 
AND S1.sID<> S2.sID
ORDER BY S2.sname;

--5.
SELECT s.sname, s.sID 
FROM Student s LEFT OUTER JOIN Enroll e ON s.sID = e.sID
WHERE major='CptS' AND courseno IS NULL
ORDER BY sname;

--6.
SELECT distinct C.courseno, enroll_limit, enrollnum
FROM Course as C, 
     (SELECT courseno, COUNT(sID) as enrollNum
      FROM Enroll as E
      GROUP BY courseno ) as Temp
WHERE C.classroom LIKE  'Sloan%' AND C.courseno = Temp.courseno AND C.enroll_limit < Temp.enrollNum;

--7.
SELECT distinct S.sname, E1.sID, E1.courseno
FROM Enroll as E1, Student S
WHERE S.major='CptS' AND E1.sID = S.sID
AND EXISTS 
	(SELECT *
	 FROM Enroll E2, Prereq as P
	 WHERE E2.courseNo = P.preCourseNo AND E1.courseno = P.courseno AND E1.sID = E2.sID
	 AND E2.grade < 2 );

--8.
SELECT T1.courseno, T2.passCount*100/T1.allCount
FROM
( SELECT courseno, COUNT(*) as allCount
  FROM Enroll
  WHERE grade IS NOT NULL and courseno LIKE 'CptS%'
  GROUP BY courseno ) as T1,
( SELECT courseno, COUNT(*) as passCount
  FROM Enroll
  WHERE grade IS NOT NULL AND courseno LIKE 'CptS%' AND grade >=2
  GROUP BY courseno ) as T2
  WHERE T1.courseno = T2.courseno;

--9.
--i. This query finds all courses that have at least two prerequisites. It returns the course number along with the total number of prerequisites for each course.
--ii 
SELECT C.courseno, COUNT(distinct preCourseNo)
FROM Course C, Prereq P
WHERE C.courseno = P.courseno 
GROUP BY C.courseno
HAVING COUNT(distinct preCourseNo)>=2;


-- File: HW4Solution.sql
--1.	Find the distinct courses that ‘SYS’ track students in 'CptS' major are enrolled in. Return the courseno and credits for those courses. Return results sorted based on courseno. 
SELECT distinct C.courseno, C.credits
FROM Course C, Enroll E, Student S
WHERE C.courseno = E.courseno AND E.sID = S.sID 
   AND S.major='CptS' AND S.trackcode = 'SYS'
   ORDER BY courseno;
   
--2.	Find the sorted names, ids, majors and track codes of the students who are enrolled in more than 18 credits (19 or above). 
SELECT S.sName,S.sID,S.major, S.trackcode, SUM(credits)
FROM Course C, Enroll E, Student S
WHERE C.courseno = E.courseno AND E.sID = S.sid 
GROUP BY S.sID
HAVING SUM(credits)>18
ORDER BY S.sName,S.sID;

OR 

SELECT sName,STudent.sID,major, trackcode, Temp.totCredits
FROM Student, 
  ( SELECT E.sID, SUM(credits) as totCredits
  FROM Course C, Enroll E
  WHERE C.courseno = E.courseno 
  GROUP BY E.sID
  HAVING SUM(credits)>18 ) as Temp
WHERE Temp.sID = Student.sid 
ORDER BY Student.sname,Temp.sID;

     
	
Select * from prereq order by courseno

Prereq.courseno 
--3.	Find the courses that only 'SE' track  students in 'CptS major have been enrolled in. Give an answer without using the set EXCEPT operator.
SELECT distinct courseno 
FROM Student S1, Enroll E1
WHERE S1.sid = E1.sid AND S1.trackcode='SE' AND S1.major='CptS' 
AND E1.courseno NOT IN 
  ( SELECT courseno
    FROM Student S2, Enroll E2
    WHERE S2.sid = E2.sid AND S2.trackcode<>'SE'  )

--4.	Find the students who have enrolled in the courses that Diane enrolled and earned the same grade Diane earned in those courses. Return the student name, sID, major as well as the courseno and grade of the courses they have taken.  
SELECT S2.sname, S2.sid, S2.major, E2.courseno,E2.grade
FROM Student S1, Enroll E1, Student S2, Enroll E2
WHERE S1.sname='Diane' AND S1.sid=E1.sid AND E1.courseno=E2.courseno AND S2.sid=E2.sid AND E1.grade=E2.grade 
     AND S1.sid<> S2.sid
ORDER BY S2.sname



--5.	Find the students in 'CptS' major who are not enrolled in any classes. Return their name, sID, and major. (Note: Give a solution using outer join)

SELECT sname, Student.sid 
FROM Student LEFT OUTER JOIN Enroll ON Student.sid = Enroll.sid
WHERE major='CptS' AND courseno IS NULL
ORDER BY sname

SELECT sname, sid, major 
FROM student
WHERE major='CptS' AND sid NOT IN 
(SELECT sid FROM Enroll)
ORDER BY sname






--6.	Find the courses given in the ‘Sloan’ building which have enrolled more students than their enrollment limit. Return the courseno, enroll_limit, and the actual enrollment for those courses 
SELECT distinct C.courseno, enroll_limit, enrollnum
FROM Course as C, 
     (SELECT courseno,COUNT(sid) as enrollNum
      FROM Enroll as E
      GROUP BY courseno ) as Temp
WHERE C.classroom LIKE  'Sloan%' AND C.courseno = Temp.courseno AND C.enroll_limit < Temp.enrollNum

SELECT *
FROM Course as C
WHERE C.classroom LIKE  'Sloan%'  AND enroll_limit < 
     (SELECT COUNT(sid)
      FROM Enroll as E
      WHERE E.courseno = C.courseno) 


--7.	Find 'CptS' major students who enrolled in a course for which there exists a prerequisite that the student has not passed with grade “2”. (For example,Alice (sid: 12583589) was enrolled in CptS355 but had a grade 1.75 in CptS223.)  Return the names and sIDs of those students and the courseno of the course (i.e., the course whose prereq had a low grade).
SELECT distinct S.sname,E1.sid, E1.courseno
FROM Enroll as E1, Student S
WHERE S.major='CptS' AND E1.sid=S.sid 
AND 
  EXISTS 
	(SELECT *
	 FROM Enroll E2, Prereq as P
	  WHERE E2.courseNo = P.preCourseNo AND E1.courseno = P.courseno AND E1.sid=E2.sid
	     AND E2.grade<2 )

	  
--8.	For each 'CptS' course, find the percentage of the students who failed the course. Assume a passing grade is 2 or above. (Note: Assume students who didn’t earn a grade in class should be excluded in average calculation). 
SELECT T1.courseno,T2.passCount*100/T1.allCount
FROM
( SELECT courseno, COUNT(*) as allCount
  FROM Enroll
  WHERE grade IS NOT NULL and courseno LIKE 'CptS%'
  GROUP BY courseno ) as T1,
( SELECT courseno, COUNT(*) as passCount
  FROM Enroll
  WHERE grade IS NOT NULL AND courseno LIKE 'CptS%' AND grade >=2
  GROUP BY courseno ) as T2
 WHERE T1.courseno = T2.courseno


--9. 
--i. The query finds the courseno, credits, enroll_limit, and classroom for all courses which have at least 2 prerequisites. 
--It returns courseno AND the number of prereqs for those courses. 

--ii Corresponding SQL is as follows:
SELECT C.courseno, COUNT(distinct preCourseNo)
FROM Course C, Prereq P
WHERE C.courseno=P.courseno 
GROUP BY C.courseno
HAVING COUNT(distinct preCourseNo)>=2



-- File: student.sql
DROP TABLE IF EXISTS Student; 

CREATE TABLE Student (
	sID  	CHAR(8),
	sName  VARCHAR(30),
	major 	VARCHAR(10),
	trackcode VARCHAR(10),
	PRIMARY KEY(sID),
	FOREIGN KEY (major,trackcode) REFERENCES Tracks(major,trackcode)
);

INSERT INTO Student(sID,sName,major,trackcode) VALUES('12584789','Jack','CptS','SE'),
													 ('12584489','Aaron','ME',NULL),
													 ('12584189','Macy','CE',NULL),
													 ('12583889','John','MATH',NULL),
													 ('12583589','Alice','CptS','SYS'),
													 ('12583289','Tom','CHE',NULL),
													 ('12582989','Amir','CHE',NULL),
													 ('12582689','Nick','CHE',NULL),
													 ('12582389','Ali','CptS','SE'),
													 ('12582089','Jack','ME',NULL),
													 ('12581789','Cathy','ME',NULL),
													 ('12581489','Bob','ME',NULL),
													 ('12581189','Bill','CptS','SE'),
													 ('12580189','Amir','ME',NULL),
													 ('12579189','Ally','CHE',NULL),
													 ('12578189','Allison','CHE',NULL),
													 ('12577189','Amy',NULL,NULL),
													 ('12576189','Li','CptS','G'),
													 ('12575189','Lee','EE','ME'),
													 ('12574189','Larry','EE','POW'),
													 ('12573189','Diane',NULL,NULL),
													 ('12572189','Cindy',NULL,NULL),
													 ('12571189','Ning',NULL,NULL),
													 ('12570189','Nancy',NULL,NULL),
													 ('12569189','Walter','ME',NULL),
													 ('12568189','Yousef','EE','POW'),
													 ('12567189','Sam','ME',NULL),
													 ('12566189','Nancy','ME',NULL),
													 ('12565189','Mick','CptS','G'),
													 ('12564189','Manny','EE','ME'),
													 ('12554189','Bob','EE','ME'),
													 ('12544189','Amir',NULL,NULL),
													 ('12534189','John','CE',NULL),
													 ('12524189','Bob',NULL,NULL),
													 ('12514189','Ally','CptS','G'),
													 ('12504189','Bob','CHE',NULL),
													 ('12494189','Tom','CHE',NULL),
													 ('12484189','Yousef',NULL,NULL),
													 ('12474189','John','MATH',NULL),
													 ('12464189','Amir','MATH',NULL),
													 ('12454189','Bob','EE','POW'),
													 ('12354189','Tom','CptS','G'),
													 ('12254189','Sam','CptS','G'),
													 ('12154189','Ally','EE','ME'),
													 ('12054189','Nancy','EE','ME'),
													 ('11954189','Tom','EE','POW'),
													 ('11854189','John',NULL,NULL),
													 ('11754189','Bob','CHE',NULL),
													 ('11654189','Amir','CHE',NULL),
													 ('11554189','Ally','CHE',NULL);


-- File: course.sql
DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
	courseNo  VARCHAR(7),
	credits   INTEGER NOT NULL,
    enroll_limit INTEGER,
    classroom VARCHAR(10),
	PRIMARY KEY(courseNo)
);																  

INSERT INTO Course(courseNo,credits,enroll_limit,classroom) VALUES('CptS121',4,24,'Sloan175'),
																  ('CptS122',4,25,'Sloan175'),
																  ('CptS223',3,25,'Sloan150'),
																  ('CptS260',3,3,'Sloan150'),
																  ('CptS322',3,20,'Sloan169'),
																  ('CptS323',3,19,'Sloan169'),
																  ('CptS355',3,22,'Sloan223'),
																  ('CptS421',3,15,'Sloan223'),
																  ('CptS423',3,15,'Sloan221'),
																  ('CptS360',3,22,'Sloan175'),
																  ('CptS460',3,22,'Sloan169'),
																  ('CptS451',3,10,'Sloan7'),
																  ('CptS422',3,15,'Sloan150'),
																  ('CptS317',3,20,'Sloan9'),
																  ('CptS443',3,10,'Sloan9'),
																  ('CptS484',3,25,'Sloan150'),
																  ('CptS487',3,35,'Sloan150'),
																  ('CptS464',3,5,'Sloan9'),
																  ('CptS466',3,2,'Sloan7'),
																  ('CptS471',3,3,'Sloan7'),
																  ('EE214',3,25,'Sloan175'),
																  ('EE221',2,30,'Sloan175'),
																  ('EE234',3,15,'Sloan175'),
																  ('EE261',3,15,'Sloan169'),
																  ('EE262',3,15,'Sloan169'),
																  ('EE304',3,10,'Sloan150'),
																  ('EE311',3,10,'Sloan150'),
																  ('EE321',3,10,'Sloan9'),
																  ('EE331',3,12,'Sloan9'),
																  ('EE334',3,12,'Sloan9'),
																  ('EE341',3,10,'Sloan7'),
																  ('EE351',3,2,'EME128'),
																  ('EE361',3,9,'EME120'),
																  ('EE362',3,9,'EME56'),
																  ('EE415',2,15,'EME52'),
																  ('EE416',3,2,'EME52'),
																  ('EE431',3,5,'EME56'),
																  ('EE451',3,5,'EME128'),
																  ('EE483',3,5,'EME128'),
																  ('EE476',3,5,'EME128'),
																  ('EE499',3,2,'EME56'),
																  ('MATH101',3,30,'CUE101'),
																  ('MATH103',3,25,'CUE202'),
																  ('MATH105',3,15,'CUE201'),
																  ('MATH106',3,10,'CUE202'),
																  ('MATH108',3,10,'CUE101'),
																  ('MATH115',3,10,'CUE102'),
																  ('MATH140',3,10,'CUE107'),
																  ('MATH171',4,10,'CUE207'),
																  ('MATH172',4,10,'CUE102'),
																  ('MATH205',3,10,'CUE101'),
																  ('MATH212',3,10,'CUE203'),
																  ('MATH216',3,10,'CUE101'),
																  ('MATH220',3,10,'CUE105'),
																  ('MATH230',3,10,'CUE201'),
																  ('MATH251',3,4,'CUE202'),
																  ('MATH273',3,10,'CUE204'),
																  ('MATH283',3,10,'CUE205'),
																  ('MATH301',3,10,'CUE102'),
																  ('CE211',3,5,'Sloan150'),
																  ('CE215',3,5,'Sloan169'),
																  ('CE317',3,5,'Sloan150'),
																  ('CE322',3,5,'Sloan7'),
																  ('CE330',3,5,'Sloan9'),
																  ('CE341',3,5,'Sloan9'),
																  ('CE351',3,5,'Sloan7'),
																  ('CE401',3,5,'Sloan9'),
																  ('CE403',3,5,'Sloan9'),
																  ('CE405',3,5,'Sloan9'),
																  ('CE414',3,5,'Sloan9'),
																  ('CE416',3,5,'Sloan7'),
																  ('CE417',3,5,'Sloan7'),
																  ('ME116',3,8,'Sloan7'),
																  ('ME212',3,8,'Sloan7'),
																  ('ME216',3,8,'Sloan7'),
																  ('ME220',3,8,'Sloan32'),
																  ('ME301',3,8,'Sloan33'),
																  ('ME303',3,8,'Sloan32'),
																  ('ME305',3,8,'Sloan7'),
																  ('ME310',3,8,'Sloan9'),
																  ('ME311',3,8,'Sloan7'),
																  ('ME313',3,8,'Sloan7'),
																  ('ME316',3,8,'Sloan7'),
																  ('ME348',3,8,'Sloan7'),
																  ('ME401',3,8,'Sloan150'),
																  ('ME402',3,8,'Sloan150'),
																  ('ME431',3,8,'Sloan169'),
																  ('ME439',3,8,'Sloan9'),
																  ('ME474',3,8,'Sloan9'),
																  ('ME495',3,8,'Sloan9'),
																  ('ME499',3,8,'Sloan9'),
																  ('CHE110',3,4,'Sloan32'),
																  ('CHE211',3,4,'Sloan33'),
																  ('CHE321',3,4,'Sloan32'),
																  ('CHE334',3,5,'Sloan32'),
																  ('CHE398',3,5,'Sloan32'),
																  ('CHE433',3,5,'Sloan32'),
																  ('CHE451',3,5,'Sloan32'),
																  ('CHE476',3,5,'Sloan32'),
																  ('CHE495',3,5,'Sloan32'),
																  ('CHE498',3,5,'Sloan32');

-- File: enroll.sql
DROP TABLE IF EXISTS Enroll; 

CREATE TABLE Enroll (
	courseno     VARCHAR(7),
	sID  	CHAR(8),
	grade 	FLOAT NOT NULL,
	PRIMARY KEY (courseNo, sID),	
	FOREIGN KEY (courseNo) REFERENCES Course(courseNo),
	FOREIGN KEY (sID) REFERENCES Student(sID)
);

INSERT INTO Enroll(courseNo,sID,grade) VALUES('MATH115','12584189',3),
											 ('MATH115','12534189',2),
											 ('MATH115','12524189',4),
											 ('CE211','12584189',3.5),
											 ('CE211','12534189',2.5),
											 ('CE317','12584189',3),
											 ('CE317','12534189',2.25),
											 ('MATH140','12524189',4),
											 ('CE351','12584189',2.5),
											 ('CE330','12584189',2.75),
											 ('CE330','12534189',2.75),
											 ('CE417','12584189',3),
											 ('MATH251','12583289',2.5),
											 ('CHE110','12583289',2.75),
											 ('CHE211','12583289',3),
											 ('CHE321','12583289',3.25),
											 ('MATH251','12582989',3),
											 ('CHE110','12582989',2.5),
											 ('CHE211','12582989',2.75),
											 ('CHE321','12582989',3),
											 ('CHE334','12582989',3.25),
											 ('CHE398','12582989',3),
											 ('CHE433','12582989',3.25),
											 ('MATH251','12582689',4),
											 ('CHE110','12582689',4),
											 ('CHE211','12582689',4),
											 ('CHE321','12582689',4),
											 ('CHE334','12582689',4),
											 ('CHE398','12582689',3.5),
											 ('CHE433','12582689',4),
											 ('CHE451','12582689',4),
											 ('CHE476','12582689',3.75),
											 ('CHE495','12582689',4),
											 ('CHE498','12582689',3.75),
											 ('EE214','12582689',3.75),
											 ('MATH251','12579189',2),
											 ('CHE110','12579189',2.5),
											 ('CHE211','12579189',2.75),
											 ('CHE321','12579189',2.25),
											 ('CHE334','12579189',3),
											 ('CHE398','12579189',3.25),
											 ('CHE433','12579189',3),
											 ('CHE495','12579189',3),
											 ('MATH251','12578189',2.5),
											 ('CHE110','12578189',2.5),
											 ('CHE211','12578189',2.5),
											 ('CHE321','12578189',2.25),
											 ('CHE476','12578189',2),
											 ('MATH251','12577189',1.75),
											 ('CHE110','12577189',2),
											 ('CHE211','12577189',2.25),											 
											 ('MATH171','12584789',3),
											 ('MATH172','12584789',3),
											 ('CptS121','12584789',3),
											 ('CptS122','12584789',3),
											 ('CptS223','12584789',2.75),
											 ('CptS260','12584789',3),
											 ('CptS322','12584789',3),
											 ('CptS323','12584789',3),
											 ('CptS355','12584789',3.25),
											 ('CptS421','12584789',3),
											 ('CptS423','12584789',3),
											 ('CptS360','12584789',3),
											 ('CptS460','12584789',3.25),
											 ('CptS451','12584789',3),
											 ('CptS422','12584789',4),
											 ('CptS317','12584789',4),
											 ('MATH171','12583589',2.5),
											 ('MATH172','12583589',2.5),
											 ('CptS121','12583589',2.25),
											 ('CptS122','12583589',2),
											 ('CptS223','12583589',1.75),
											 ('CptS260','12583589',2),
											 ('CptS322','12583589',2.5),
											 ('CptS317','12583589',3),
											 ('CptS355','12583589',2.5),
											 ('CptS421','12583589',2),
											 ('CptS423','12583589',2),
											 ('CptS360','12583589',2),
											 ('CptS460','12583589',2),
											 ('CptS451','12583589',2),
											 ('MATH216','12583589',2),
											 ('MATH220','12583589',2),
											 ('CptS223','12582389',2.75),
											 ('CptS260','12582389',3),
											 ('CptS355','12582389',3.25),
											 ('CptS322','12582389',4),
											 ('CptS487','12582389',4),
											 ('CptS484','12582389',3.5),
											 ('CptS323','12582389',3.75),
											 ('CptS451','12582389',3.75),
											 ('MATH216','12582389',3),
											 ('MATH220','12582389',3),
											 ('MATH220','12581189',3),
											 ('CptS260','12581189',1.5),
											 ('CptS355','12581189',1),
											 ('CptS322','12581189',2),
											 ('CptS323','12581189',2),
											 ('CptS421','12581189',2),
											 ('CptS423','12581189',1.75),
											 ('CptS360','12581189',2.5),
											 ('CHE211','12581189',2.75),
											 ('EE221','12570189',3),
											 ('ME220','12567189',3.25),
											 ('ME301','12567189',3),
											 ('ME303','12567189',3.75),
											 ('ME305','12567189',4),
											 ('MATH171','12567189',4),
											 ('MATH172','12567189',4),
											 ('MATH115','12566189',2.75),
											 ('MATH140','12584489',3),
											 ('ME116','12584489',3),
											 ('ME212','12584489',3.25),
											 ('ME216','12584489',3),
											 ('ME220','12584489',3.25),
											 ('ME301','12584489',4),
											 ('ME303','12584489',3.75),
											 ('ME305','12584489',4),
											 ('ME310','12584489',3),
											 ('ME311','12584489',3),
											 ('ME313','12584489',3),
											 ('ME316','12584489',3.25),
											 ('ME348','12584489',3),
											 ('ME401','12584489',3.25),
											 ('ME402','12584489',4),
											 ('ME431','12584489',3),
											 ('ME439','12584489',3),
											 ('ME474','12584489',3),
											 ('ME495','12584489',3),
											 ('ME499','12584489',2.75),
											 ('EE499','12584489',2.75),
											 ('MATH140','12573189',2.75),
											 ('MATH115','12573189',2.75),
											 ('ME301','12573189',2.75),
											 ('EE499','12573189',2.75),
											 ('EE499','12570189',3.75);

-- File: tracks.sql
DROP TABLE IF EXISTS Tracks; 

CREATE TABLE Tracks (
	major  VARCHAR(7),
	trackcode   VARCHAR(10),
	title  VARCHAR(30),
	PRIMARY KEY(major,trackcode) 
);


INSERT INTO Tracks (major,trackcode,title) VALUES ('CptS','SE','Software Engineering Track'),
												  ('CptS','SYS','Systems Track'),	
												  ('CptS','G','General Track'),	
												  ('EE','CE', 'Computer Engineering Track'),	
												  ('EE','ME', 'Microelectronics Track'),	
												  ('EE','POW','Power Track');

-- File: trackReq.sql
DROP TABLE IF EXISTS TrackRequirements; 

CREATE TABLE TrackRequirements (
	major  VARCHAR(7),
	trackcode   VARCHAR(10),
	courseNo  VARCHAR(7),
	PRIMARY KEY (major,trackcode,courseNo),
	FOREIGN KEY (major,trackcode) REFERENCES Tracks(major,trackcode),
	FOREIGN KEY (courseNo) REFERENCES Course(courseNo)
);


INSERT INTO TrackRequirements (major,trackcode,courseNo) VALUES 
												  ('CptS','SE','CptS121'),
												  ('CptS','SE','CptS122'),	
												  ('CptS','SE','CptS223'),	
												  ('CptS','SE','CptS260'),	
												  ('CptS','SE','CptS322'),	
												  ('CptS','SE','CptS355'),	
												  ('CptS','SE','CptS421'),	
												  ('CptS','SE','CptS423'),	
												  ('CptS','SE','CptS317'),	
												  ('CptS','SE','CptS360'),
												  ('CptS','SE','CptS323'),	
												  ('CptS','SE','CptS451'),
												  ('CptS','SE','CptS422'),
  												  ('CptS','SYS','CptS460'),	
												  ('CptS','SYS','CptS451'),
												  ('CptS','SYS','CptS464'),
												  ('CptS','SYS','CptS466'),
												  ('CptS','SYS','CptS121'),
												  ('CptS','SYS','CptS122'),	
												  ('CptS','SYS','CptS223'),	
												  ('CptS','SYS','CptS260'),	
												  ('CptS','SYS','CptS322'),	
												  ('CptS','SYS','CptS355'),	
												  ('CptS','SYS','CptS421'),	
												  ('CptS','SYS','CptS423'),	
												  ('CptS','SYS','CptS317'),	
												  ('CptS','SYS','CptS360'),
  												  ('CptS','G','CptS460'),	
												  ('CptS','G','CptS451'),
												  ('CptS','G','CptS422'),
												  ('CptS','G','CptS443'),
											      ('CptS','G','CptS121'),
												  ('CptS','G','CptS122'),	
												  ('CptS','G','CptS223'),	
												  ('CptS','G','CptS260'),	
												  ('CptS','G','CptS322'),	
												  ('CptS','G','CptS355'),	
												  ('CptS','G','CptS421'),	
												  ('CptS','G','CptS423'),	
												  ('CptS','G','CptS317'),	
												  ('CptS','G','CptS360'),
												  ('EE','ME','EE214'),
												  ('EE','ME','EE234'),
												  ('EE','ME','EE261'),
												  ('EE','ME','EE262'),
												  ('EE','ME','EE311'),												  
												  ('EE','ME','EE321'),
												  ('EE','ME','EE331'),
												  ('EE','ME','EE334'),												  
												  ('EE','ME','EE341'),
												  ('EE','ME','EE351'),  
												  ('EE','ME','EE415'),  												  
												  ('EE','ME','EE416'),  												  
												  ('EE','ME','EE431'),
												  ('EE','ME','EE451'),
												  ('EE','ME','EE483'),
												  ('EE','ME','EE476'),
												  ('EE','ME','EE499'),
												  ('EE','POW','EE214'),
												  ('EE','POW','EE234'),
												  ('EE','POW','EE261'),
												  ('EE','POW','EE262'),
												  ('EE','POW','EE311'),												  
												  ('EE','POW','EE321'),  
												  ('EE','POW','EE331'),
												  ('EE','POW','EE334'),												  
												  ('EE','POW','EE341'), 
												  ('EE','POW','EE351'), 
												  ('EE','POW','EE415'), 												  
												  ('EE','POW','EE416'), 												  
												  ('EE','POW','EE361'),
												  ('EE','POW','EE362'),
												  ('EE','POW','EE483'),
												  ('EE','POW','EE476'),
												  ('EE','POW','EE499');


-- File: prereq.sql
DROP TABLE IF EXISTS Prereq;

CREATE TABLE Prereq (
	courseNo  VARCHAR(7),
	preCourseNo  VARCHAR(7),
	PRIMARY KEY (courseNo, preCourseNo),	
	FOREIGN KEY (courseNo) REFERENCES Course(courseNo),
	FOREIGN KEY (preCourseNo) REFERENCES Course(courseNo)
);

INSERT INTO Prereq(courseNo,preCourseNo) VALUES('CptS122','CptS121'),
											   ('CptS223','CptS122'),
											   ('CptS322','CptS223'),
											   ('CptS323','CptS322'),
											   ('CptS355','CptS223'),
											   ('CptS355','MATH171'),
											   ('CptS421','CptS322'),
											   ('CptS421','CptS323'),
											   ('CptS423','CptS421'),
											   ('CptS423','CptS422'),
											   ('CptS360','CptS223'),
											   ('CptS460','CptS360'),
											   ('CptS451','CptS223'),
											   ('CptS422','CptS322'),
											   ('CptS422','CptS421'),
											   ('CptS317','CptS260'),
											   ('CptS317','CptS223'),
											   ('CptS443','CptS223'),
											   ('CptS464','CptS223'),
											   ('CptS471','CptS223'),
											   ('EE261','EE214'),
											   ('EE262','EE261'),
											   ('EE262','EE221'),
											   ('EE304','EE262'),
											   ('EE311','EE304'),
											   ('EE321','EE311'),
											   ('EE331','MATH251'),
											   ('EE331','EE321'),
											   ('EE334','EE331'),
											   ('EE341','EE331'),
											   ('EE351','EE331'),
											   ('EE351','EE311'),
											   ('EE361','EE311'),
											   ('EE361','EE351'),
											   ('EE362','EE361'),
											   ('EE415','EE311'),
											   ('EE415','EE362'),
											   ('EE416','EE331'),
											   ('EE416','EE415'),
											   ('EE431','EE362'),
											   ('EE451','EE362'),
											   ('EE483','EE311'),
											   ('EE476','EE311'),
											   ('EE499','EE311'),
											   ('MATH171','MATH101'),
											   ('MATH172','MATH103'),
											   ('MATH205','MATH105'),
											   ('MATH212','MATH105'),
											   ('MATH216','MATH108'),
											   ('MATH220','MATH108'),
											   ('MATH230','MATH108'),
											   ('MATH251','MATH108'),
											   ('MATH273','MATH108'),
											   ('MATH283','MATH108'),
											   ('MATH301','MATH251'),
											   ('CE211','MATH115'),
											   ('CE215','MATH140'),
											   ('CE317','CE211'),
											   ('CE322','CE211'),
											   ('CE330','CE211'),
											   ('CE341','CE211'),
											   ('CE351','CE211'),
											   ('CE401','CE351'),
											   ('CE403','CE351'),
											   ('CE405','CE351'),
											   ('CE414','CE351'),
											   ('CE416','CE330'),
											   ('CE417','CE330'),
											   ('ME216','ME116'),
											   ('ME220','MATH171'),
											   ('ME301','ME220'),
											   ('ME303','ME220'),
											   ('ME305','ME220'),
											   ('ME310','ME220'),
											   ('ME311','ME220'),
											   ('ME313','ME220'),
											   ('ME316','ME220'),
											   ('ME348','ME311'),
											   ('ME401','ME311'),
											   ('ME402','ME311'),
											   ('ME431','ME311'),
											   ('ME439','ME311'),
											   ('ME474','ME348'),
											   ('ME495','ME348'),
											   ('ME499','ME348'),
											   ('CHE321','MATH251'),
											   ('CHE334','MATH251'),
											   ('CHE398','CHE110'),
											   ('CHE398','CHE211'),
											   ('CHE433','CHE321'),
											   ('CHE451','CHE321'),
											   ('CHE476','CHE321'),
											   ('CHE495','CHE321'),
											   ('CHE498','CHE321');


