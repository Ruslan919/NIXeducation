
/*

sudo -u postgres psql

\l

SELECT datname FROM pg_database;

\c testdb

\dt

*/

/*1. создать бд*/

CREATE DATABASE testdb;

/*2. создать таблицы*/

CREATE TABLE categories (
   category_id INT NOT NULL,
   category_title VARCHAR(255),
   category_description TEXT
);

CREATE TABLE products (
   product_id INT NOT NULL,
   product_title VARCHAR(255),
   product_description TEXT,
   in_stock INT,
   price FLOAT,
   slug VARCHAR(45),
   category_id INT
);

CREATE TABLE cart_product (
	cart_id INT ,
	product_id INT 
);

CREATE TABLE carts(
	cart_id INT NOT NULL,
	user_id INT,
	subtotal DECIMAL,
	total DECIMAL,
	timestamp TIMESTAMP(2)
);

CREATE TABLE users(
	user_id INT NOT NULL,
	email VARCHAR(255),
	password VARCHAR(255),
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	middle_name VARCHAR(255),
	is_staff SMALLINT,
	country VARCHAR(255),
	city VARCHAR(255),
	address TEXT
);

CREATE TABLE table_order(
	order_id INT not NULL,
	cart_id INT,
	order_status_id INT,
	shipping_total DECIMAL,
	total DECIMAL,
	created_at TIMESTAMP(2),
	updated_at TIMESTAMP(2)
);

create table order_status(
	order_status_id INT NOT NULL,
	status_name VARCHAR(255)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

/*3. добавить связи между таблицами*/

ALTER TABLE categories 
  ADD CONSTRAINT category_pk 
    PRIMARY KEY (category_id);

ALTER TABLE products 
	ADD CONSTRAINT category_product_fk 
    FOREIGN KEY (category_id)
	REFERENCES categories (category_id);

ALTER TABLE products  
	ADD CONSTRAINT product_pk 
	PRIMARY KEY (product_id); 

ALTER TABLE cart_product 
	ADD CONSTRAINT cart_products_product_id_fk
	FOREIGN KEY (product_id) 
	REFERENCES products(product_id); 

ALTER TABLE carts  
  ADD CONSTRAINT cart_id_pk 
    PRIMARY KEY (cart_id);

ALTER TABLE cart_product 
	ADD CONSTRAINT cart_product_cart_fk 
    FOREIGN KEY (cart_id)
	REFERENCES carts (cart_id);

ALTER TABLE users
ADD CONSTRAINT pk_users 
PRIMARY KEY (user_id); 

ALTER TABLE carts
ADD CONSTRAINT fk_user_cart
FOREIGN KEY (user_id) 
REFERENCES users(user_id ); 

ALTER TABLE table_order
ADD CONSTRAINT pk_order_id 
PRIMARY KEY (order_id); 

ALTER TABLE order_status
ADD CONSTRAINT pk_order_status_id
PRIMARY KEY (order_status_id); 

ALTER TABLE table_order
ADD CONSTRAINT fk_order_status_table_order
FOREIGN KEY (order_status_id) 
REFERENCES order_status(order_status_id ); 

ALTER TABLE table_order
ADD CONSTRAINT fk_carts_table_order
FOREIGN KEY (cart_id) 
REFERENCES carts(cart_id ); 

/*4. заполнить таблицу данными */

/*
select 'drop table "' || tablename || '" cascade;' 
from pg_tables where schemaname = 'public';

chmod o+rw 

postgres=# \copy users 
from '/home/rus/Desktop/nix/sql_input_files/users.csv' 
delimiter ',' 
csv header;
*/


\copy cart_product
from '/home/rus/Desktop/nix/sql_input_files/cart_products.csv' 
delimiter ',' 
csv;

select * from cart_product;


\copy  carts
from '/home/rus/Desktop/nix/sql_input_files/carts.csv' 
delimiter ',' 
csv;

select * from carts;

\copy categories 
from '/home/rus/Desktop/nix/sql_input_files/categories.csv' 
delimiter ',' 
csv;

select * from categories;

\copy order_status
from '/home/rus/Desktop/nix/sql_input_files/order_statuses.csv' 
delimiter ',' 
csv;

select * from order_status;

\copy products
from '/home/rus/Desktop/nix/sql_input_files/products.csv' 
delimiter ',' 
csv;

select * from products;

\copy table_order
from '/home/rus/Desktop/nix/sql_input_files/orders.csv' 
delimiter ',' 
csv;

select * from table_order;

\copy users 
from '/home/rus/Desktop/nix/sql_input_files/users.csv' 
delimiter ',' 
csv;

select * from users;


/*
1. добавьте в таблицу users колонку phone_number (int)
*/
ALTER TABLE users
  ADD phone_number int;

/*
2. поменяйте тип данных в таблице users колонка phone_number с int на varchar
*/

ALTER TABLE users
  ALTER COLUMN phone_number TYPE varchar(500);

SELECT 
   table_name, 
   column_name, 
   data_type 
FROM 
   information_schema.columns
WHERE 
   table_name = 'users';

 /*  
13. 	В созданной БД в задании 4:  в таблице products увеличьте цену в 2 раза
*/
  
select * from products; 
UPDATE products SET price = price * 2
select * from products; 


 /* 
14.	 Вывести: 1. всех юзеров,
*/
psql интерфейс, запустите \du команда

SELECT rolname FROM pg_roles;
 /* 
14.	 Вывести: 2. все продукты
*/

SELECT product_title FROM products ; 

 /* 
14.	 Вывести: 3. все статусы заказов
*/

SELECT status_name  FROM order_status ; 

/*
15.	 Вывести заказы, которые успешно доставлены и оплачены 	

переглянути таблиці

SELECT * FROM table_order ; 
SELECT * FROM order_status ; 

виділити ордери які підходять

SELECT order_id 
FROM table_order ;

виділити статуси які підходять

SELECT order_status_id 
FROM order_status 
WHERE status_name 
IN ('Paid', 'Finished');

об'єднати
*/

SELECT order_id 
FROM table_order 
WHERE order_status_id 
IN ( SELECT order_status_id 
	FROM order_status 
	WHERE status_name 
	IN ('Paid', 'Finished'));


/*
16. Вывести: (если задание можно решить несколькими способами, указывай все)
1. продукты, цена которых больше 80.00 и меньше или равно 150.00
*/

SELECT (product_title, price) FROM products
WHERE price > 80 AND price <= 150; 

SELECT product_title, price FROM products
WHERE price > 80 AND price <= 150; 

/*
16. Вывести: 2. заказы совершенные после 01.10.2020 (поле created_at)
*/

SELECT (order_id, created_at) FROM table_order 
WHERE created_at > '2020-10-01' ;

/*
16. Вывести: 3. заказы полученные за первое полугодие 2020 года
*/

SELECT order_id, updated_at FROM table_order 
WHERE updated_at
BETWEEN  CAST ('January 01, 2020' AS DATE) 
AND CAST ('July 31, 2020' AS DATE) 
ORDER BY updated_at;

SELECT order_id, updated_at FROM table_order 
WHERE updated_at BETWEEN  '2020-01-01' AND '2020-07-01' 
ORDER BY updated_at;


/*
16. Вывести: 4. подукты следующих категорий Category 7, Category 11, Category 18
*/
SELECT product_title FROM products

SELECT product_title FROM products WHERE category_id  
IN ( SELECT category_id FROM categories WHERE category_title 
IN ('Category 7', 'Category 11', 'Category 18') );

SELECT product_title FROM products WHERE category_id  
IN ( SELECT category_id FROM categories WHERE category_title LIKE '% 7' 
OR category_title LIKE '%11'
OR category_title LIKE '%18');

SELECT product_title FROM products WHERE category_id IN ( 
SELECT category_id FROM categories WHERE category_title LIKE ANY  (ARRAY  ['% 7', '%11', '%18']));

SELECT product_title
FROM products
INNER JOIN categories
ON products.category_id = categories.category_id
WHERE category_title IN ('Category 7', 'Category 11', 'Category 18');

SELECT product_title
FROM products
FULL OUTER JOIN  categories
ON products.category_id = categories.category_id
WHERE category_title IN ('Category 7', 'Category 11', 'Category 18');

SELECT product_title
FROM products
LEFT JOIN categories
ON products.category_id = categories.category_id
WHERE category_title IN ('Category 7', 'Category 11', 'Category 18');

SELECT product_title
FROM products
RIGHT JOIN categories
ON products.category_id = categories.category_id
WHERE category_title IN ('Category 7', 'Category 11', 'Category 18');
*
/*
16. Вывести: 5. незавершенные заказы по состоянию на 31.12.2020
*/
/*  LIKE == ~  */
/*
SELECT * /*order_id*/
FROM table_order WHERE updated_at >= '2020-12-25';

SELECT * /*order_status_id*/
FROM order_status 
WHERE status_name 
LIKE ANY (ARRAY ['Accepted', 'In progress', 'Paid']);

SELECT order_id 
FROM table_order ;
*/

SELECT order_id
FROM table_order, order_status
WHERE table_order.order_status_id = order_status.order_status_id
AND table_order.updated_at >= '2020-12-31'
AND status_name LIKE ANY (ARRAY ['Accepted', 'In progress', 'Paid']);


SELECT order_id
FROM table_order
WHERE order_status_id
IN (
	SELECT order_status_id
	FROM order_status 
	WHERE status_name 
	LIKE ANY (ARRAY ['Accepted', 'In progress', 'Paid']))
	AND  updated_at >= '2020-12-31';

SELECT order_id
FROM table_order
FULL OUTER JOIN order_status
ON table_order.order_id = order_status.order_status_id
WHERE status_name 
	LIKE ANY (ARRAY ['Accepted', 'In progress', 'Paid'])
	AND  updated_at >= '2020-12-31'; 

SELECT column_name(s)
FROM table1
FULL OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition; 


/*
16. Вывести: 6. вывести все корзины, которые были созданы, но заказ так и не был оформлен.
16. Display: 6. display all carts that have been created, but the order has not been completed.
*/

SELECT cart_id
FROM order_status a, table_order b
WHERE a.order_status_id = b.order_status_id
AND NOT a.status_name  =  'Finished';

SELECT cart_id
FROM order_status
FULL OUTER JOIN table_order
ON order_status.order_status_id = table_order.order_status_id
WHERE NOT status_name  =  'Finished';

SELECT cart_id
FROM order_status
RIGHT JOIN  table_order
ON order_status.order_status_id = table_order.order_status_id
WHERE NOT status_name  =  'Finished';

/*
17.	Вывести: 1. среднюю сумму всех завершенных сделок
*/
SELECT avg(total) AS "среднюю сумму всех завершенных сделок"
FROM table_order ;

/*
17.	Вывести: 2. вывести максимальную сумму сделки за 3 квартал 2020 	
*/

SELECT MAX(total)
FROM table_order 
WHERE created_at between '%2020-07-01%' and '%2020-09-30%' 

/*
make_date(year, quarter * 3 -2 , 1)::date

SELECT 
    TO_TIMESTAMP('2017     Aug','YYYY MON');
   
   SELECT timestamp '2016-01-01' + interval '3 month';
*/
/*
18.	1.Создайте новую таблицу potential_customers с полями id, email, name, surname, second_name, city
2. Заполните данными таблицу.
3. Выведите имена и электронную почту потеницальных и существующих пользователей из города city 17
*/
CREATE TABLE potential_customers(
    id SERIAL PRIMARY KEY NOT NULL UNIQUE ,
    name VARCHAR(255),
    email VARCHAR(255),
    surname VARCHAR(255),
    second_name VARCHAR(255),
    city VARCHAR(255)
);

INSERT INTO potential_customers (name, email, surname, second_name, city)
VALUES ('potential_customers1@email', 'p_c_name1', 'p_c_surname1', 'p_c_second_name11', 'city1');
INSERT INTO potential_customers (name, email, surname, second_name, city)
VALUES ('potential_customers2@email', 'p_c_name2', 'p_c_surname2', 'p_c_second_name12', 'city2');
INSERT INTO potential_customers (name, email, surname, second_name, city)
VALUES ('potential_customers16@email', 'p_c_name16', 'p_c_surname16', 'p_c_second_name16', 'city 16');
INSERT INTO potential_customers (name, email, surname, second_name, city)
VALUES ('potential_customers17@email', 'p_c_name17', 'p_c_surname17', 'p_c_second_name17', 'city 17');

SELECT * FROM potential_customers 

SELECT  first_name AS name, email  
FROM users
WHERE city = 'city 17'
UNION
SELECT  email, name 
FROM potential_customers
ORDER BY email;


/*
19.	Вывести имена и электронные адреса всех users отсортированных по городам и по имени (по алфавиту) 
*/

SELECT  first_name, email  
FROM users
ORDER BY first_name ASC, city;

/*
20.	Вывести наименование группы товаров, общее количество по группе товаров в порядке убывания количества 	
*/

SELECT categories.category_title, COUNT(products.product_id) AS Number_Of_products_In_category FROM products
LEFT JOIN categories ON products.category_id = categories.category_id 
GROUP BY category_title
ORDER BY COUNT(product_id) DESC;

/*
21. 1. Вывести продукты, которые ни разу не попадали в корзину.
*/

SELECT product_title
FROM products
WHERE NOT product_id = ANY (SELECT cart_product.cart_id FROM cart_product);

/*
21. 2. Вывести все продукты, которые так и не попали ни в 1 заказ. (но в корзину попасть могли).
*/

SELECT product_title
FROM  table_order p, products p2 
WHERE NOT  product_id  = cart_id AND product_id = order_id 

/*
21. 3. Вывести топ 10 продуктов, которые добавляли в корзины чаще всего.
*/

SELECT p.product_title
FROM products p 
WHERE p.product_id IN (
	SELECT cp.product_id --,count(cp.cart_id) 
	FROM cart_product cp  
	GROUP BY cp.product_id 
	ORDER BY COUNT(cp.cart_id) DESC
	LIMIT 10 );


SELECT p.product_title, count(cp.cart_id) 
FROM (products p
INNER JOIN cart_product cp ON p.product_id = cp.product_id)
GROUP BY p.product_title
ORDER BY COUNT(cp.cart_id) DESC
LIMIT 10 ;

/*
21.  4. Вывести топ 10 продуктов, которые не только добавляли в корзины, но и оформляли заказы чаще всего.
*/

SELECT p.product_title
FROM (products p
INNER JOIN cart_product cp ON p.product_id = cp.product_id
INNER JOIN carts c  ON cp.cart_id  = c.cart_id 
INNER JOIN table_order to2  ON c.cart_id  = to2.cart_id )
GROUP BY p.product_title
ORDER BY COUNT(cp.cart_id) DESC, COUNT(to2.order_id) DESC
LIMIT 10;

SELECT p.product_title, COUNT(cp.cart_id)  AS " добавляли в корзины чаще всего" , COUNT(to2.order_id) AS "оформляли заказы чаще всего"
FROM (products p
INNER JOIN cart_product cp ON p.product_id = cp.product_id
INNER JOIN table_order to2  ON cp.cart_id  = to2.cart_id )
GROUP BY p.product_title
ORDER BY COUNT(cp.cart_id) DESC, COUNT(to2.order_id) DESC
LIMIT 10;

/*
21.  5. Вывести топ 5 юзеров, которые потратили больше всего денег (total в заказе).
*/

SELECT u.first_name  AS "которые потратили больше всего денег " , SUM(c.total) AS " потратили всего денег"
FROM (users u 
INNER JOIN carts c  ON u.user_id  = c.user_id 
INNER JOIN table_order to2  ON c.cart_id  = to2.cart_id )
GROUP BY u.first_name
ORDER BY SUM(to2.total) DESC
LIMIT 5;

/*
21. 6. Вывести топ 5 юзеров, которые сделали больше всего заказов (кол-во заказов).
*/

SELECT u.first_name  AS "которые сделали больше всего заказов " , count(to2.order_id) AS " кол-во заказов"
FROM (users u 
INNER JOIN carts c  ON u.user_id  = c.user_id 
INNER JOIN table_order to2  ON c.cart_id  = to2.cart_id )
GROUP BY u.first_name
ORDER BY count(to2.order_id)  DESC
LIMIT 5;

/*
21. 7. Вывести топ 5 юзеров, которые создали корзины, но так и не сделали заказы. 
*/

SELECT u.first_name  AS "юзер, которые создал корзины, но так и не сделали заказы", count(to2.order_id )  
FROM (users u 
INNER JOIN carts c  ON u.user_id  = c.user_id 
INNER JOIN table_order to2  ON c.cart_id  = to2.cart_id )
GROUP BY c.cart_id , u.first_name, to2.order_id 
HAVING c.cart_id != to2.order_id 
ORDER BY count(to2.order_id )  DESC
LIMIT 5;

