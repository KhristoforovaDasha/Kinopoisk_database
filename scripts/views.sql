-- 1) данное представление показывает фильм и его рейтинг на кинопоиске
create view project_films.film_rating as
    select film_name, rating
    from project_films.film;

-- 2) данное представление скрывает film_id и другие id как технические поля
CREATE OR REPLACE VIEW project_films.connect_film_release_director AS
    SELECT film_name, premiere_world, premiere_russia, director_name, rating
    FROM project_films.film film
    JOIN project_films.release relese on relese.release_id = film.release_id
    JOIN project_films.director director on director.director_id = film.director_id;

-- 3) данное представление выводит мою среднюю оценку просмотренного фильма
create view project_films.my_rating as
    select film_name, avg(my_rating)
    from project_films.film film
        join project_films.watched_films watched on film.film_id = watched.film_id
    group by film_name;

-- 4) данное представление показывает дату релиза фильма в мире
create view project_films.world_release as
    select film_name, premiere_world
    from project_films.film film
    join project_films.release release on film.release_id = release.release_id;

-- 5) данное представление показывает какие жанры больше всего встречаются в фильмах
create view project_films.popular_genres as
    select genre_name, count(*) as film_count
    from project_films.film film
        join project_films.genre_film_match match on film.film_id = match.film_id
        join project_films.genre genre on match.genre_id = genre.genre_id
    group by genre_name
    order by film_count desc;

-- 6) данное представление считает в скольких фильмах снялся каждый актёр
create view project_films.popular_actors as
    select actor_name, count(*) as film_count
    from project_films.film film
        join project_films.actor_film_match match on film.film_id = match.film_id
        join project_films.actor actor on match.actor_id = actor.actor_id
    group by actor_name
    order by film_count desc;



