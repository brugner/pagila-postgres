-- Easier
-- 1: Retrieve the first and last name of all customers.
SELECT first_name, last_name FROM customer;

-- 2: Retrieve the title and rental rate of all movies in inventory.
SELECT film.title, film.rental_rate
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id;

-- 3: Retrieve the total number of rentals for each customer.
SELECT customer_id, COUNT(*) AS rentals
FROM rental
GROUP BY customer_id
ORDER BY rentals DESC;

-- 4: Retrieve the name and email address of all customers who rented a movie in the month of May 2022.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS name, customer.email
FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
WHERE rental.rental_date BETWEEN '05/01/2022' AND '05/31/2022';

-- 5: Retrieve the top 5 most rented movies.
SELECT film.title, COUNT(*) AS rentals
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY rentals DESC
LIMIT 5;

-- 6: Retrieve the name and email of all customers who have not rented a movie in the last 30 days.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS name, customer.email
FROM customer
LEFT JOIN rental ON rental.customer_id = customer.customer_id
WHERE rental.rental_date < CURRENT_DATE - 30;

-- 7: Retrieve the name, address, and total amount paid for each customer's rentals in the month of January 2006.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS name, address.address, SUM(payment.amount) AS amount
FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
WHERE rental.rental_date BETWEEN '05/01/2022' AND '05/31/2022'
GROUP BY name, address.address
ORDER BY amount DESC

-- 8: Retrieve the names of all customers who rented a movie starred by Nick Wahlberg.
SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_actor ON film_actor.film_id = film.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name = 'NICK' AND actor.last_name = 'WAHLBERG'

-- 9: Retrieve the name of all customers who have rented more than 10 movies.
SELECT rental.customer_id, customer.first_name, customer.last_name, COUNT(rental.customer_id) AS rentals
FROM rental
INNER JOIN customer ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id, customer.first_name, customer.last_name
HAVING COUNT(rental.customer_id) > 10
ORDER BY rentals DESC

-- 10: Retrieve the title and length of the longest movie in inventory.
SELECT title, length
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
ORDER BY length DESC
LIMIT 1;

-- Harder
-- 11: Retrieve the names of all customers who have rented every movie in the inventory.
SELECT customer.first_name, customer.last_name
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
GROUP BY customer.first_name, customer.last_name
HAVING COUNT(film.film_id) = (SELECT COUNT(*) FROM film);

-- 12: Retrieve the name and email address of the customer who has rented the most movies.
SELECT customer.first_name, customer.last_name, customer.email, COUNT(*) AS rentals
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
GROUP BY customer.first_name, customer.last_name, customer.email
ORDER BY rentals DESC
LIMIT 1;

-- 13: Retrieve the name and email of all customers who have rented at least one movie in each category.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY customer.first_name, customer.last_name, customer.email
HAVING COUNT(DISTINCT category.name) = (SELECT COUNT(*) FROM category);

-- 14: Retrieve the names and addresses of all customers who have not rented a movie in the last 60 days, but have rented more than 10 movies in the past year.
SELECT customer.first_name, customer.last_name, address.address
FROM customer
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN rental ON rental.customer_id = customer.customer_id
WHERE rental.rental_date < CURRENT_DATE - 60
GROUP BY customer.first_name, customer.last_name, address.address
HAVING COUNT(rental.rental_id) > 10;

-- 15: Retrieve the name, rental rate, and total revenue generated for each movie in inventory.
SELECT film.title, film.rental_rate, SUM(payment.amount) AS total_revenue
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY film.title, film.rental_rate
ORDER BY total_revenue DESC;

-- 16: Retrieve the name and email address of all customers who have rented a movie in each month of the year.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
GROUP BY customer.first_name, customer.last_name, customer.email
HAVING COUNT(DISTINCT DATE_PART('MONTH', rental.rental_date)) = 12; 

-- 17: Retrieve the name and email of all customers who have rented a movie with a rental duration longer than the average rental duration.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
GROUP BY customer.first_name, customer.last_name, customer.email
HAVING COUNT(DISTINCT film.rental_duration) > (SELECT AVG(film.rental_duration) FROM film);

-- 18: Retrieve the names and email of all customers who have rented the same movie more than once.
SELECT customer.first_name, customer.last_name, customer.email, film.title, COUNT(*) AS count
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
GROUP BY customer.first_name, customer.last_name, customer.email, film.title
HAVING COUNT(*) > 1
ORDER BY count DESC;

-- 19: Retrieve the name and email address of all customers who have rented a movie that has been rented by at least 100 other customers.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
GROUP BY customer.first_name, customer.last_name, customer.email
HAVING COUNT(DISTINCT rental.rental_id) > 100;

-- 20: Retrieve the names and email of all customers who have rented a movie in the category with the lowest average rental rate.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN (
	SELECT category.category_id, category.name, AVG(film.rental_rate) AS avg
	FROM film
	INNER JOIN film_category ON film_category.film_id = film.film_id
	INNER JOIN category ON category.category_id = film_category.category_id
	GROUP BY category.category_id, category.name
	ORDER BY avg ASC
	LIMIT 1
) AS c1 ON c1.category_id = film_category.category_id
GROUP BY customer.first_name, customer.last_name, customer.email;

-- All the exercises' rubrics were generated using ChatGPT.