-- Using the SELECT statment to Query tables in the DataBase --

SELECT * FROM Film;
SELECT * FROM Actor;
SELECT * FROM Rental;

-- 1) Query that contains actor's first and last name combined as full_name, film title, film description and length of the movie. --

SELECT film_actor.actor_id,
	film_actor.film_id,
	CONCAT(actor.first_name,' ',actor.last_name) AS full_name,
	film.title,
	film.description
FROM Actor
RIGHT OUTER JOIN 
film
ON actor.actor_id = film.film_id
RIGHT OUTER JOIN 
film_actor
ON film_actor.actor_id = film_actor.film_id;

-- 2) Query that contains list of actors and movies where the movie length was more than 60 minutes

SELECT film_actor.actor_id,
	film_actor.film_id,
	CONCAT(actor.first_name,' ',actor.last_name) AS full_name,
	film.title,
	film.description,
	film.length
FROM Actor
RIGHT OUTER JOIN 
film
ON actor.actor_id = film.film_id
RIGHT OUTER JOIN 
film_actor
ON film_actor.actor_id = film_actor.film_id
WHERE film.length > 60;

-- 3) Query that captures the actor id, full name of the actor, and counts the number of movies each actor has made --

SELECT account_id,
	full_name,
	COUNT(film_title) AS film_Count
FROM (SELECT actors.actor_id AS account_id,
	actors.first_name,
	actors.last_name,
	actors.first_name || ' ' || actors.last_name AS full_name,
	movies.title AS film_title
	FROM film_actor films
	INNER JOIN actor actors
	ON films.film_id = actors.actor_id
	INNER JOIN  film movies
	ON movies.film_id = films.film_id) t1
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 1) Query that displays a table with 4 columns: actor's full name, film title, length of movie, and a column name "filmlen_groups" that classifies movies based on their length. Filmlen_groups should include 4 categories: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours --

SELECT full_name,
	film_title,
	film_length,
	CASE WHEN film_length <= 60 THEN '1 hour or less'
	WHEN film_length > 60 AND film_length <= 120 THEN 'Between 1 - 2 hours'
	WHEN film_length > 12 AND film_length <= 180 THEN 'Between 2 - 3 hours'
	ELSE 'More then 3 hours long ' END AS filmlen_groups 
FROM (SELECT a.first_name AS first_name,
	a.last_name As last_name,
	a.first_name || ' ' || a.last_name AS full_name,
	f.title AS film_title,
	f.length AS film_length
FROM film_actor fa
	  INNER JOIN actor a
	  ON fa.actor_id = a.actor_id
	  INNER JOIN film f
	  ON f.film_id = fa.film_id	
) T1;

-- 2) Query to count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours --

SELECT DISTINCT (filmlen_groups),
	COUNT(title) OVER (PARTITION BY filmlen_groups) AS filmcount_bylength
FROM (SELECT title, length,
	CASE WHEN length <= 60 THEN '1 hour or less'
	WHEN length > 60 AND length <= 120 THEN 'Between 1 - 2 hours'
	WHEN length > 12 AND length <= 180 THEN 'Between 2 - 3 hours'
	ELSE 'More then 3 hours long ' END AS filmlen_groups  
	  FROM film) t1
ORDER BY filmlen_groups;