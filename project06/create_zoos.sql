drop database if exists zoos;
create database zoos;
use zoos;

create table zoos
(
    id int not null auto_increment primary key,
    name varchar(128)
);

create table locations
(
    id int not null auto_increment primary key,
    name varchar(255)
);

create table habitats
(
    id int not null auto_increment primary key,
    name varchar(255),
    capacity int,
    description varchar(255),
    zoo_id int not null references zoos(id),
    location_id int not null references locations(id),
    check (capacity > 0 and capacity < 51)
);

create table animals
(
    id int not null auto_increment primary key,
    name varchar(255),
    description varchar(255),
    cuteness int,
    check (cuteness > 0 and cuteness < 11)
);

create table users
(
    id int not null auto_increment primary key,
    username varchar(16) not null,
    password varchar(16) not null,
    unique(username),
    check (length(username) >= 9),
    check (length(password) >= 9)
);

create table feed
(
    id int not null auto_increment primary key,
    name varchar(255),
    delicious enum('yes', 'no')
);

create table animals_users
(
    animals_id int not null references animals(id),
    users_id int not null references users(id)
);

create table animals_feed
(
    animals_id int not null references animals(id),
    feed_id int not null references feed(id)
);