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
