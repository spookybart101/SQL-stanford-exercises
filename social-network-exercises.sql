-- 1. Find the names of all students who are friends with someone named Gabriel.
SELECT Highschooler.name 
FROM (SELECT friend.id2 
      FROM Highschooler 
      INNER JOIN Friend ON Highschooler.id = Friend.id1 
      WHERE Highschooler.NAME = 'Gabriel') M 
INNER JOIN Highschooler ON M.id2 = Highschooler.id;

-- 2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
SELECT M.name, M.grade, Highschooler.name, Highschooler.grade 
FROM (SELECT Highschooler.name, Highschooler.grade, Likes.id2 
      FROM Highschooler 
      INNER JOIN Likes ON Highschooler.id = Likes.id1) M 
INNER JOIN Highschooler ON M.id2 = Highschooler.id 
WHERE M.grade - Highschooler.grade > 1;

-- 3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
SELECT H1.name, H1.grade, H2.name, H2.grade 
FROM Highschooler H1, Highschooler H2, Likes L1, Likes L2 
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) ANd (H2.ID = L2.ID1 AND H1.ID = L2.ID2) AND H1.name < H2.name
ORDER BY H1.name, H2.name;

-- 4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
SELECT Highschooler.name, Highschooler.grade 
FROM Highschooler 
LEFT JOIN Likes ON Highschooler.id = Likes.id1 
WHERE Highschooler.id NOT IN (
	SELECT Likes.id1 
	FROM Likes 
	UNION 
	SELECT Likes.id2 
	FROM Likes)
ORDER BY Highschooler.grade, Highschooler.name;

-- 5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
SELECT H2.name, H2.grade, H1.name, H1.grade 
FROM Highschooler H1, Likes L1, Highschooler H2 
WHERE H1.id IN (Select Likes.id2 FROM Likes) AND H1.id NOT IN (SELECT Likes.id1 FROM Likes) AND H1.id = L1.id2 AND H2.id = L1.id1;

-- 6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT Highschooler.name, Highschooler.grade 
FROM Highschooler 
WHERE Highschooler.id NOT IN (SELECT H1.id FROM Highschooler H1 INNER JOIN Friend ON H1.id = Friend.id1 INNER JOIN Highschooler H2 ON H2.id = Friend.id2 WHERE H1.grade <> H2.grade) AND Highschooler.id IN (SELECT Friend.id1 FROM Friend)
ORDER BY Highschooler.grade, Highschooler.name;

-- 7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade 
FROM Highschooler H1 INNER JOIN Likes ON H1.id = Likes.id1 
INNER JOIN Highschooler H2 ON H2.id = Likes.id2 
INNER JOIN Friend F1 On H1.id = F1.id1 
INNER JOIN Highschooler H3 ON H3.id = F1.id2 
INNER JOIN Friend F2 ON H3.id = F2.id1 
WHERE H2.id NOT IN (SELECT Friend.id2 FROM Friend WHERE Friend.id1 = H1.id) AND F2.id2 = Likes.id2;

-- 8. Find the difference between the number of students in the school and the number of different first names. 
SELECT COUNT(*) - COUNT(DISTINCT Highschooler.name) as Difference 
FROM Highschooler;

-- 9. Find the name and grade of all students who are liked by more than one other student. 
SELECT Highschooler.name, Highschooler.grade 
FROM Highschooler WHERE Highschooler.id IN (
      SELECT H2.id 
      FROM Highschooler H1 
      INNER JOIN Likes ON H1.id = Likes.id1 
      INNER JOIN Highschooler H2 ON H2.id = Likes.id2 
      GROUP BY H2.id 
      HAVING COUNT(H2.id) > 1);
