-- create <-> insert
insert into project_films.release(premiere_world, premiere_russia) values
            ('16 декабря 2002', '13 февраля 2003');
insert into project_films.film(film_name, release_id, director_id, rating) values
            ('Поймай меня, если сможешь', 12, 2, 8.5);
insert into project_films.genre_film_match(film_id, genre_id) values (12, 1), (12, 4), (12, 10);
insert into project_films.actor_film_match(film_id, actor_id) values (12, 2), (12, 17);
insert into project_films.watched_films(film_id, watching_date, my_rating, number_of_view) values
            (12, '15 июля 2022', 9, 1);
-- read <-> select
select avg(my_rating)
from project_films.watched_films;

select film_name, rating
from project_films.film
where rating >= 9;

--update
update project_films.watched_films
set my_rating = 8.5
where film_id = 12;

update project_films.watched_films
set watching_date = '15 августа 2022'
where film_id = 12;

--delete
delete from project_films.watched_films
where film_id = 12;