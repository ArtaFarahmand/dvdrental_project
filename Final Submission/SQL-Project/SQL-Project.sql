
-- Workspace + Question Set 1 --

-- 1) We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

-- Query that lists each movie, the film category it is classified in, and the number of times it has been rented out --

SELECT t1.film_title,
	t1.film_category,
	SUM(t1.rental_count) OVER (PARTITION BY rental_count) AS rental_count
FROM (SELECT
	  f.title AS film_title,
	  c.name AS film_category,
	  r.rental_id AS rental_count
	  FROM film f
	  INNER JOIN film_category fc
	  ON f.film_id = fc.film_id
	  INNER JOIN category c
	  ON fc.category_id = c.category_id
	  INNER JOIN rental r
	  ON f.film_id = r.rental_id
	 ) t1
WHERE t1.film_category = 'Animation' 
	OR t1.film_category = 'Classic' 
	OR t1.film_category = 'Comedy'
GROUP BY t1.film_title,
	t1.film_category,
	t1.rental_count
ORDER BY t1.film_category, t1.film_title ASC;

-- 2) Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into. -- 

-- Provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories --

SELECT f.title AS film_title,
	c.name AS category_name,
	f.rental_duration AS rental_duration,
	NTILE(4) OVER (ORDER BY f.rental_duration) AS quartiles
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON c.category_id = fc.category_id
WHERE c.name IN(
	'Animation',
	'Childern',
	'Comedy',
	'Family',
	'Music'
)
GROUP BY 1, 2, 3
ORDER BY 3 ASC;

-- 3) Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. --

-- Provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category --

SELECT category_name,
	quartiles,
	COUNT(t1.category_name) AS category_count
FROM (SELECT c.name AS category_name,
	  NTILE(4) OVER (ORDER BY f.rental_duration) AS quartiles
	  FROM film f
	  INNER JOIN film_category fc
	  ON f.film_id = fc.film_id
	  INNER JOIN category c
	  ON c.category_id = fc.category_id
	  WHERE c.name IN(
			'Animation',
			'Childern',
			'Comedy',
			'Family',
			'Music'
		)
) t1
GROUP BY 1, 2
ORDER BY 1, 2;

-- Workspace + Question Set 2 --

-- 1) We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month. --

-- -- Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month. --

SELECT DATE_PART('Year', rental_date) AS rental_years,
	DATE_PART('Month', rental_date) AS rental_months,
	store.store_id,
	COUNT(*) AS rental_count
FROM rental
INNER JOIN payment
ON payment.rental_id = rental.rental_id
INNER JOIN staff
ON staff.staff_id = payment.staff_id
INNER JOIN store
ON store.store_id = staff.store_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

