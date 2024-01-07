create database orderprocessing;
use orderprocessing;

create table customer(
cust_id int primary key,
cname varchar(30),
city varchar(15));
drop table order_;
create table order_(
order_id int primary key,
odate date not null,
cust_id int not null,
order_amt int not null,
foreign key (cust_id) references customer(cust_id) on delete cascade);

create table item(
item_no int primary key,
unitprice int not null);

create table orderitem(
order_id int not null,
item_no int not null,
qty int not null,
foreign key (order_id) references order_(order_id) on delete cascade,
foreign key(item_no) references item(item_no) on delete cascade);

create table warehouse(
warehouse_id int primary key,
city varchar(30));
create table shipment(
order_id int not null,
warehouse_id int not null,
ship_date date not null,
foreign key (order_id) references order_(order_id) on delete cascade,
foreign key(warehouse_id) references warehouse(warehouse_id) on delete cascade);

INSERT INTO customer VALUES
(0001, "Customer_1", "Mysuru"),
(0002, "Customer_2", "Bengaluru"),
(0003, "Kumar", "Mumbai"),
(0004, "Customer_4", "Dehli"),
(0005, "Customer_5", "Bengaluru");

INSERT INTO order_ VALUES
(001, "2020-01-14", 0001, 2000),
(002, "2021-04-13", 0002, 500),
(003, "2019-10-02", 0003, 2500),
(004, "2019-05-12", 0005, 1000),
(005, "2020-12-23", 0004, 1200);

INSERT INTO item VALUES
(0001, 400),
(0002, 200),
(0003, 1000),
(0004, 100),
(0005, 500);

INSERT INTO warehouse VALUES
(0001, "Mysuru"),
(0002, "Bengaluru"),
(0003, "Mumbai"),
(0004, "Dehli"),
(0005, "Chennai");

INSERT INTO orderitem VALUES 
(001, 0001, 5),
(002, 0005, 1),
(003, 0005, 5),
(004, 0003, 1),
(005, 0004, 12);

INSERT INTO shipment VALUES
(001, 0002, "2020-01-16"),
(002, 0001, "2021-04-14"),
(003, 0004, "2019-10-07"),
(004, 0003, "2019-05-16"),
(005, 0005, "2020-12-23");

-- 1

select order_id, ship_date from shipment where warehouse_id=0002;

-- 2

select shipment.warehouse_id, shipment.order_id from warehouse, shipment, customer, order_ where warehouse.warehouse_id=shipment.warehouse_id and shipment.order_id=order_.order_id and customer.cust_id=order_.cust_id and customer.cname like "%Kumar%";
-- or 
select order_id,warehouse_id from warehouse natural join shipment where order_id in (select order_id from order_ where cust_id in (Select cust_id from customer where cname like "%Kumar%"));

-- 3

select customer.cname, count(*) as total, avg(order_amt) as average from customer, order_ where order_.cust_id=customer.cust_id group by customer.cname;

-- 4

delete from order_ where cust_id in (select cust_id from customer where cname like "%Kumar%");

-- 5

select max(unitprice) from item;

-- 6

DELIMITER //
CREATE TRIGGER update_order
BEFORE INSERT ON orderitem
FOR EACH ROW 
BEGIN
UPDATE order_ SET order_amt=(NEW.qty * (SELECT unitprice FROM item WHERE item.item_no=NEW.item_no)) WHERE order_.order_id = NEW.order_id;
END;
//
DELIMITER ;

INSERT INTO order_ VALUES
(006, "2020-12-23", 0004, 1200);

INSERT INTO orderitem VALUES 
(006, 0001, 5); -- This will automatically update the Orders Table also

select * from order_;

-- 7

create view noname as 
select order_id, ship_date from shipment where warehouse_id=0005;

select * from noname;
