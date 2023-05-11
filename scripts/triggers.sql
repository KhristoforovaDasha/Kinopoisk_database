--триггер, который при добавлении нового просмотренного фильма автоматически
-- подсчитывает количество просмотров этого фильма
CREATE OR REPLACE FUNCTION increment_number_of_view()
  RETURNS TRIGGER AS $$
BEGIN
  UPDATE project_films.watched_films
  SET number_of_view = (SELECT MAX(number_of_view)
      from project_films.watched_films
          where film_id = NEW.film_id) + 1
  WHERE film_id = NEW.film_id and watching_date = NEW.watching_date;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER watched_films_insert_trigger
  AFTER INSERT ON project_films.watched_films
  FOR EACH ROW
  EXECUTE FUNCTION increment_number_of_view();

INSERT INTO project_films.watched_films(film_id, watching_date, my_rating, number_of_view) VALUES (7, '19 марта 2023', 9, 0);

--триггер и представление для того, чтобы фильмы в таблицу можно было вставлять как (film_name, premiere_world, premiere_russia, director_name, rating)
CREATE OR REPLACE VIEW project_films.connect_film_release_director AS
    SELECT film_name, premiere_world, premiere_russia, director_name, rating
    FROM project_films.film film
    JOIN project_films.release relese on relese.release_id = film.release_id
    JOIN project_films.director director on director.director_id = film.director_id;

CREATE OR REPLACE FUNCTION insert_film()
RETURNS TRIGGER AS $$
DECLARE
    dir_id INTEGER;
BEGIN
    IF NOT EXISTS (SELECT * FROM project_films.release
                            WHERE premiere_russia = NEW.premiere_russia and premiere_world = NEW.premiere_world) THEN
    INSERT INTO project_films.release (premiere_world, premiere_russia)
    VALUES (NEW.premiere_world, NEW.premiere_russia);
    END IF;

    IF NOT EXISTS (SELECT * FROM project_films.director WHERE director_name = NEW.director_name) THEN
    INSERT INTO project_films.director (director_name)
    VALUES (NEW.director_name);
    END IF;

    SELECT director_id INTO STRICT dir_id
    FROM project_films.director
    WHERE director_name = NEW.director_name;

    INSERT INTO project_films.film (film_name, release_id, director_id, rating)
    VALUES (NEW.film_name, currval('project_films.release_release_id_seq'), dir_id, NEW.rating);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_film_trigger
INSTEAD OF INSERT ON project_films.connect_film_release_director
FOR EACH ROW
EXECUTE FUNCTION insert_film();

INSERT INTO project_films.connect_film_release_director  (film_name, premiere_world, premiere_russia, director_name, rating) VALUES ('Драйв', '10 сентября 1999', '10 сентября 1999', 'Николас Виндинг Рёфн', 7.3);