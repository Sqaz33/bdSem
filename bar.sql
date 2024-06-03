--СКРИПТЫ В КОНЦЕ ФАЙЛА

DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

--<<<<<<<<<<<<работа с сотрудниками<<<<<<<<<<<<<<<<<
--таблица сотрудников
CREATE TABLE IF NOT EXISTS "Employees" (
	"ID" serial PRIMARY KEY,
	"full_name" varchar(100) NOT NULL,
	"job_titel_ID" integer NOT NULL,
	"overtime_hours" integer,
	"final_payment" integer NOT NULL,
	"payment_date" date NOT NULL
);

--таблица должностей
CREATE TABLE IF NOT EXISTS "Job_titles" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	"salary" integer NOT NULL,
	"duty" varchar(100) NOT NULL
);

--<<<<<<<<<<<<работа с клиентами<<<<<<<<<<<<<<<<<
--таблица клиентов
CREATE TABLE IF NOT EXISTS "Clients" (
	"ID" serial PRIMARY KEY, 
	"phone_number" varchar(20) UNIQUE NOT NULL,
	"full_name" text NOT NULL,
	"prgr_ID" integer UNIQUE
);

--таблицы аккаунтов программы лояльности
CREATE TABLE IF NOT EXISTS "Loyalty_program_accounts" (
	"ID" serial PRIMARY KEY,
	"money_spent" integer NOT NULL,
	"client_ID" integer NOT NULL UNIQUE,
	"lvl_ID" integer NOT NULL
);

--таблица уровней программы лояльности 
CREATE TABLE IF NOT EXISTS "Loyalty_program_levels" (
	"ID" serial UNIQUE PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	"discount" integer NOT NULL,
	"price" integer NULL
);

--<<<<<<<<<<<<работа с меню<<<<<<<<<<<<<<<<<<<<
--таблица меню
CREATE TABLE IF NOT EXISTS "Menu_items" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	"price" integer NOT NULL,
	"manafacture_ID" integer NOT NULL
);

--таблица связи заказа к меню
CREATE TABLE IF NOT EXISTS "Order_line" ( 
	"order_ID" integer NOT NULL, 
	"menu_item_ID" integer NOT NULL,
	PRIMARY KEY ("order_ID", "menu_item_ID")
);

--таблица связи элементов меню и элементов хранения
CREATE TABLE IF NOT EXISTS "Menu_item_composition_container" ( 
	"item_ID" integer NOT NULL, 
	"menu_item_ID" integer NOT NULL,
	"quantity" integer NOT NULL DEFAULT 1,
	PRIMARY KEY ("item_ID", "menu_item_ID")
);


--<<<<<<<<<<<<работа с заказами<<<<<<<<<<<<<<<<
--таблица заказов
CREATE TABLE IF NOT EXISTS "Orders" (
	"ID" serial PRIMARY KEY,
	"date" timestamp NOT NULL,
	"client_ID" integer,
	"employee_ID" integer,
	"status_ID" integer NOT NULL
);

--таблица статусов заказов
CREATE TABLE IF NOT EXISTS "Order_statuses" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL
);

--<<<<<<<<<<<<работа с затратами<<<<<<<<<<<<<<<
--таблица затрат
CREATE TABLE IF NOT EXISTS "Expenses" (
	"ID" serial PRIMARY KEY,
	"storage_item_ID" integer,
	"employee_id" integer,
	"date" date NOT NULL,
	"element_quantity" integer NOT NULL,
	"total" integer NOT NULL,
	"type_ID" integer NOT NULL
);

--таблица видов трат
CREATE TABLE IF NOT EXISTS "Types_of_expenditure" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL
);

--<<<<<<<<<<<<работа со складом<<<<<<<<<<<<<<<
--таблица элементов хранения
CREATE TABLE IF NOT EXISTS "Storage_items" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	"characteristics" text NOT NULL,
	--объем предмета
	"volume" real NOT NULL,
	"price" integer NOT NULL,
	"storage_condition_ID" integer NOT NULL,
	"shell_life_in_days" integer,
	"supplier" varchar(100),
	"item_type_ID" integer NOT NULL
);

--таблица информации о месте храения
CREATE TABLE IF NOT EXISTS "Warehouse_spaces" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	--вместительность в литрах
	"capacity" real NOT NULL,
	"storage_conditions_ID" integer NOT NULL,
	"such_places_in_warehouse" integer NOT NULL
);

--таблица скадского учета 
CREATE TABLE IF NOT EXISTS "Items_in_warehouse" (
	"ID" serial PRIMARY KEY,
	"item_id" integer NOT NULL,
	"warehouse_place_id" integer NOT NULL,
	"quantity_of_item" integer,
	"days_until_end_storage" integer
);

--таблица условий хранения
CREATE TABLE IF NOT EXISTS "Storage_conditions" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) 
);
	
--таблица типов предметов
CREATE TABLE IF NOT EXISTS "Item_types" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	"consamable" bool NOT NULL
);

--<<<<<<<<<<связи для сотрудников
--многие-к-одному 
ALTER TABLE "Employees" 
	ADD CONSTRAINT "Employees_fk1"
		FOREIGN KEY ("job_titel_ID")
		REFERENCES "Job_titles"("ID");

--<<<<<<<<<<связи для аккаунтов программы лояльности
ALTER TABLE "Loyalty_program_accounts" 
	--один-к-одному
	ADD CONSTRAINT "Loyalty_prgr_fk1" 
		FOREIGN KEY ("lvl_ID")
		REFERENCES "Loyalty_program_levels"("ID"),
	--многие-к-одному
	ADD CONSTRAINT "Loyalty_prgr_fk2" 
		FOREIGN KEY ("client_ID")
		REFERENCES "Clients"("ID")
		ON DELETE CASCADE;

--<<<<<<<<<связи для клиетнов
--один-к-одному
ALTER TABLE "Clients" 
	ADD CONSTRAINT "Clients_fk2" 
		FOREIGN KEY ("prgr_ID")
		REFERENCES "Loyalty_program_accounts"("ID")
		ON DELETE SET NULL;

--<<<<<<<<<связи для заказов
ALTER TABLE "Orders" 
	--многие-к-одному
	ADD CONSTRAINT "Order_fk1"
		FOREIGN KEY ("status_ID")
		REFERENCES "Order_statuses"("ID"),
	--многие-к-одному
	ADD CONSTRAINT "Order_fk2"
		FOREIGN KEY ("client_ID")
		REFERENCES "Clients"("ID")
		ON DELETE SET NULL,
	--многие-к-одному
	ADD CONSTRAINT "Order_fk3"
		FOREIGN KEY ("employee_ID")
		REFERENCES "Employees"("ID")
		ON DELETE SET NULL;

ALTER TABLE "Order_line"
	--многие-ко-многим
	ADD CONSTRAINT "Order_fk1"
		FOREIGN KEY ("order_ID")
		REFERENCES "Orders"("ID"),
	--многие-ко-многим
	ADD CONSTRAINT "Order_fk2"
		FOREIGN KEY ("menu_item_ID")
		REFERENCES "Menu_items"("ID");

ALTER TABLE "Menu_item_composition_container"
	--многие-ко-многим
	ADD CONSTRAINT "Menu_item_composition_container_fk1"
		FOREIGN KEY ("item_ID")
		REFERENCES "Storage_items"("ID"),
	--многие-ко-многим
	ADD CONSTRAINT "Menu_item_composition_container_fk2"
		FOREIGN KEY ("menu_item_ID")
		REFERENCES "Menu_items"("ID");


--<<<<<<<<<связи для затрат
ALTER TABLE "Expenses"
	--многие-к-одному
	ADD CONSTRAINT "Expenses_fk1"
		FOREIGN KEY ("type_ID")
		REFERENCES "Types_of_expenditure"("ID"),
	--многие-к-одному
	ADD CONSTRAINT "Expenses_fk2"
		FOREIGN KEY ("employee_id")
		REFERENCES "Employees"("ID"),
	--многие-к-одному
	ADD CONSTRAINT "Expenses_fk3"
		FOREIGN KEY ("storage_item_ID")
		REFERENCES "Storage_items"("ID");

--<<<<<<<<<связи для склада
ALTER TABLE "Storage_items"
	--многие-к-одному 
	ADD CONSTRAINT "Storage_items_fk1"
		FOREIGN KEY ("item_type_ID")
		REFERENCES "Item_types"("ID"),
	--многие-к-одному 
	ADD CONSTRAINT "Storage_items_fk2"
		FOREIGN KEY ("storage_condition_ID")
		REFERENCES "Storage_conditions"("ID");

ALTER TABLE "Warehouse_spaces"
	--многие-к-одному
	ADD CONSTRAINT "Warehouse_spaces_fk1"
		FOREIGN KEY ("storage_conditions_ID")
		REFERENCES "Storage_conditions"("ID");

ALTER TABLE "Items_in_warehouse"
	--многие-к-одному 
	ADD CONSTRAINT "Items_in_warehouse_fk1"
		FOREIGN KEY ("item_id")
		REFERENCES "Storage_items"("ID"),
	ADD CONSTRAINT "Items_in_warehouse_fk2"
		FOREIGN KEY ("warehouse_place_id")
		REFERENCES "Warehouse_spaces"("ID");


INSERT INTO "Clients" ("phone_number", "full_name")
	VALUES 
	('+79999999991', 'Анна Аннова'),
	('+79999999992', 'Ivan Ivanov Ivanovich_2'),
	('+79999999993', 'Ivan Ivanov Ivanovich_3'),
	('+79999999994', 'Ivan Ivanov Ivanovich_4'),
	('+79999999995', 'Дмитрий Дмитриев'),
	('+79999999996', 'Ivan Ivanov Ivanovich_6'),
	('+79999999997', 'Ivan Ivanov Ivanovich_7'),
	('+79999999998', 'Ivan Ivanov Ivanovich_8'),
	('+79999999999', 'Ivan Ivanov Ivanovich_9'),
	('+79999999990', 'Ivan Ivanov Ivanovich_10');
	

INSERT INTO "Loyalty_program_levels" ("name", "discount", "price")
	VALUES 
	    ('Start', 1, 1000),
	    ('Bronze', 2, 2000),
	    ('Silver', 3, 3000),
	    ('Gold', 4, 4000),
	    ('Platinum', 5, 5000),
	    ('Diamond', 6, 6000);

INSERT INTO "Loyalty_program_accounts" ("money_spent", "client_ID", "lvl_ID")
	VALUES 
	    (1000, 1, 1),
	    (2000, 2, 2),
	    (3000, 3, 3),
	    (4000, 4, 4),
	    (5000, 5, 5),
	    (6000, 6, 6),
	    (1500, 7, 1),
	    (2500, 8, 2),
	    (3500, 9, 3),
	    (4500, 10, 4);


--связать все аккаунты программы лояльности и клиентов
DO $$
DECLARE
	cl RECORD;
	loy RECORD;
BEGIN
	FOR cl IN (SELECT * FROM "Clients") LOOP
		FOR loy IN (SELECT * FROM "Loyalty_program_accounts" WHERE "client_ID" = cl."ID") LOOP
			UPDATE "Clients"
			SET "prgr_ID" = loy."ID"
			WHERE "ID" = cl."ID";
		END LOOP;
	END LOOP;
END $$;	


INSERT INTO "Job_titles" ("name", "salary", "duty")
	VALUES 
	    ('Бармен', 30000, 'Готовить и подавать напитки клиентам'),
	    ('Менеджер бара', 50000, 'Управлять ежедневной работой бара'),
	    ('Официант', 25000, 'Принимать заказы и подавать еду и напитки'),
	    ('Шеф-повар', 45000, 'Готовить блюда и управлять кухонным персоналом'),
	    ('Хостес', 28000, 'Встречать и размещать клиентов'),
	    ('Помощник бармена', 22000, 'Помогать барменам с пополнением запасов и уборкой'),
	    ('Сомелье', 40000, 'Консультировать клиентов по выбору вин'),
	    ('Миксолог', 35000, 'Создавать и подавать специальные коктейли'),
	    ('Посудомойщик', 20000, 'Мыть посуду и кухонное оборудование'),
	    ('Охранник', 32000, 'Обеспечивать безопасность клиентов и персонала');


INSERT INTO "Employees" ("full_name", "job_titel_ID", "overtime_hours", "final_payment", "payment_date")
	VALUES 
	    ('Иван Иванов', 1, 10, 31000, '2024-02-01'),
	    ('Петр Петров', 2, 5, 50500, '2024-02-01'),
	    ('Алексей Алексеев', 3, 8, 27000, '2024-02-01'),
	    ('Сергей Сергеев', 4, 12,  49500, '2024-02-01'),
	    ('Мария Мариева', 5, 6, 29000, '2024-02-01'),
	    ('Анна Аннова', 6, 4,  23000, '2024-02-01'),
	    ('Дмитрий Дмитриев', 7, 15,  46000, '2024-02-01'),
	    ('Елена Еленова', 8, 7,  34000, '2024-02-01'),
	    ('Ольга Ольгина', 9, 9, 21500, '2024-02-01'),
	    ('Николай Николаев', 10, 3,  35200, '2024-02-01');

INSERT INTO "Item_types" ("name", "consamable")
	VALUES 
	    ('Напитки', TRUE),
	    ('Еда', TRUE),
	    ('Тара', FALSE),
	    ('Алкогольные напитки', TRUE),
	    ('Безалкогольные напитки', TRUE),
	    ('Закуски', TRUE),
	    ('Коктейли', TRUE),
	    ('Соки', TRUE),
	    ('Пиво', TRUE),
	    ('Вино', TRUE);

INSERT INTO "Storage_conditions" ("name")
	VALUES 
	    ('Сухое место'),
	    ('Холодильник'),
	    ('Морозильная камера'),
	    ('Контейнеры для сыпучих продуктов'),
	    ('Темное место'),
	    ('Открытый склад'),
	    ('Кладовая'),
	    ('Полка с регулируемой температурой'),
	    ('Влажная среда'),
	    ('Подвесная система хранения');

INSERT INTO "Storage_items" ("name", "characteristics", "volume", "price", "storage_condition_ID", "shell_life_in_days", "supplier", "item_type_ID")
	VALUES 
	    ('Водка "Абсолют"', 'Прозрачный алкогольный напиток', 0.7, 800, 2, NULL, 'Компания А', 4),
	    ('Пиво "Жигулевское"', 'Светлый лагер', 0.5, 50, 6, 30, 'Компания Б', 4),
	    ('Коньяк "Hennessy VS"', 'Выдержанный спиртной напиток', 0.75, 1500, 3, NULL, 'Компания В', 4),
	    ('Шампанское "Moët & Chandon"', 'Игристое вино', 0.75, 2500, 2, NULL, 'Компания Г', 5),
	    ('Виски "Johnnie Walker Black Label"', 'Выдержанный зерновой спирт', 0.7, 2000, 2, NULL, 'Компания Д', 4),
	    ('Консервы "Сельдь в томатном соусе"', 'Консервированная рыба', 0.3, 100, 1, 365, 'Компания Е', 2),
	    ('Сыр "Пармезан"', 'Твердый сыр, сырная корка', 0.25, 300, 5, 180, 'Компания Ж', 2),
	    ('Пивной кег "Heineken"', 'Емкость для пива', 50, 5000, 7, 14, 'Компания З', 3),
	    ('Лимонад "Fanta"', 'Газированный напиток, апельсиновый вкус', 1.5, 80, 8, NULL, 'Компания И', 4),
	    ('Конфеты "Ferrero Rocher"', 'Шоколадные конфеты с орехами', 0.2, 200, 5, 90, 'Компания К', 2);

INSERT INTO "Warehouse_spaces" ("name", "capacity", "storage_conditions_ID", "such_places_in_warehouse")
	VALUES 
	    ('Склад 1', 1000, 1, 10),
	    ('Склад 2', 1500, 2, 8),
	    ('Склад 3', 2000, 3, 12),
	    ('Холодильник 1', 500, 4, 5),
	    ('Холодильник 2', 750, 4, 7),
	    ('Сухое хранилище 1', 3000, 5, 20),
	    ('Сухое хранилище 2', 2500, 5, 18),
	    ('Открытый склад 1', 2000, 6, 15), 
	    ('Открытый склад 2', 3000, 6, 25),
	    ('Хранилище для крупногабаритных товаров', 5000, 7, 3);

INSERT INTO "Items_in_warehouse" ("item_id", "warehouse_place_id", "quantity_of_item", "days_until_end_storage")
	VALUES 
	    (1, 1, 100, 30),
	    (2, 2, 50, 20),
	    (3, 3, 200, 15),
	    (4, 4, 80, 25),
	    (5, 5, 120, 10),
	    (6, 6, 150, 5),
	    (7, 7, 70, 12),
	    (8, 8, 90, 18),
	    (9, 9, 110, 22),
	    (10, 10, 40, 8);


INSERT INTO "Menu_items" ("name", "price", "manafacture_ID")
	VALUES 
	    ('Стейк "New York Strip"', 2500, 1),
	    ('Салат "Цезарь"', 500, 2),
	    ('Паста "Карбонара"', 700, 3),
	    ('Ролл "Филадельфия"', 800, 4),
	    ('Бургер "Чизбургер"', 600, 5),
	    ('Пицца "Маргарита"', 650, 6),
	    ('Суп "Том Ям"', 400, 7),
	    ('Суши "Унаги"', 900, 8),
	    ('Омлет "Французский"', 300, 9),
	    ('Десерт "Тирамису"', 450, 10);


INSERT INTO "Menu_item_composition_container" ("item_ID", "menu_item_ID")
	VALUES 
	    (1, 1),
	    (2, 2),
	    (3, 3),
	    (4, 4),
	    (5, 5),
	    (6, 6),
	    (7, 7),
	    (8, 8),
	    (9, 9),
	    (10, 10);

INSERT INTO "Order_statuses" ("name")
	VALUES 
		('Новый'),
		('В обработке'),
		('Готовится'),
		('Ожидает выдачи'),
		('Выдан'),
		('Отменен'),
		('Доставляется'),
		('Доставлен'),
		('Оплачен'),
		('Неоплачен');


INSERT INTO "Orders" ("date", "client_ID", "employee_ID", "status_ID")
	VALUES 
		('2024-05-01 10:00:00', 1, 1, 1),
		('2024-05-02 10:00:00', 1, 1, 1),
		('2024-05-02 11:30:00', 2, 2, 2),
		('2024-05-03 12:45:00', 3, 3, 3),
		('2024-05-04 14:15:00', 4, 4, 4),
		('2024-05-05 16:20:00', 5, 5, 5),
		('2024-05-06 09:00:00', 6, 6, 6),
		('2024-05-07 17:30:00', 7, 7, 7),
		('2024-05-08 13:00:00', 8, 8, 8),
		('2024-05-09 15:45:00', 9, 9, 9),
		('2024-05-10 18:00:00', 10, 10, 10);

INSERT INTO "Order_line" ("order_ID", "menu_item_ID")
	VALUES 
		(1, 1),
		(1, 2),
		(2, 3),
		(2, 4),
		(3, 5),
		(3, 6),
		(4, 7),
		(4, 8),
		(5, 9),
		(5, 10),
		(1, 3),
		(1, 4);

INSERT INTO "Types_of_expenditure" ("name")
	VALUES 
		('Расходный материал'),
		('Зарплат'),
		('Реклам'),
		('Транспор'),
		('Аренд'),
		('sadfasvas'),
		('sadfasdfasdfasdfasdff'),
		('Проче');

INSERT INTO "Expenses" ("storage_item_ID", "employee_id", "date", "element_quantity", "total", "type_ID")
	VALUES 
		(NULL, 1, '2024-05-01', 1, 1000, 2),
		(NULL, 1, '2024-05-10', 1, 1000, 2),
		(NULL, 2, '2024-05-02', 1, 1000, 2),
		(NULL, 3, '2024-05-03', 500000000, 1000, 1),
		(NULL, 4, '2024-05-04', 1, 1000, 1),
		(NULL, 5, '2024-05-05', 1, 1000, 1),
		(NULL, 6, '2024-05-06', -7, 1000, 1),
		(NULL, 7, '2024-05-07', -2, 1000, 1),
		(NULL, 8, '2024-05-08', 3, -2000, 1),
		(NULL, 9, '2024-05-09', 6, -2000, 1),
		(NULL, 10, '2024-05-10', 5, -1000, 1);

--Запросы для функциональных требований

--Вести учет программы лояльности
--1. увеличивать количество потраченных денег в программе лояльности
WITH spent AS (
	SELECT 
	    SUM(mi."price") total_spent,
		cl."ID" client_ID
	FROM 
	    "Orders" o
	JOIN 
	    "Order_line" ol ON o."ID" = ol."order_ID"
	JOIN 
	    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
	JOIN 
		"Clients" cl ON cl."ID" = o."client_ID"
	GROUP BY 
	    cl."ID"
)
UPDATE
	"Loyalty_program_accounts"
SET 
	"money_spent" = spent.total_spent
FROM
	spent
WHERE 
	"client_ID" = spent.client_ID;

select * from "Loyalty_program_accounts";

--2. увеличить уровень программы лойльности 
WITH next_lvl AS (
	SELECT 
		lpa."ID" cl_ID,
		lvl."price" price_for
	FROM 
		"Loyalty_program_accounts" lpa
	JOIN 
		"Loyalty_program_levels" lvl
		ON lpa."lvl_ID" + 1 = lvl."ID"
)
UPDATE
	"Loyalty_program_accounts"
SET 
	"lvl_ID" = "lvl_ID" + 1
FROM 
	next_lvl
WHERE 
	"client_ID" = next_lvl.cl_ID AND "money_spent" >= next_lvl.price_for;

select * from "Loyalty_program_accounts";

--Получить выписку складского учета
SELECT
	si."name" as item_name, SUM(iw."quantity_of_item") as quanity
FROM 
	"Items_in_warehouse" iw
JOIN
	"Storage_items" si ON si."ID" = iw."item_id"
GROUP BY
	si."name";
	
--Показать заказы в работе
SELECT
	"ID" order_ID
FROM
	"Orders" "or"
WHERE 
	"status_ID" IN (
	SELECT os."ID"
	FROM "Order_statuses" os
	WHERE os."name" IN 
	('Готовится', 'В обработке', 'Готовится', 'Неоплачен')
	);

--Узнать самый покупаемый пункт меню
WITH mic as (	
	SELECT
		ol."menu_item_ID" mi_ID,
		COUNT(*) mi_count
	FROM 
		"Order_line" ol
	GROUP BY
		ol."menu_item_ID"
),
max_mic as (
	SELECT
		MAX(mic.mi_count) mx
	FROM
		mic
)
SELECT
	mi."name", mic.mi_count quantity
FROM
	mic
JOIN 
	"Menu_items" mi ON mi."ID" = mic.mi_ID
JOIN 
	max_mic ON max_mic.mx = mic.mi_count;

--Узнать доходы, расходы, прибыль за определенный период (допустим месяц).

--Запросы из заданий
--UPDATE
--1
UPDATE
	"Types_of_expenditure"
SET 
	"name" = 'Прочее'
WHERE
	"name" = 'Проче';
--2
UPDATE
	"Types_of_expenditure"
SET 
	"name" = 'Зарплата'
WHERE
	"name" = 'Зарплат';
--3
UPDATE
	"Types_of_expenditure"
SET 
	"name" = 'Реклама'
WHERE
	"name" = 'Реклам';
--4
UPDATE
	"Expenses"
SET 
	"total" = 100000
WHERE
	"type_ID" = (
	SELECT "ID"
	FROM "Types_of_expenditure"
	WHERE "name" = 'Зарплата'
	);
--5
UPDATE
	"Expenses"
SET 
	"date" = NOW()
WHERE
	("date" > '2024-05-02');


--DELETE
--6 Удаление клиентов с некорректными именами
DELETE FROM 
	"Clients"
WHERE 
	"full_name" LIKE '%1%';
--7 Удаление уровней программы лояльности с некорректными скидками
DELETE FROM 
	"Expenses"
WHERE
	"total" < 0;
--8 Удаление некорректных аккаунтов программы лояльности
DELETE FROM 
	"Expenses"
WHERE
	"element_quantity" < 0;
--9 Удаление некорректных данных из таблицы сотрудников
DELETE FROM 
	"Employees"
WHERE 
	"full_name" IN ('Анна Аннова', 'Дмитрий Дмитриев');
--10 Удаление некорректных типов расходов
DELETE FROM 
	"Types_of_expenditure"
WHERE 
	"name" IN ('sadfasvas', 'sadfasdfasdfasdfasdff', 'Проче');


--SELECT, DISTINCT, WHERE, AND/OR/NOT, IN, BETWEEN, IS NULL, AS
--11 Выборка всех уникальных имен клиентов
SELECT DISTINCT "full_name"
FROM "Clients";
--12 Выборка клиентов с определенными номерами телефонов
SELECT 
	*
FROM 
	"Clients"
WHERE 
	"phone_number" IN ('+79999999991', '+79999999992', '+79999999993');
--13 Выборка клиентов с именами, которые содержат "Ivanov" и номера телефонов, начинающиеся на '+7999'
SELECT 
	*
FROM 
	"Clients"
WHERE 
	"full_name" LIKE '%Ivanov%' AND "phone_number" LIKE '+7999%';
--14 Выборка клиентов, которые не имеют номера телефона, начинающегося с '+79999999990
SELECT 
	*
FROM 
	"Clients"
WHERE 
	NOT "phone_number" = '+79999999990';
--15 Выборка аккаунтов программы лояльности с тратами между 2000 и 4000
SELECT 
	*
FROM 
	"Loyalty_program_accounts"
WHERE 
	"money_spent" BETWEEN 2000 AND 4000;
--16 Выборка уровней программы лояльности с дисконтом больше 3 и ценой меньше 5000
SELECT  
	*
FROM 
	"Loyalty_program_levels"
WHERE 
	"discount" > 3 AND "price" < 5000;
--17 Преобразование данных: выборка всех сотрудников с финальной оплатой в долларах (курс 1 доллар = 70 рублей)
SELECT 
	"full_name", "final_payment" / 70 AS "final_payment_in_usd"
FROM 
	"Employees";
--18 Выборка сотрудников, которые не имеют сверхурочных часов
SELECT 
	*
FROM 
	"Employees"
WHERE 
	"overtime_hours" IS NULL;
--19 Выборка заказов, сделанных в мае 2024 года
SELECT *
FROM 
	"Orders"
WHERE 
	"date" BETWEEN '2024-05-01' AND '2024-05-31';
--20 Выборка всех уникальных статусов заказов
SELECT 
	DISTINCT "name"
FROM 
	"Order_statuses";
--21 Выборка строк заказов для конкретного клиента
SELECT 
	ol.*
FROM 
	"Order_line" ol
JOIN 
	"Orders" o ON ol."order_ID" = o."ID"
WHERE
	o."client_ID" = 1;
--22 Псевдонимы для таблиц и столбцов: выборка сотрудников с псевдонимами для столбцов
SELECT
	e."full_name" AS "Employee Name", e."final_payment" AS "Final Payment"
FROM 
	"Employees" e;
--23 Выборка расходных материалов с условием по дате
SELECT 
	*
FROM 
	"Expenses"
WHERE 
	"date" < '2024-05-05';
--24 Выборка всех клиентов и их уровней лояльности
SELECT 
	c."full_name", l."name" AS "loyalty_level"
FROM 
	"Clients" c
JOIN 
	"Loyalty_program_accounts" la ON c."ID" = la."client_ID"
JOIN
	"Loyalty_program_levels" l ON la."lvl_ID" = l."ID";
--25 Выборка всех заказов, где сумма в строке заказа превышает 5000
SELECT 
	o.*
FROM 
	"Orders" o
JOIN 
	"Order_line" ol ON o."ID" = ol."order_ID"
JOIN 
	"Menu_items" mi ON ol."menu_item_ID" = mi."ID"
WHERE 
	mi."price" > 5000;
--26 Выборка всех типов расходов с некорректными именами
SELECT 
	*
FROM 
	"Types_of_expenditure"
WHERE 
	"name" IN ('sadfasvas', 'sadfasdfasdfasdfasdff');
--27 Преобразование строки в дату
SELECT 
	"full_name", CAST("ID" AS TEXT)
FROM 
	"Employees";
--28 Выборка всех клиентов и суммы их трат в программе лояльности
SELECT 
	c."full_name", la."money_spent"
FROM 
	"Clients" c
LEFT JOIN 
	"Loyalty_program_accounts" la ON c."ID" = la."client_ID";
--29 Выборка клиентов, у которых есть программа лояльности и потрачено больше 3000
SELECT 
	c.*
FROM 
	"Clients" c
JOIN 
	"Loyalty_program_accounts" la ON c."ID" = la."client_ID"
WHERE 
	la."money_spent" > 3000;
--30 Выборка всех продуктов в хранилище, срок годности которых истекает через 10 дней или меньше
SELECT
	si.*
FROM 
	"Storage_items" si
JOIN 
	"Items_in_warehouse" iw ON si."ID" = iw."item_id"
WHERE 
	iw."days_until_end_storage" <= 10;


--LIKE и другая работа со строками
--31 Выборка клиентов, чьи имена начинаются с 'Ivan'
SELECT 
	*
FROM 
	"Clients"
WHERE 
	"full_name" LIKE 'Ivan%';
--32 Выборка клиентов, чьи имена заканчиваются на 'Ivanovich'
SELECT
	*
FROM 
	"Clients"
WHERE 
	"full_name" LIKE '%Ivanovich';
--33 Выборка клиентов, чьи имена содержат 'Ivanov'
SELECT
	*
FROM 
	"Clients"
WHERE 
	"full_name" LIKE '%Ivanov%';
--34 Выборка клиентов, чьи имена содержат подчеркивание ('_')
SELECT
	*
FROM
	"Clients"
WHERE 
	"full_name" LIKE '%\_%' ESCAPE '\';
--35 Выборка клиентов, чьи номера телефонов начинаются с '+79999' и заканчиваются на '91'
SELECT
	*
FROM 
	"Clients"
WHERE 
	"phone_number" LIKE '+79999%91';
--36 Выборка клиентов, чьи имена содержат либо 'Ivanovich_2' либо 'Ivanovich_3'
SELECT 
	*
FROM 
	"Clients"
WHERE 
	"full_name" LIKE '%Ivanovich_2%' OR "full_name" LIKE '%Ivanovich_3%';
--37 Извлечение подстроки из имен клиентов (например, первых пяти символов имени)
SELECT 
	"full_name", SUBSTRING("full_name" FROM 1 FOR 5) AS "short_name"
FROM 
	"Clients";
--38 Конкатенация строк: Объединение имени клиента и номера телефона
SELECT 
	"full_name", "phone_number", "full_name" || ' - ' || "phone_number" AS "client_info"
FROM 
	"Clients";
--39 Преобразование строки в верхний регистр
SELECT
	"full_name", UPPER("full_name") AS "upper_name"
FROM 
	"Clients";
--40 Преобразование строки в нижний регистр
SELECT 
	"full_name", LOWER("full_name") AS "lower_name"
FROM 
	"Clients";
--41 Тримминг пробелов с начала и конца строки
SELECT 
	"full_name", TRIM("full_name") AS "trimmed_name"
FROM 
	"Clients";
--42 Замена части строки в имени клиента
SELECT 
	"full_name", REPLACE("full_name", 'Ivan', 'John') AS "replaced_name"
FROM 
	"Clients";


/*
SELECT INTO или INSERT SELECT, что поддерживается СУБД (2-3 шт.).
Для использования запроса INSERT SELECT вначале можно создать новую 
тестовую таблицу или несколько, в которые будут скопированы данные 
из существующих таблиц с помощью данного запроса. 
*/
-- Создание тестовой таблицы для клиентов
CREATE TABLE "Test_Clients" (
    "ID" SERIAL PRIMARY KEY,
    "phone_number" VARCHAR(15),
    "full_name" VARCHAR(100)
);

-- Создание тестовой таблицы для сотрудников
CREATE TABLE "Test_Employees" (
    "ID" SERIAL PRIMARY KEY,
    "full_name" VARCHAR(100),
    "job_title_ID" INT,
    "overtime_hours" INT,
    "final_payment" DECIMAL,
    "payment_date" DATE
);
--43 Копирование данных из таблицы Clients в Test_Clients
INSERT INTO 
	"Test_Clients" ("phone_number", "full_name")
SELECT 
	"phone_number", "full_name"
FROM 
	"Clients";
--44 Копирование данных из таблицы Employees в Test_Employees
INSERT INTO 
	"Test_Employees" 
		("full_name", "job_title_ID", "overtime_hours", "final_payment", "payment_date")
SELECT 
	"full_name", 
	"job_titel_ID", 
	"overtime_hours", 
	"final_payment", 
	"payment_date"
FROM 
	"Employees";
--45 Копирование данных с дополнительной фильтрацией: только сотрудники с оплатой более 30000
INSERT INTO 
	"Test_Employees" 
	("full_name", "job_title_ID", "overtime_hours", "final_payment", "payment_date")
SELECT 
	"full_name", 
	"job_titel_ID", 
	"overtime_hours", 
	"final_payment", 
	"payment_date"
FROM 
	"Employees"
WHERE 
	"final_payment" > 30000;


/*
JOIN: INNER, OUTER (LEFT, RIGHT, FULL), CROSS, NATURAL, 
разных, в различных вариациях, несколько запросов с более, чем одним JOIN. 
Обязательно сделать запросы со связями многие ко многим. (15 шт.+)
*/
--46 Рецепт и его Компонент 
SELECT 
	si."name" "Рецепт", menu."name" "Компонент"
FROM
	"Menu_item_composition_container" mic
JOIN "Menu_items" menu
	ON menu."ID" = mic."menu_item_ID"
JOIN "Storage_items" si
	ON si."ID" = mic."item_ID";
--47 Выбрать заказы и соответствующих клиентов
SELECT 
	o.*, c.*
FROM 
	"Orders" o
INNER JOIN 
	"Clients" c ON o."client_ID" = c."ID";
--48 Выбрать всех клиентов и их заказы, если они существуют

SELECT 
	c.*, o.*
FROM 
	"Clients" c
LEFT JOIN 
	"Orders" o ON c."ID" = o."client_ID";
--49 Выбрать все заказы и соответствующих клиентов, если они существуют
SELECT 
	o.*, c.*
FROM 
	"Orders" o
RIGHT JOIN 
	"Clients" c ON o."client_ID" = c."ID";
--50 Выбрать всех клиентов и их заказы, если они существуют, включая записи, которые не имеют соответствий в другой таблице
SELECT 
	c.*, o.*
FROM 
	"Clients" c
FULL OUTER JOIN 
	"Orders" o ON c."ID" = o."client_ID";
--51 Создать декартово произведение всех клиентов и всех заказов
SELECT 
	c.*, o.*
FROM 
	"Clients" c
CROSS JOIN 
	"Orders" o;
--52 Автоматическое соединение по столбцам с одинаковыми именами (предположим, что таблицы имеют одинаковые названия столбцов для соединения)
SELECT 
	*
FROM 
	"Orders" NATURAL JOIN "Clients";
--53 Выбрать заказы, клиентов и сотрудников, которые обработали заказы
SELECT 
	o.*, c.*, e.*
FROM 
	"Orders" o
INNER JOIN 
	"Clients" c ON o."client_ID" = c."ID"
INNER JOIN 
	"Employees" e ON o."employee_ID" = e."ID";
--54 Выбрать все заказы и, если они существуют, соответствующих клиентов и сотрудников
SELECT 
	o.*, c.*, e.*
FROM 
	"Orders" o
LEFT JOIN 
	"Clients" c ON o."client_ID" = c."ID"
LEFT JOIN 
	"Employees" e ON o."employee_ID" = e."ID";
--55 Выбрать всех клиентов и их заказы и сотрудников, если они существуют
SELECT 
	c.*, o.*, e.*
FROM 
	"Clients" c
RIGHT JOIN 
	"Orders" o ON c."ID" = o."client_ID"
RIGHT JOIN 
	"Employees" e ON o."employee_ID" = e."ID";
--56 Выбрать всех клиентов, заказы и сотрудников, включая записи, которые не имеют соответствий в других таблицах
SELECT 
	c.*, o.*, e.*
FROM 
	"Clients" c
FULL OUTER JOIN 
	"Orders" o ON c."ID" = o."client_ID"
FULL OUTER JOIN 
	"Employees" e ON o."employee_ID" = e."ID";
--57 Выбрать заказы и клиентов, где статус заказа - "Оплачен"
SELECT 
	o.*, c.*
FROM 
	"Orders" o
INNER 
	JOIN "Clients" c ON o."client_ID" = c."ID"
WHERE 
	o."status_ID" = (SELECT "ID" FROM "Order_statuses" WHERE "name" = 'Оплачен');
--58 Выбарать клиентов и посчитать их заказы
SELECT 
	c.*, COUNT(o) "Кол. заказов"
FROM 
	"Clients" "c"
LEFT JOIN 
	"Orders" o ON c."ID" = o."client_ID"
GROUP BY 
	c."ID";
--59 Выбрать все заказы и соответствующих клиентов, где количество заказанных элементов больше 2
SELECT 
	o.*, c.*
FROM 
	"Orders" o
RIGHT JOIN 
	"Clients" c ON o."client_ID" = c."ID"
WHERE 
	(SELECT COUNT(*) FROM "Order_line" ol WHERE ol."order_ID" = o."ID") > 2;
--60 Выбрать всех клиентов и их заказы, где дата заказа в мае 2024 года
SELECT 
	c.*, o.*
FROM 
	"Clients" c
FULL OUTER JOIN 
	"Orders" o ON c."ID" = o."client_ID"
WHERE 
	o."date" BETWEEN '2024-05-01' AND '2024-05-31';
--61 Выбрать меню и заказы, где они были заказаны (через таблицу "Order_line")
SELECT 
	m.*, o.*
FROM 
	"Menu_items" m
INNER JOIN 
	"Order_line" ol ON m."ID" = ol."menu_item_ID"
INNER JOIN 
	"Orders" o ON ol."order_ID" = o."ID";


/*
GROUP BY (некоторые с HAVING), с LIMIT, ORDER BY (ASC|DESC) 
вместе с COUNT, MAX, MIN, SUM, AVG в различных вариациях, 
можно по отдельности (15 шт.+)
*/
--62 Подсчитать количество заказов по каждому клиенту и отсортировать по количеству заказов по убыванию
SELECT 
	"client_ID", COUNT(*) AS order_count
FROM 
	"Orders"
GROUP BY 
	"client_ID"
ORDER BY 
	order_count DESC;
--63 Подсчитать общую сумму заказов для каждого клиента и отсортировать по сумме заказов по убыванию
SELECT 
    cl."full_name", 
    SUM(mi."price") AS total_spent
FROM 
    "Orders" o
JOIN 
    "Order_line" ol ON o."ID" = ol."order_ID"
JOIN 
    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
JOIN 
	"Clients" cl ON cl."ID" = o."client_ID"
GROUP BY 
    cl."full_name"
ORDER BY 
    total_spent DESC;
--64 Подсчитать среднюю сумму заказов для каждого клиента и отсортировать по средней сумме заказов по возрастанию
SELECT 
    cl."full_name", 
    (SUM(mi."price") 
	/ (SELECT COUNT(*) 
	   FROM "Orders" o
	   WHERE o."client_ID" = cl."ID"))  
	AS avg_spend
FROM 
    "Orders" o
JOIN 
    "Order_line" ol ON o."ID" = ol."order_ID"
JOIN 
    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
JOIN 
	"Clients" cl ON cl."ID" = o."client_ID"
GROUP BY 
    cl."full_name", cl."ID"
ORDER BY 
    avg_spend DESC;
--65 Найти максимальную сумму заказа для каждого клиента и отсортировать по максимальной сумме заказа по убыванию
SELECT
	op."full_name",
	MAX(op.order_price) AS max_order_price
FROM (
		SELECT 
		    cl."full_name", 
			o."ID" "order",
			SUM(mi."price") order_price
		FROM 
		    "Orders" o
		JOIN 
		    "Order_line" ol ON o."ID" = ol."order_ID"
		JOIN 
		    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
		JOIN 
			"Clients" cl ON cl."ID" = o."client_ID"
		GROUP BY 
		    cl."full_name", o."ID"
	) AS op
GROUP BY
	op."full_name"
ORDER BY
	max_order_price DESC;
--66 Найти минимальную сумму заказа для каждого клиента и отсортировать по минимальной сумме заказа по возрастанию
SELECT
	op."full_name",
	min(op.order_price) AS min_order_price
FROM (
		SELECT 
		    cl."full_name", 
			o."ID" "order",
			SUM(mi."price") order_price
		FROM 
		    "Orders" o
		JOIN 
		    "Order_line" ol ON o."ID" = ol."order_ID"
		JOIN 
		    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
		JOIN 
			"Clients" cl ON cl."ID" = o."client_ID"
		GROUP BY 
		    cl."full_name", o."ID"
	) AS op
GROUP BY
	op."full_name"
ORDER BY
	min_order_price ASC;
--67 Подсчитать количество заказов для каждого клиента и отфильтровать клиентов, у которых больше 5 заказов
SELECT 
	"client_ID", COUNT(*) AS order_count
FROM 
	"Orders"
GROUP BY 
	"client_ID"
HAVING 
	COUNT(*) > 5;
--68 Подсчитать общую сумму заказов для каждого клиента и отфильтровать клиентов, у которых общая сумма заказов превышает 10000
SELECT 
    cl."full_name", 
    SUM(mi."price") AS total_spent
FROM 
    "Orders" o
JOIN 
    "Order_line" ol ON o."ID" = ol."order_ID"
JOIN 
    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
JOIN 
	"Clients" cl ON cl."ID" = o."client_ID"
GROUP BY 
    cl."full_name"
HAVING 
	SUM(mi."price") > 1000
ORDER BY 
    total_spent DESC;
--69 Подсчитать среднюю сумму заказов для каждого клиента и отфильтровать клиентов, у которых средняя сумма заказа больше 1000
SELECT 
    cl."full_name", 
    (SUM(mi."price") 
	/ (SELECT COUNT(*) 
	   FROM "Orders" o
	   WHERE o."client_ID" = cl."ID"))  
	AS avg_spend
FROM 
    "Orders" o
JOIN 
    "Order_line" ol ON o."ID" = ol."order_ID"
JOIN 
    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
JOIN 
	"Clients" cl ON cl."ID" = o."client_ID"
GROUP BY 
    cl."full_name", cl."ID"
HAVING
	(SUM(mi."price") 
	/ (SELECT COUNT(*) 
	   FROM "Orders" o
	   WHERE o."client_ID" = cl."ID"))
	> 1000
ORDER BY 
    avg_spend DESC;
--70 Подсчитать количество заказов для каждого клиента и вывести топ 5 клиентов с наибольшим количеством заказов
SELECT 
	"client_ID", COUNT(*) AS order_count
FROM 
	"Orders"
GROUP BY 
	"client_ID"
ORDER BY 
	order_count DESC
LIMIT 5;
--71 Подсчитать среднюю сумму заказов для каждого клиента и вывести топ 5 клиентов с наибольшей средней суммой заказа
SELECT 
    cl."full_name", 
    (SUM(mi."price") 
	/ (SELECT COUNT(*) 
	   FROM "Orders" o
	   WHERE o."client_ID" = cl."ID"))  
	AS avg_spend
FROM 
    "Orders" o
JOIN 
    "Order_line" ol ON o."ID" = ol."order_ID"
JOIN 
    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
JOIN 
	"Clients" cl ON cl."ID" = o."client_ID"
GROUP BY 
    cl."full_name", cl."ID"
ORDER BY 
    avg_spend DESC
LIMIT 5;
--72 Найти максимальную сумму заказа для каждого клиента и вывести топ 5 клиентов с наибольшей максимальной суммой заказа
SELECT
	op."full_name",
	MAX(op.order_price) AS max_order_price
FROM (
		SELECT 
		    cl."full_name", 
			o."ID" "order",
			SUM(mi."price") order_price
		FROM 
		    "Orders" o
		JOIN 
		    "Order_line" ol ON o."ID" = ol."order_ID"
		JOIN 
		    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
		JOIN 
			"Clients" cl ON cl."ID" = o."client_ID"
		GROUP BY 
		    cl."full_name", o."ID"
	) AS op
GROUP BY
	op."full_name"
ORDER BY
	max_order_price DESC
LIMIT 5;
--73 Найти минимальную сумму заказа для каждого клиента и вывести топ 5 клиентов с наибольшей минимальной суммой заказа
SELECT
	op."full_name",
	MIN(op.order_price) AS min_order_price
FROM (
		SELECT 
		    cl."full_name", 
			o."ID" "order",
			SUM(mi."price") order_price
		FROM 
		    "Orders" o
		JOIN 
		    "Order_line" ol ON o."ID" = ol."order_ID"
		JOIN 
		    "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
		JOIN 
			"Clients" cl ON cl."ID" = o."client_ID"
		GROUP BY 
		    cl."full_name", o."ID"
	) AS op
GROUP BY
	op."full_name"
ORDER BY
	min_order_price DESC
LIMIT 5;
--74 Подсчитать количество заказов для каждого клиента и каждого сотрудника, который обрабатывал заказ
SELECT 
	"client_ID", "employee_ID", COUNT(*) AS order_count
FROM 
	"Orders"
GROUP BY 
	"client_ID", "employee_ID"
ORDER BY 
	order_count DESC;
--75 Подсчитать количество заказов для каждого клиента и каждого сотрудника, который обрабатывал заказ, и отфильтровать, чтобы включить только тех, у кого более 5 заказов
SELECT 
	"client_ID", "employee_ID", COUNT(*) AS order_count
FROM 
	"Orders"
GROUP BY 
	"client_ID", "employee_ID"
HAVING 
	COUNT(*) > 5
ORDER BY 
	order_count DESC;


--Вложенные SELECT с GROUP BY, ALL, ANY, EXISTS (3-5 шт.)
--76 Выбирает всех сотрудников, которые имеют хотя бы один заказ
SELECT 
	e."full_name"
FROM 
	"Employees" e
WHERE EXISTS (
    SELECT 1
    FROM "Orders" o
    WHERE o."employee_ID" = e."ID"
    GROUP BY o."employee_ID"
);
--77 Выбирает всех клиентов, которые сделали более одного заказа
SELECT c."full_name"
FROM "Clients" c
WHERE c."ID" = ALL (
    SELECT o."client_ID"
    FROM "Orders" o
    GROUP BY o."client_ID"
    HAVING COUNT(o."ID") > 1
);
--78 Выбирает всех сотрудников, которые обработали более пяти заказов
SELECT 
	e."full_name"
FROM 
	"Employees" e
WHERE e."ID" = ANY (
    SELECT o."employee_ID"
    FROM "Orders" o
    GROUP BY o."employee_ID"
    HAVING COUNT(o."ID") > 5
);
--79 Запрос выбирает все элементы меню, которые были заказаны хотя бы один раз
SELECT 
	mi."name", mi."price"
FROM 
	"Menu_items" mi
WHERE EXISTS (
    SELECT 1
    FROM "Order_line" ol
    JOIN "Orders" o ON ol."order_ID" = o."ID"
    WHERE ol."menu_item_ID" = mi."ID"
    GROUP BY ol."menu_item_ID"
);
--80 Выбирает все должности, у которых зарплата выше среднего окончательного платежа всех сотрудников по каждой должности
SELECT 
	j."name"
FROM 
	"Job_titles" j
WHERE j."salary" > ALL (
    SELECT AVG(e."final_payment")
    FROM "Employees" e
    GROUP BY e."job_titel_ID"
);


--GROUP_CONCAT и другие разнообразные функции SQL (2-3 шт.)
--81 Получить список имен клиентов, которые сделали заказы, сгруппированные по идентификатору клиента
--STRING_AGG аналог GROUP_CONCAT в postgres
SELECT 
	c."ID", c."full_name", STRING_AGG(o."ID"::text, ', ') AS order_ids
FROM 
	"Clients" c
JOIN 
	"Orders" o ON c."ID" = o."client_ID"
GROUP BY 
	c."ID", c."full_name";
--82 Получить массив идентификаторов сотрудников, которые обрабатывали заказы, сгруппированные по заказу
SELECT 
	o."ID" AS order_id, ARRAY_AGG(e."ID") AS employee_ids
FROM 
	"Orders" o
JOIN 
	"Employees" e ON o."employee_ID" = e."ID"
GROUP BY 
	o."ID";
--83 Получить JSON массив с именами сотрудников и их должностями
SELECT 
	JSON_AGG(
	    JSON_BUILD_OBJECT(
	        'full_name', e."full_name",
	        'job_title', jt."name"
	    )
	) AS employees_info
FROM 
	"Employees" e
JOIN 
	"Job_titles" jt ON e."job_titel_ID" = jt."ID";
--84 Получить количество заказов для каждого клиента
SELECT 
	c."full_name", COUNT(o."ID") AS order_count
FROM 
	"Clients" c
JOIN 
	"Orders" o ON c."ID" = o."client_ID"
GROUP BY 
	c."full_name";
--85 Получить среднюю и общую сумму выплат для каждого сотрудника
SELECT 
	emp."full_name", 
	SUM(ex."total") total, 
	AVG(ex."total") "avg"
FROM
	"Employees" emp
LEFT JOIN
	"Expenses" ex ON emp."ID" = ex."employee_id"
GROUP BY
	emp.full_name;


--Запросы с WITH (2-3 шт.)
--86 Запрос для подсчета общего числа часов переработки сотрудников и их общей зарплаты с учетом переработок
WITH Overtime AS (
    SELECT
        e."ID",
        e."full_name",
        e."overtime_hours",
        jt."salary",
        (e."overtime_hours" * 1.5 * jt."salary" / 160) AS overtime_payment
    FROM
        "Employees" e
    JOIN
        "Job_titles" jt ON e."job_titel_ID" = jt."ID"
)
SELECT
    full_name,
    overtime_hours,
    salary,
    overtime_payment,
    (salary + overtime_payment) AS total_salary_with_overtime
FROM
    Overtime;
--87 Запрос для получения списка клиентов, которые потратили больше определенной суммы денег в программе лояльности, и информации об их текущем уровне
WITH HighSpenders AS (
    SELECT
        c.full_name,
        lpa.money_spent,
        lpl.name AS level_name,
        lpl.discount
    FROM
        "Clients" AS c
    JOIN
        "Loyalty_program_accounts" lpa ON c."ID" = lpa."client_ID"
    JOIN
        "Loyalty_program_levels" lpl ON lpa."lvl_ID" = lpl."ID"
    WHERE
        lpa.money_spent > 3000
)
SELECT
    full_name,
    money_spent,
    level_name,
    discount
FROM
    HighSpenders;
--88 Запрос для получения информации о заказах, их статусе и списке заказанных блюд
WITH OrderDetails AS (
    SELECT
        o."ID" AS order_id,
        o."date",
        os."name" AS status,
        e."full_name" AS employee_name,
        c."full_name" AS client_name
    FROM
        "Orders" o
    JOIN
        "Order_statuses" os ON o."status_ID" = os."ID"
    JOIN
        "Employees" e ON o."employee_ID" = e."ID"
    JOIN
        "Clients" c ON o."client_ID" = c."ID"
)
, OrderItems AS (
    SELECT
        ol."order_ID" order_id,
        mi."name" AS menu_item_name,
        mi."price"
    FROM
        "Order_line" ol
    JOIN
        "Menu_items" mi ON ol."menu_item_ID" = mi."ID"
)
SELECT
    od.order_id,
    od.client_name,
	od.employee_name employees_names,
	ARRAY_AGG(oi.menu_item_name) items_names,
    od.date,
    od.status,
    SUM(oi.price)
FROM
    OrderDetails od
JOIN
    OrderItems oi ON od.order_id = oi.order_id
GROUP BY
	od.client_name, od.order_id, od.employee_name, od.date, od.status
ORDER BY
    od.order_id;


/*
Запросы со строковыми функциями СУБД, с функциями работы с 
датами временем (форматированием дат), с арифметическими функциями (5-7 шт.)
*/
--89 LOWER и UPPER - Преобразование строки к нижнему и верхнему регистру соответственно:
SELECT 
	LOWER("full_name") AS lower_name, UPPER("full_name") AS upper_name
FROM 
	"Employees";
--90 SUBSTRING - Извлечение подстроки из строки
SELECT 
	SUBSTRING("full_name" FROM 1 FOR 3) AS substring_name
FROM "Employees";
--91 CONCAT - Конкатенация строк
SELECT 
	CONCAT(
	"full_name", 
	' | ', 
	(SELECT "name" FROM "Job_titles" WHERE "ID" = e."job_titel_ID")
	) AS full_name
FROM "Employees" as e;
--92 LENGTH - Получение длины строки
SELECT 
	LENGTH("full_name") AS name_length
FROM 
	"Employees";
--93 CURRENT_DATE и CURRENT_TIME - Текущая дата и время:
SELECT CURRENT_DATE AS today, CURRENT_TIME AS now;
--94 NOW - Текущая дата и время
SELECT NOW() AS current_datetime;
--95 ABS - Абсолютное значение
SELECT 
	ABS(-10) AS "abs";
--96 ROUND - Округление до ближайшего целого числа или до заданного количества десятичных знаков:
SELECT 
	ROUND(0.7543254, 2) AS rounded;
--97 CEIL и FLOOR - Округление вверх и вниз
SELECT 
	CEIL(1.5) AS "ceiling", FLOOR(1.5) AS "floor";
--98 POWER - Возведение в степень
SELECT POWER(5, 2) AS squared;
--99 MOD - Остаток от деления
SELECT MOD(1001, 1000) AS "mod";
--100 finally
SELECT LOG(4) AS "log";









