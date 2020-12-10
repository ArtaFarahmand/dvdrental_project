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
FROM 
	(SELECT actors.actor_id AS account_id,
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
ORDER BY 3 DESC