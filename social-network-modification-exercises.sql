-- 1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM Highschooler 
WHERE Highschooler.grade = 12;

-- 2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes
WHERE Likes.id1 IN (SELECT likes.id1 
              FROM Friend JOIN Likes ON Friend.id1 = Likes.id1 
              WHERE Friend.id2 = Likes.id2) 
      AND NOT Likes.id2 IN (SELECT Likes.id1 
                      FROM Friend JOIN Likes ON Friend.id1 = Likes.id1
                      WHERE Friend.id2 = Likes.id2)

-- 3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
INSERT INTO Friend
SELECT F1.id1, F2.id2 
FROM Friend F1 
LEFT JOIN Friend F2 ON F1.id2 = F2.id1 
WHERE F1.id1 <> F2.id2 
EXCEPT 
SELECT * FROM Friend;
