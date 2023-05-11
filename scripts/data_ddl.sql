create schema if not exists project_films;

create table if not exists project_films.genre(
    genre_id serial primary key ,
    genre_name varchar(255) not null
);

create table if not exists project_films.release(
    release_id serial primary key ,
    premiere_world varchar(255) not null ,
    premiere_russia varchar(255) not null
);

create table if not exists project_films.director(
    director_id serial primary key ,
    director_name varchar(255) not null
);

create table if not exists project_films.actor(
    actor_id serial primary key ,
    actor_name varchar(255) not null
);

create table if not exists project_films.film (
    film_id serial primary key,
    film_name varchar(255) not null,
    release_id serial not null ,
    director_id serial not null ,
    rating double precision not null,
    foreign key (release_id) references project_films.release(release_id),
    foreign key (director_id) references project_films.director(director_id)
);

create table if not exists project_films.genre_film_match(
    film_id serial not null ,
    genre_id serial not null ,
    primary key (film_id, genre_id) ,
    foreign key (genre_id) references project_films.genre(genre_id),
    foreign key (film_id) references project_films.film(film_id)
);

create table if not exists project_films.actor_film_match(
    actor_id serial not null ,
    film_id serial not null ,
    primary key (film_id, actor_id),
    foreign key (actor_id) references project_films.actor(actor_id),
    foreign key (film_id) references project_films.film(film_id)
);

create table if not exists project_films.watched_films(
    film_id serial not null ,
    watching_date varchar(255) not null ,
    my_rating double precision not null ,
    number_of_view integer not null ,
    primary key (film_id, number_of_view),
    foreign key (film_id) references project_films.film(film_id)
);