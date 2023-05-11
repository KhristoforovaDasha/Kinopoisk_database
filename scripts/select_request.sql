-- вывести режиссёров, которые сняли больше одного фильма из тех, которые есть в таблице project_films.film
select director_name
from project_films.film film
join project_films.director director on film.director_id = director.director_id
group by director_name
having count(*) > 1;

-- отсортировать имена фильмов по алфавиту
select film_name, rating
from project_films.film
order by film_name;

-- узнать средний рейтинг фильмов для каждого жанра
select distinct genre_name, avg(rating) over (partition by genre_name) as avg_rating
from project_films.film film
full join project_films.genre_film_match match on film.film_id = match.film_id
full join project_films.genre genre on genre.genre_id = match.genre_id;

--отсортировать фильмы по рейтингу
select film_name, rank() over(order by rating)
from project_films.film;

--сравнение рейтинга фильма на кинопоиске с моими оценками, учитывая, что фильм может быть просмотрен
--несколько раз, внутри каждого фильма отсортировать мои оценки за этот фильм
select film_name, rank() over(partition by watched.film_id order by my_rating), my_rating, rating
from project_films.film film
join project_films.watched_films watched on film.film_id = watched.film_id;

--для кажого фильма вывести первого в алфавитном порядке актёра, сами названия фильмов также отсортировать
select distinct film_name, first_value(actor_name) over(partition by film.film_id order by actor_name)
from project_films.film film
full join project_films.actor_film_match match on film.film_id = match.film_id
full join project_films.actor actor on actor.actor_id = match.actor_id
order by film_name;
