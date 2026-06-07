
-- Netflix Content Analysis Using SQL --

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(10) PRIMARY KEY,
	type	VARCHAR(15),
	title	VARCHAR(110),
	director VARCHAR(210),
	casts	VARCHAR(1000),
	country		VARCHAR(130),
	date_added	DATE,
	release_year	INT,
	rating		VARCHAR(30),
	duration	VARCHAR(150),
	listed_in	VARCHAR(100),
	description		VARCHAR(250)
);




-- Data Exploration --

-- Count the number of rows --

SELECT 
	count(*) as Total_count
FROM netflix;


-- Sample Data --

SELECT * FROM netflix
LIMIT 10;


-- Different types of content --

SELECT DISTINCT type FROM netflix;


-- Null Values --

SELECT 
	COUNT(*) - COUNT(type) AS type_null, 
	COUNT(*) - COUNT(title) AS title_null,
	COUNT(*) - COUNT(director) AS director_null,
	COUNT(*) - COUNT(casts) AS casts_null,
	COUNT(*) - COUNT(country) AS country_null,
	COUNT(*) - COUNT(date_added) AS date_added_null,
	COUNT(*) - COUNT(release_year) AS release_year_null,
	COUNT(*) - COUNT(rating) AS rating_null,
	COUNT(*) - COUNT(duration) AS duration_null,
	COUNT(*) - COUNT(listed_in) AS listed_in_null,
	COUNT(*) - COUNT(description) AS description
FROM netflix;




-- Data Cleaning -- 

-- Replacing Null values of 'director' column with 'Not Given' --

UPDATE netflix
SET director = 'Not Given'
WHERE director IS NULL OR director = '';


-- Replacing Null values of 'casts' column with 'Not Given' --

UPDATE netflix
SET casts = 'Not Given'
WHERE casts IS NULL OR casts = '';


-- Replacing Null values of 'country' column with 'Not Given' --

UPDATE netflix
SET country = 'Not Given'
WHERE country IS NULL OR country = '';


-- Deleting Null values of 'rating' column --

DELETE FROM netflix 
WHERE rating IS NULL;


-- Deleting Null values of 'duration' column --

DELETE FROM netflix 
WHERE duration IS NULL;


-- Deleting Null values of 'date_added' column --

DELETE FROM netflix 
WHERE date_added IS NULL;




-- Business Problems & Solutions --

-- 1. Count the number of Movies vs TV Shows --

SELECT type, COUNT(*) AS count_by_type
FROM netflix
GROUP BY type;


-- 2. Find the most common rating for movies and TV shows --

SELECT type, rating
FROM 
(
	SELECT 
		type, rating, COUNT(*), 
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	FROM netflix
	GROUP BY 1,2
	) AS t1
WHERE ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020) --

SELECT * FROM netflix
WHERE type = 'Movie' AND release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix --

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS countries_with_most_content,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 5. Identify the longest movie --

SELECT * FROM netflix
WHERE type = 'Movie' AND
	DURATION = (SELECT MAX(duration) FROM netflix);


-- 6. Find content added in the last 5 years --

SELECT * FROM netflix
WHERE date_added >= CURRENT_DATE - INTERVAL '5 Years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'! --

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons --

SELECT * FROM netflix
WHERE type = 'TV Show' AND
SPLIT_PART(duration, ' ', 1) :: NUMERIC > 5;


-- 9. Count the number of content items in each genre --

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) As Genre,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;


--10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release! --

SELECT 
	EXTRACT(YEAR FROM(date_added)) AS Year, 
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::Numeric/(SELECT count(*) FROM netflix WHERE country = 'India')*100,2
	)AS avg_content_produced_in_percent
FROM netflix
WHERE country = 'India'
GROUP BY 1;


-- 11. List all movies that are documentaries --

SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';


-- 12. Find all content without a director --

SELECT * FROM netflix
WHERE director ILIKE '%Not Given%';


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years! --

SELECT * FROM netflix
WHERE release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10 AND
casts ILIKE '%Salman Khan%';


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India. --

SELECT
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	COUNT(*) as films_performed
FROM netflix
WHERE country ILIKE '%India%' AND
	casts != 'Not Given'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. --
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category. --

WITH new_table
AS (
SELECT *,
	CASE
	WHEN 
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
	END category
FROM netflix 
)
SELECT category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1;




SELECT * FROM netflix; 



