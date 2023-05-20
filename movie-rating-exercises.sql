-- 1. Find the titles of all movies directed by Steven Spielberg. 
SELECT title
FROM movie 
WHERE director ='Steven Spielberg';

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
SELECT DISTINCT movie.year 
FROM movie 
INNER JOIN rating on Movie.mID = Rating.mID 
WHERE stars > 3 
ORDER BY movie.year ASC;

-- 3. Find the titles of all movies that have no ratings. 
SELECT title 
FROM movie 
LEFT JOIN rating on Movie.mID = Rating.mID 
WHERE Rating.rid IS NULL;

-- 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT Reviewer.name 
FROM Rating 
LEFT JOIN Reviewer on Rating.rid = Reviewer.rid 
WHERE ratingdate IS NULL;
