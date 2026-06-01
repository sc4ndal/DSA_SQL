desc country;
select * from country;

create database example;
#drop database example;
create table member(
			NUM int(10) not null auto_increment primary key,
			ID char(3) unique,
            PW char(30),
            NAME char(5),
            BIRTH char(10),
            MAIL char(30)
);
desc member;
drop table member;
use example;
show tables;
insert into member(id, pw, name, birth, mail) values ('abc', 'cba', '홍길동', '20260512', null);
insert into member(id, pw, name, birth, mail) values ('cba', 'abc', '강감찬', '20260511', null);
rollback;
select * from member;

select date_format(now(), '%Y-%m');
