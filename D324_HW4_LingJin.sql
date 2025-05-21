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
