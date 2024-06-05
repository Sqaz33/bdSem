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
	"overtime_minutes" integer,
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

INSERT INTO "Loyalty_program_levels" ("name", "discount", "price")
	VALUES 
		('Start', 1, 1000),
		('Bronze', 2, 2000),
		('Silver', 3, 3000),
		('Gold', 4, 4000),
		('Platinum', 5, 5000),
		('Diamond', 6, 6000);

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
	"quantity" integer NOT NULL DEFAULT 1,
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
	"status_ID" integer NOT NULL,
	"total" integer NOT NULL
);
CREATE INDEX idx_orders_date ON "Orders" ("date");
--Один клиент ко многим заказам
CREATE INDEX idx_ordres_client ON "Orders"("clint_ID", "ID");

--таблица статусов заказов
CREATE TABLE IF NOT EXISTS "Order_statuses" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL
);

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
CREATE INDEX idx_expenses_date ON "Expenses" ("date");

--таблица видов трат
CREATE TABLE IF NOT EXISTS "Types_of_expenditure" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL
);

INSERT INTO "Types_of_expenditure" ("name")
	VALUES 
		('Расходный материалы'),
		('Зарплата'),
		('Реклама'),
		('Транспорт'),
		('Аренда'),
		('Прочее');


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
	"storage_condition_ID" integer NOT NULL,
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
CREATE INDEX item_ID_iiw_ID_inedex ON "Items_in_warehouse"("item_id", "ID");	
CREATE INDEX idx_storage_items_id ON "Storage_items" ("ID");
CREATE INDEX idx_items_in_warehouse_item_id ON "Items_in_warehouse" ("item_id");
CREATE INDEX idx_items_in_warehouse_quantity ON "Items_in_warehouse" ("quantity_of_item");

--таблица условий хранения
CREATE TABLE IF NOT EXISTS "Storage_conditions" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) 
);

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

--таблица типов предметов
CREATE TABLE IF NOT EXISTS "Item_types" (
	"ID" serial PRIMARY KEY,
	"name" varchar(100) NOT NULL UNIQUE,
	"consamable" bool NOT NULL
);

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


-- копирую 
COPY "Clients"("full_name", "phone_number")
FROM 'D:\bdSem\Clients.csv'
DELIMITER ';'
CSV HEADER;

COPY "Loyalty_program_accounts"("money_spent", "client_ID", "lvl_ID")
FROM 'D:\bdSem\lpa.csv'
DELIMITER ';'
CSV HEADER;

COPY "Employees"("full_name", "job_titel_ID", "overtime_minutes", "final_payment", "payment_date")
FROM 'D:\bdSem\employees.csv'
DELIMITER ';'
CSV HEADER;

COPY "Menu_items"("name", "price", "manafacture_ID")
FROM 'D:\bdSem\menu.csv'
DELIMITER ';'
CSV HEADER;

COPY "Storage_items"("name", "characteristics", "volume", "price","storage_condition_ID",  "shell_life_in_days", "supplier", "item_type_ID")
FROM 'D:\bdSem\storage_items.csv'
DELIMITER ';'
CSV HEADER;

COPY "Menu_item_composition_container"("item_ID", "menu_item_ID", "quantity")
FROM 'D:\bdSem\Menu_item_composition_container.csv'
DELIMITER ';'
CSV HEADER;

COPY "Orders"("date", "client_ID", "employee_ID", "status_ID", "total")
FROM 'D:\bdSem\Orders.csv'
DELIMITER ';'
CSV HEADER;

COPY "Order_line"("order_ID", "menu_item_ID", "quantity")
FROM 'D:\bdSem\Order_line.csv'
DELIMITER ';'
CSV HEADER;

COPY "Warehouse_spaces"("name", "capacity", "storage_condition_ID", "such_places_in_warehouse")
FROM 'D:\bdSem\Warehouse_spaces.csv'
DELIMITER ';'
CSV HEADER;

COPY "Items_in_warehouse"("item_id", "warehouse_place_id", "quantity_of_item", "days_until_end_storage")
FROM 'D:\bdSem\Items_in_warehouse.csv'
DELIMITER ';'
CSV HEADER;

COPY "Expenses"("storage_item_ID", "employee_id", "date", "element_quantity", "total", "type_ID")
FROM 'D:\bdSem\Expenses.csv'
DELIMITER ';'
CSV HEADER;

UPDATE "Expenses"
SET "type_ID" = 1
WHERE "type_ID" = 0;

UPDATE "Expenses"
SET "employee_id" = NULL
WHERE "type_ID" = 1;

UPDATE "Expenses"
SET "storage_item_ID" = NULL
WHERE "type_ID" = 2;

UPDATE "Orders"
SET "status_ID" = 1
WHERE "status_ID" = 0;

UPDATE "Storage_items"
SET "item_type_ID" = 1
WHERE "item_type_ID" = 0;

UPDATE "Storage_items"
SET "storage_condition_ID" = 1
WHERE "storage_condition_ID" = 0;

UPDATE "Warehouse_spaces"
SET "storage_condition_ID" = 1
WHERE "storage_condition_ID" = 0;

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
		FOREIGN KEY ("storage_condition_ID")
		REFERENCES "Storage_conditions"("ID");

ALTER TABLE "Items_in_warehouse"
	--многие-к-одному 
	ADD CONSTRAINT "Items_in_warehouse_fk1"
		FOREIGN KEY ("item_id")
		REFERENCES "Storage_items"("ID"),
	ADD CONSTRAINT "Items_in_warehouse_fk2"
		FOREIGN KEY ("warehouse_place_id")
		REFERENCES "Warehouse_spaces"("ID");

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


--Запросы для функциональных требований

--Вести учет программы лояльности
--1. Обновить уровень программы лояльности
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

--2. Обновить уровень программы лояльности
WITH ranked_levels AS (
	SELECT
		lpa."ID",
		lpa."money_spent",
		lpv."ID" as new_lvl_ID,
		ROW_NUMBER() OVER (PARTITION BY lpa."ID" ORDER BY lpv."price" DESC) as rank
	FROM
		"Loyalty_program_accounts" lpa
	JOIN
		"Loyalty_program_levels" lpv ON lpa."money_spent" >= lpv."price"
)
UPDATE
	"Loyalty_program_accounts" lpa
SET
	"lvl_ID" = rl.new_lvl_ID
FROM
	ranked_levels rl
WHERE
	lpa."ID" = rl."ID" AND rl.rank = 1;

--3. Выписка из складского учета
SELECT
    si."name" as item_name, SUM(iw."quantity_of_item") as quantity
FROM 
	"Items_in_warehouse" iw
JOIN 
     "Storage_items" si ON si."ID" = iw."item_id"
GROUP BY
    si."name"
ORDER BY 
	quantity;

--4. Показать заказы в работе
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

--5. Узнать самый покупаемый пункт меню
EXPLAIN
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



--6. (пример) Узнать доходы, расходы, прибыль за определенный период (допустим месяц).
--Расходы
WITH expenses as (
		SELECT 
			SUM("total") total
		FROM 
			"Expenses"
		WHERE "date" BETWEEN (NOW() - INTERVAL '1 month') AND NOW()
),
--Доходы
income as (
	SELECT 
		SUM(ord."total") total
	FROM 
		"Orders" ord
	WHERE "date" BETWEEN (NOW() - INTERVAL '1 month') AND NOW()
)
--Прибыль
SELECT 
	e.total AS "expenses",
	i.total AS "income",
	(i.total - e.total) AS profit
FROM 
	expenses e
CROSS JOIN 
	income i;
-- SET enable_seqscan = on;
--7. (пример) Узнать посещаемость за определенный период (предыдущей месяц).
WITH unique_orders AS (
	SELECT 
		"client_ID",     
		"date",
		EXTRACT(MONTH FROM "date") "month"
	FROM 
		"Orders" ord
	GROUP BY
		"client_ID",     
		"date"
)
SELECT 
	COUNT(*) attendance
FROM 
	unique_orders
WHERE
	EXTRACT(MONTH FROM NOW()) - 1 = "month";
	








