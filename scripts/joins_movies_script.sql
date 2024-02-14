SELECT *
FROM specs;

SELECT *
FROM revenue;

SELECT *
FROM rating;

SELECT *
FROM distributors;

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT specs.film_title, specs.release_year, revenue.worldwide_gross
FROM specs
INNER JOIN revenue
USING (movie_id)
ORDER BY revenue.worldwide_gross
LIMIT 1;

-- Answer: Semi-Tough, release year 1977, 37187139

-- 2. What year has the highest average imdb rating?

SELECT specs.release_year, AVG(rating.imdb_rating)
FROM rating
INNER JOIN specs 
USING (movie_id)
GROUP BY specs.release_year
ORDER BY AVG(rating.imdb_rating) DESC;

-- Answer: 1991 has the highest average at 7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT specs.film_title, specs.mpaa_rating, distributors.company_name,revenue.worldwide_gross
FROM specs
INNER JOIN revenue 
USING (movie_id)
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
WHERE specs.mpaa_rating = 'G'
ORDER BY revenue.worldwide_gross DESC
LIMIT 1;

-- Answer: Toy Story 4 put out by Walt Disney

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT distributors.company_name, COUNT(specs.movie_id) AS film_count
FROM distributors
LEFT JOIN specs 
	ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.company_name;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT distributors.company_name, AVG(revenue.film_budget)
FROM distributors
INNER JOIN specs on distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN revenue USING (movie_id) 
GROUP BY distributors.company_name
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;

-- Answer: "Walt Disney "	148735526.31578947
-- "Sony Pictures"	139129032.25806452
-- "Lionsgate"	122600000.00000000
-- "DreamWorks"	121352941.17647059
-- "Warner Bros."	103430985.91549296

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- SELECT s.film_title, d.company_name, COUNT(s.*)
-- FROM specs AS s
-- INNER JOIN distributors AS d on s.domestic_distributor_id = d.distributor_id 
-- WHERE d.headquarters NOT ILIKE '%CA%'
-- GROUP BY s.film_title, d.company_name;

-- SELECT *
-- FROM specs AS s
-- INNER JOIN distributors AS d ON s.domestic_distributor_id = d.distributor_id 
-- INNER JOIN rating AS r ON s.movie_id=r.movie_id
-- WHERE d.headquarters NOT ILIKE '%CA%'
-- ORDER BY r.imdb_rating DESC;

SELECT
	film_title,
	company_name,
	distributor_id,
	headquarters,
	AVG(imdb_rating) AS avg_imdb_rating
FROM distributors
	INNER JOIN specs 
	ON distributors.distributor_id = specs.domestic_distributor_id
	INNER JOIN rating
	ON specs.movie_id = rating.movie_id
WHERE headquarters NOT LIKE '%CA%'
GROUP BY film_title, company_name, distributor_id, headquarters
ORDER BY avg_imdb_rating DESC;


-- Answer: 2- Dirty Dancing



-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT ROUND(avg(imdb_rating),2) AS avg_rating,
CASE
	WHEN length_in_min >= 120 THEN '>2 Hours'
	ELSE '<2 Hours'
END AS length_text
FROM specs AS s
INNER JOIN rating AS r
ON s.movie_id = r.movie_id
GROUP BY length_text
ORDER BY avg_rating DESC;


-- Answer: 7.25	">2 Hours"
-- 6.92	"<2 Hours"










