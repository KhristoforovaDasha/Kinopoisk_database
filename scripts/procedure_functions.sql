--Функции
--сделаем функцию, которая принимает название жанра и возвращает все фильмы этого жанра

create or replace function project_films.get_films_certain_genre(genre_value varchar(255))
returns table(film varchar(255))  as $$
begin
   return query
   select films.film_name
   from project_films.film films
   join project_films.genre_film_match match on films.film_id = match.film_id
   join project_films.genre genre on genre.genre_id = match.genre_id
   where genre.genre_name = genre_value;
end
$$ language plpgsql;

select *
 from project_films.get_films_certain_genre('комедия');

-- напишем функцию, которая выводит названия фильмов, рейтинг которых лежит в определённом диапазоне
-- и дату просмотра этого фильма
create or replace function project_films.get_films_in_certain_range_rating(left_border integer, right_border integer)
returns table(film_name varchar(255), watching_date varchar(255))  as $$
begin
   return query
   select distinct films.film_name as film_name, watched.watching_date as watching_date
   from project_films.film films
   left join project_films.watched_films watched on watched.film_id = films.film_id
   where films.rating >= left_border and films.rating <= right_border and
         (watched.number_of_view = 1 or watched.number_of_view is null);
end
$$ language plpgsql;

select *
 from project_films.get_films_in_certain_range_rating(8, 9);
