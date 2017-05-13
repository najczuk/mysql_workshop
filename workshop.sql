# warsztat 1
#1    Wyświetl wszystkie rekordy z tabeli film
select * from film;
#2    Wyświetl 10 tytułów filmów. Kolumnę title nazwij “Tytuł Filmu”
select title as "Tytuł fimu" from film;
#3    Wyświetl 100 pierwszych wartości kolumn title oraz rating
select title,rating from film limit 100;
#4    Wyświetl unikalne imiona wszystkich klientów
select distinct first_name from sakila.customer;
#5    Wyświetl unikalne imiona i naziwska wszystkich klientów
select distinct first_name,last_name from customer;
#6    Wyświetl 10 unikalnych długości filmów
select distinct length from film limit 10;
#
#warsztat 2
#
#1    Wyświetl jednego klienta, który został dodany najpóźniej do tabeli klientów
SELECT 
    *
FROM
    customer
ORDER BY create_date DESC, customer_id DESC
LIMIT 1;
#2    Wyświetl pierwszą alfabetycznie nazwę miasta z tabeli miast
SELECT city from sakila.city order by city ASC limit 1;
#3    Wyświetl tytuły filmów uporządkowane malejąco względem długości trwania filmu
SELECT title FROM film ORDER BY length DESC;
#4    Wyświetl unikalne długości filmów posortowane po długości rosnąco
select distinct length from film order by length asc;

# warsztat 3
#1    Wyświetl filmy, które trwają równo 168 minut
select * from film where length = 168;
#2    Wyświetl filmy, które mają długość różną niż 168 minut
select * from film where length != 168;
select * from film where length <> 168;
#3    Wyświetl unikalne daty płatności zrealizowanych po 2005-06-15
SELECT distinct
    date(payment_date)
FROM
    payment
WHERE
    DATE(payment_date) > 2006
ORDER BY payment_date;
#4    Wyświetl płatności dokonane przed lub w dniu 2005-08-23 oraz wartość wynosi 4.99
select * from payment where date(payment_date) <= '2005-08-23' AND amount = 4.99;
#5    Wyświetl adresy, których od pocztowy jest równy 17886 lub 83579 (z użyciem OR) 
select address from address where postal_code = 17886 or postal_code = 83579;
#6    Wyświetl adresy, których od pocztowy jest równy 17886 lub 83579 (z użyciem IN) 
select * from address where postal_code in (17886,83579);
#7    Wyświetl wypożyczenia zwrócone pomiędzy 2005-05-22 oraz 2006-01-01 przedział otwarty

#8    Wyświetl wypożyczenia zwrócone pomiędzy 2005-05-22 oraz 2006-01-01 przedział zamknięty

#9    Wyświetl wszystkie wypożyczenia, które nie zostały jeszcze zwrócone 

#10  Wyświetl filmy, które w opisie zawierają ciąg znaków ‘Database’

#11  Wyświetl filmy, które mają w opisie ciąg znaków ‘MySql’ lub te które mają koszt wymiany = 9.99


# warsztat 4

#2  Wyświetl tytuł filmu wraz z kategorią korzystając z tabel film, film_category, category.
SELECT 
    f.title, c.name
FROM
    film f
        JOIN
    film_category fc ON f.film_id = fc.film_id
        JOIN
    category c ON c.category_id = fc.category_id;
    
#3  Wyświetl tytuł filmu i oryginalny język filmu nawet wtedy kiedy ten NIE WYSTĘPUJE.
SELECT 
    title, l.name AS original_language
FROM
    film f
        left JOIN
    language l ON f.language_id = l.language_id;
    
#4  Wyświetl imię, nazwisko, wartość transakcji klientów którzy dokonali 10-ciu najdroższych transakcji (payment.amount). 

select distinct c.first_name, c.last_name,p.amount from customer c

join payment p on c.customer_id = p.customer_id
order by p.amount desc
limit 10;

#5  Wyświetl dane wypożyczeń (rental) oraz powiązanych z nimi płatności (payment), 
#   nawet jeżeli dane wypożyczenia NIE WYSTĘPUJĄ, posortuj rosnąco po rental_id .
SELECT * FROM rental r right JOIN payment p on p.rental_id = r.rental_id order by p.rental_id;


#
# warsztat GROUP BY
#

#1  Ilu jest aktywnych i nieaktywnych klientów?
SELECT 
    active, COUNT(*)
FROM
    customer
GROUP BY active;
#2  Podaj przychód (payment.amount) w poszczególnych miesiącach (payment_date) 2005 roku?
SELECT 
    SUM(amount), MONTH(payment_date),year(payment_date)
FROM
    payment
GROUP BY MONTH(payment_date),year(payment_date);
#3  Ile średnio trwają filmy (film.length), które zostały tak samo ocenione (film.rating)?
SELECT 
    rating, AVG(length), COUNT(length), sum(length), sum(length)/COUNT(length)
FROM
    film
GROUP BY rating;
#4  Pod jakimi kodami pocztowymi (address.postal_code) mieszka więcej niż jeden klient (customer)?
SELECT 
    COUNT(customer_id), postal_code
FROM
    address
        JOIN
    customer ON address.address_id = customer.address_id
GROUP BY postal_code
HAVING COUNT(customer_id) > 1;

SELECT 
    postal_code, COUNT(*)
FROM
    address
GROUP BY postal_code
HAVING COUNT(*) > 1;

#
# warsztat select z  selecta
#

# ostatni film klienta
select title, count(*) from (
select first_name,last_name,title,rental_date from  (
select c.customer_id,c.first_name,c.last_name,f.title,r.rental_date from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id
order by c.customer_id, r.rental_date DESC) rentals
join (SELECT 
    customer_id, MAX(rental_date) as last_rental_date
FROM
    rental
GROUP BY customer_id) last_rental ON rentals.customer_id = last_rental.customer_id 
AND rentals.rental_date = last_rental.last_rental_date) last_rental_with_customer_data
group by title
order by count(*) desc;


with last_rental as (
SELECT 
    customer_id, MAX(rental_date) as last_rental_date
FROM
    rental
GROUP BY customer_id)
, rentals as (
select c.customer_id,c.first_name,c.last_name,f.title,r.rental_date from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id
order by c.customer_id, r.rental_date DESC
)
select * from last_rental lr join rentals r on 
r.customer_id = lr.customer_id 
AND r.rental_date = lr.last_rental_date;

#
# CREATE
#

CREATE database sda3;
USE sda3;
#user_id, username, password, name, surname, email, birth_date (timestamp)

create table user (
user_id INT NOT NULL auto_increment,
username VARCHAR(50) not null,
password VARCHAR(50) not null default 'adminadmin',
name varchar(50) not null,
surname varchar(50) not null,
email varchar(100) not null,
birth_date TIMESTAMP NOT NULL,
primary key(user_id)
);

create table user_copy like user; #kopia samej struktury danych

use sakila;
create table film_bckp as (select * from film); # kopia tabeli wraz z danymi, tutaj możemy robić też SELECTA z JOINEM
select * from film_bckp;
use sda3;  

