-- 1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade 
FROM Highschooler H1 
LEFT JOIN Likes L1 ON H1.id = L1.id1 
LEFT JOIN Highschooler H2 ON L1.id2 = H2.id 
LEFT JOIN Likes L2 ON L1.id2 = L2.id1 
LEFT JOIN Highschooler H3 ON L2.id2 = H3.id 
WHERE L1.id1 <> L2.id2;

-- 2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
SELECT Highschooler.name, Highschooler.grade
FROM Highschooler H1
WHERE Highschooler.grade NOT IN (
  SELECT H2.grade
  FROM Friend, Highschooler H2
  WHERE H1.ID = Friend.ID1 AND H2.ID = Friend.ID2
);

-- 3. What is the average number of friends per student? (Your result should be just one number.) 
SELECT AVG(M.Friends) 
FROM (SELECT COUNT(Friend.id1) AS Friends 
      FROM Friend 
      GROUP BY Friend.id1) M;

-- 4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
SELECT COUNT(*) 
FROM (SELECT H2.id 
      FROM Highschooler H1 
      LEFT JOIN Friend F1 ON H1.id = F1.id1 
      LEFT JOIN Highschooler H2 ON F1.id2 = H2.id 
      WHERE H1.name = 'Cassandra' 
      UNION 
      SELECT H3.id FROM Highschooler H1 
      LEFT JOIN Friend F1 ON H1.id = F1.id1 
      LEFT JOIN Highschooler H2 ON F1.id2 = H2.id 
      LEFT JOIN Friend F2 ON F1.id2 = F2.id1 
      LEFT JOIN Highschooler H3 On F2.id2 = H3.id 
      WHERE H1.name = 'Cassandra' AND H3.name <> 'Cassandra');

-- 5. Find the name and grade of the student(s) with the greatest number of friends.
SELECT Highschooler.name, Highschooler.grade 
FROM Highschooler 
WHERE Highschooler.id IN (
  SELECT Friend.id1 
  FROM Friend 
  GROUP BY Friend.id1 
  HAVING Count(Friend.id1) = (
    SELECT MAX(M.Friends) 
    FROM (SELECT COUNT(Friend.id1) AS Friends 
    FROM Friend 
    GROUP BY Friend.id1) M));
