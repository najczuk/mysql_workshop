drop table if exists user2;
drop table if exists category;
drop table if exists ticket;
drop table if exists user;
drop table if exists user_ticket;


create table user (
    user_id int auto_increment not null,
    username varchar(50) not null,
    password varchar(50) default 'adminadmin' not null,
    name varchar(50) not null,
    surname varchar(50) not null,
    email varchar(50) not null,
    birth_date date not null,
    primary key (user_id));


create table ticket (
    ticket_id int auto_increment not null,
    user_id int,
    topic varchar(100) not null,
    content text,
    
    primary key (ticket_id),
    foreign key (user_id) references user (user_id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
    index ticket_user_ind (ticket_id, user_id)
);

INSERT INTO user (username,password,name,surname,email,birth_date)
VALUES
('adrian',md5('adminadmin'),'Adrian','Najczuk','najczuk@gmail.com','1980-01-01'),
('jan',md5('adminadmin'),'Jan','Kowalski','jan@kowalski.com','1970-01-01'),
('andrzej',md5('adminadmin'),'Andrzej','Nowak','novak@gmail.com','1980-01-01');

INSERT INTO ticket(user_id,topic,content)
VALUES
(1,'Topic 1','Content 1'),
(1,'Topic 2','Content 2'),
(2,'Topic 3','Content 3'),
(null,'Topic 3','Content 3');
