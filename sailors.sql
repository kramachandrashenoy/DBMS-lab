show tables;
create database Sailors;

use Sailors;
show tables;
 create table sailor(
 sid int primary key,
 sname varchar(50) not null,
 rating float(15) not null,
 age int not null);
 create table boat(
 bid int primary key,
 bname varchar(50) not null,
 color varchar(50) not null);
 create table reserves(
 sid int not null,
 bid int not null,
 rdate date);
 drop table reserves;
 create table reserves(
 sid int not null,
 bid int not null,
 rdate date not null,
 foreign key (sid) references sailor(sid) on delete cascade,
 foreign key(bid) references boat(bid) on delete cascade);
 insert into sailor value
 (100,'ram',9,45);
 select * from sailor;
insert into sailor values
(1,"Albert", 5.0, 40),
(2, "Nakul", 5.0, 49),
(3, "Darshan", 9, 18),
(4, "Astorm Gowda", 2, 68),
(5, "Armstormin", 7, 19);


insert into boat values
(1,"Boat_1", "Green"),
(2,"Boat_2", "Red"),
(103,"Boat_3", "Blue");

insert into reserves values
(1,103,"2023-01-01"),
(1,2,"2023-02-01"),
(2,1,"2023-02-05"),
(3,2,"2023-03-06"),
(5,103,"2023-03-06"),
(1,1,"2023-03-06");

select * from boat;
select * from sailor;
select * from reserves;

-- 1

select b.color 
from sailor s, boat b, reserves r
where s.sid=r.sid and b.bid=r.bid and s.sname like "%Albert%";

-- 2

(select sailor.sid from sailor where rating>=8) UNION (select sid from reserves where bid=103);


-- 3

select s.sname from sailor s where s.sid not in(select sailor.sid from reserves, sailor where sailor.sid=reserves.sid and sailor.sname like "%storm%")
and s.sname like "%storm%"
order by s.sname asc;

-- 4

select sailor.sname from sailor where not exists( select * from boat where not exists( select * from reserves where sailor.sid=reserves.sid and boat.bid=reserves.bid));

-- 5

select sailor.sname,sailor.age from sailor where age= (select max(age) from sailor); 

-- 6

select boat.bid, avg(sailor.age) from boat, sailor,reserves where sailor.age>=40 and reserves.sid=sailor.sid and boat.bid=reserves.bid and count(distinct sailor.sid)>=5
group by boat.bid;

-- count cannot be used with where it can be used only with having
select boat.bid, avg(sailor.age) from boat, sailor,reserves where sailor.age>=40 and reserves.sid=sailor.sid and boat.bid=reserves.bid
group by boat.bid
having count(distinct sailor.sid)>=5;

-- 7
drop view noname;
create view noname as
select boat.bname, color from sailor, boat,reserves where sailor.sid=reserves.sid and boat.bid=reserves.bid and sailor.rating=5;
select * from noname;

-- 8

delimiter //
create trigger t
before delete on boat
for each row 
begin 
if exists (select * from reserves where reserves.bid=old.bid) then signal sqlstate '45000' set message_text='error!!!';
end if;
end;//
delimiter ;

delete from boat where bid=103;
