-- 1. Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT Reviewer.name
FROM Rating
LEFT JOIN Reviewer ON Rating.rid = Reviewer.rid
LEFT JOIN Movie ON Rating.mid = Movie.mid
WHERE Movie.title = 'Gone with the Wind';

-- 2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
SELECT DISTINCT Reviewer.name, Movie.title, Rating.stars
FROM Rating
LEFT JOIN Reviewer ON Rating.rid = Reviewer.rid
LEFT JOIN Movie ON Rating.mid = Movie.mid
WHERE Reviewer.name = Movie.director;

-- 3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
SELECT Reviewer.name
FROM Reviewer
UNION
SELECT Movie.title
FROM Movie;

-- 4. Find the titles of all movies not reviewed by Chris Jackson. 
SELECT Movie.title
FROM Movie
WHERE Movie.mid NOT IN (SELECT Movie.mid
FROM Rating
LEFT JOIN Reviewer ON Rating.rid = Reviewer.rid
LEFT JOIN Movie ON Rating.mid = Movie.mid
WHERE Reviewer.name = 'Chris Jackson');

-- 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT RV1.name, RV2.name 
FROM Rating R1 
LEFT JOIN Rating R2 ON R1.mid = R2.mid 
LEFT JOIN Reviewer RV1 ON R1.rid = RV1.rid 
LEFT JOIN Reviewer RV2 ON R2.rid = RV2.rid 
WHERE R1.rid <> R2.rid and RV1.name < RV2.name 
ORDER BY RV1.name;

-- 6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
SELECT Reviewer.name, Movie.title, Rating.stars 
FROM Rating 
LEFT JOIN Reviewer ON Rating.rid = Reviewer.rid 
LEFT JOIN Movie ON Rating.mid = Movie.mid 
WHERE Rating.stars = (SELECT MIN(Rating.stars) 
                      FROM Rating);
                      
-- 7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
SELECT Movie.title, AVG(Rating.stars) 
FROM Movie 
INNER JOIN Rating ON Movie.mid = Rating.mid 
GROUP BY Movie.title 
ORDER BY AVG(Rating.stars) DESC, Movie.title;

-- 8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT DISTINCT RV1.name 
FROM Rating R1, Rating R2, Rating R3, Reviewer RV1 
WHERE RV1.rid = R1.rid AND 
      (R1.rid = R2.rid AND R1.rid = R3.rid) AND 
      ((R1.mid <> R2.mid AND R1.mid <> R3.mid AND R2.mid <> R3.mid) OR (R1.ratingdate <> R2.ratingdate AND R1.ratingdate <> R3.ratingdate AND R2.ratingdate <> R3.ratingdate));
      
-- 9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
SELECT M1.title, M1.director 
FROM Movie M1, Movie M2 
WHERE M1.director = M2.director AND M1.mid <> M2.mid ORDER BY M1.director, M1.title;

-- 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT Movie.title, AVG(Rating.stars) 
FROM Rating 
LEFT JOIN Movie ON Rating.mid = Movie.mid 
GROUP BY Movie.mid
HAVING AVG(Rating.stars) = (SELECT MAX(M.avg) 
                            FROM (SELECT Movie.mid, AVG(Rating.stars) as avg 
                                  FROM Rating 
                                  LEFT JOIN Movie ON Rating.mid = Movie.mid 
                                  GROUP BY Movie.mid) M);

-- 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
SELECT Movie.title, AVG(Rating.stars) 
FROM Rating 
LEFT JOIN Movie ON Rating.mid = Movie.mid 
GROUP BY Movie.mid
HAVING AVG(Rating.stars) = (SELECT MIN(M.avg) 
                            FROM (SELECT Movie.mid, AVG(Rating.stars) as avg 
                                  FROM Rating 
                                  LEFT JOIN Movie ON Rating.mid = Movie.mid 
                                  GROUP BY Movie.mid) M);
                        
-- 12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT Movie.director, Movie.title, Rating.stars 
FROM Movie LEFT JOIN Rating ON Movie.mid = Rating.mid 
WHERE Movie.director IS NOT NULL 
GROUP BY Movie.director HAVING MAX(Rating.stars);
