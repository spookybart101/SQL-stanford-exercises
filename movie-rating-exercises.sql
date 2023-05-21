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

-- 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate 
FROM Rating 
LEFT JOIN Reviewer on Rating.rid = Reviewer.rid 
LEFT JOIN Movie ON Rating.mid = Movie.mid 
ORDER BY Reviewer.name, Movie.title, Rating.stars;

-- 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
SELECT Reviewer.name, Movie.title 
FROM Rating R1 
LEFT JOIN Rating R2 on R1.rid = R2.rid 
LEFT JOIN Reviewer ON R1.rid = Reviewer.rid 
LEFT JOIN Movie ON R1.mid = Movie.mid 
WHERE R1.mid = R2.mid and R1.ratingdate < R2.ratingdate and R1.stars < R2.stars;

-- 7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
SELECT Movie.title, MAX(Rating.stars) 
FROM Movie 
LEFT JOIN Rating ON Movie.mid = Rating.mid 
WHERE Rating.stars IS NOT NULL 
GROUP BY Movie.title;

-- 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
SELECT Title, Mx-Mn as Spread 
FROM (
	SELECT Movie.title as Title, MAX(Rating.stars) as Mx, MIN(Rating.stars) as Mn 
	FROM Movie 
	LEFT JOIN Rating ON Movie.mid = Rating.mid 
	WHERE Rating.stars IS NOT NULL GROUP BY Movie.title) M
ORDER BY Spread DESC, Title;

-- 9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
SELECT AVG(S1) - AVG(S2) 
FROM (
	SELECT AVG(STARS) S1 
	FROM Movie, Rating  
	WHERE Movie.MID = Rating.MID and year < 1980
	GROUP BY Movie.MID)
	, (
	SELECT AVG(STARS) S2 
	FROM Movie, Rating  
	WHERE Movie.MID=Rating.MID and year>1980
	GROUP BY Movie.MID);
