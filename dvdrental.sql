-- Using the SELECT statment to Query tables in the DataBase --

SELECT * FROM Film;
SELECT * FROM Actor;
SELECT * FROM Rental;

-- Query that contains actor's first and last name combined as full_name, film title, film description and length of the movie. --

SELECT 
	film_actor.actor_id,
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

-- Query that contains list of actors and movies where the movie length was more than 60 minutes

SELECT 
	film_actor.actor_id,
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