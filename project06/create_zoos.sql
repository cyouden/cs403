drop database if exists zoos;
create database zoos;
use zoos;

create table zoos
(
    id int not null auto_increment primary key,
    name varchar(128)
) engine=innodb;

create table locations
(
    id int not null auto_increment primary key,
    name varchar(255)
) engine=innodb;

create table habitats
(
    id int not null auto_increment primary key,
    name varchar(255),
    capacity int,
    description varchar(255),
    foreign key zoo_id int not null references zoos(id),
    foreign key location_id int not null references locations(id),
    check (capacity > 0 and capacity <= 50)
) engine=innodb;

create table animals
(
    id int not null auto_increment primary key,
    name varchar(255),
    description varchar(255),
    cuteness int,
    check (cuteness > 0 and cuteness <= 10)
) engine=innodb;

create table users
(
    id int not null auto_increment primary key,
    username varchar(16) not null,
    password varchar(16) not null,
    unique(username),
    check (length(username) >= 9),
    check (length(password) >= 9)
) engine=innodb;

create table feed
(
    id int not null auto_increment primary key,
    name varchar(255),
    delicious enum('yes', 'no')
) engine=innodb;

create table animals_users
(
    foreign key animals_id int not null references animals(id),
    foreign key users_id int not null references users(id)
) engine=innodb;

create table animals_feed
(
    foreign key animals_id int not null references animals(id),
    foreign key feed_id int not null references feed(id)
) engine=innodb;