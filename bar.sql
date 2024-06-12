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
	"manafacture_job_titl_ID" integer NOT NULL
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
CREATE INDEX idx_ordres_client ON "Orders"("client_ID", "ID");

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
	"storage_condition_ID" integer NOT NULL
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
FROM 'D:\bdSem\csv\Clients.csv'
DELIMITER ';'
CSV HEADER;

COPY "Loyalty_program_accounts"("money_spent", "client_ID", "lvl_ID")
FROM 'D:\bdSem\csv\lpa.csv'
DELIMITER ';'
CSV HEADER;

COPY "Employees"("full_name", "job_titel_ID", "overtime_minutes", "final_payment", "payment_date")
FROM 'D:\bdSem\csv\employees.csv'
DELIMITER ';'
CSV HEADER;

COPY "Menu_items"("name", "price", "manafacture_job_titl_ID")
FROM 'D:\bdSem\csv\menu.csv'
DELIMITER ';'
CSV HEADER;

COPY "Storage_items"("name", "characteristics", "volume", "price","storage_condition_ID",  "shell_life_in_days", "supplier", "item_type_ID")
FROM 'D:\bdSem\csv\storage_items.csv'
DELIMITER ';'
CSV HEADER;

COPY "Menu_item_composition_container"("item_ID", "menu_item_ID", "quantity")
FROM 'D:\bdSem\csv\Menu_item_composition_container.csv'
DELIMITER ';'
CSV HEADER;

COPY "Orders"("date", "client_ID", "employee_ID", "status_ID", "total")
FROM 'D:\bdSem\csv\Orders.csv'
DELIMITER ';'
CSV HEADER;

COPY "Order_line"("order_ID", "menu_item_ID", "quantity")
FROM 'D:\bdSem\csv\Order_line.csv'
DELIMITER ';'
CSV HEADER;

COPY "Warehouse_spaces"("name", "capacity", "storage_condition_ID")
FROM 'D:\bdSem\csv\Warehouse_spaces.csv'
DELIMITER ';'
CSV HEADER;

COPY "Items_in_warehouse"("item_id", "warehouse_place_id", "quantity_of_item", "days_until_end_storage")
FROM 'D:\bdSem\csv\Items_in_warehouse.csv'
DELIMITER ';'
CSV HEADER;

COPY "Expenses"("storage_item_ID", "employee_id", "date", "element_quantity", "total", "type_ID")
FROM 'D:\bdSem\csv\Expenses.csv'
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

--2. Обновление программы лояльности для клиентов при оформлении заказа 
-- Функция для обновления программы лояльности клиентов
CREATE OR REPLACE FUNCTION update_loyalty_program()
RETURNS TRIGGER AS $$
BEGIN
    -- Обновляем количество потраченных денег
    UPDATE "Loyalty_program_accounts"
    SET "money_spent" = "money_spent" + NEW."total"
    WHERE "client_ID" = NEW."client_ID";

    -- Обновляем уровень программы лояльности
    UPDATE "Loyalty_program_accounts" AS lpa
    SET "lvl_ID" = (
        SELECT "ID"
        FROM "Loyalty_program_levels"
        WHERE "price" <= lpa."money_spent"
        ORDER BY "price" DESC
        LIMIT 1
    )
    WHERE lpa."client_ID" = NEW."client_ID";

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для вызова функции перед обновлением заказа
CREATE TRIGGER before_update_orders
BEFORE UPDATE ON "Orders"
FOR EACH ROW
WHEN (OLD."total" IS DISTINCT FROM NEW."total")
EXECUTE FUNCTION update_loyalty_program();


-- 3. Обновлять количество расходников на складе, которые участвуют в создании пунктов меню, при оформлении заказа
-- Функция триггера
CREATE OR REPLACE FUNCTION decrease_items_in_warehouse()
RETURNS TRIGGER AS $$
DECLARE
    item RECORD;
    warehouse_item RECORD;
    needed_quantity INTEGER;
    item_consumed BOOLEAN;
BEGIN
    -- Проходим по каждому пункту меню в новом заказе
    FOR item IN 
        SELECT micc."item_ID", micc."quantity" * NEW."quantity" AS required_quantity
        FROM "Menu_item_composition_container" micc
        JOIN "Menu_items" mi ON mi."ID" = micc."menu_item_ID"
        JOIN "Item_types" it ON it."ID" = micc."item_ID"
        WHERE NEW."menu_item_ID" = mi."ID" AND it."consamable" = TRUE
    LOOP
        needed_quantity := item.required_quantity;
        
        -- Уменьшаем количество хранимых предметов в порядке срока годности
        FOR warehouse_item IN 
            SELECT * 
            FROM "Items_in_warehouse" 
            WHERE item_id = item."item_ID"
            ORDER BY days_until_end_storage
        LOOP
            -- Если предметы есть на складе
            IF warehouse_item.quantity_of_item >= needed_quantity THEN
                -- Уменьшаем количество предметов
                UPDATE "Items_in_warehouse"
                SET quantity_of_item = quantity_of_item - needed_quantity
                WHERE "ID" = warehouse_item."ID";
                
                -- Заканчиваем обработку текущего предмета
                EXIT;
            ELSE
                -- Если предметов недостаточно, уменьшаем все, что есть, и продолжаем
                needed_quantity := needed_quantity - warehouse_item.quantity_of_item;
                UPDATE "Items_in_warehouse"
                SET quantity_of_item = 0
                WHERE ID = warehouse_item.ID;

                -- Удаляем запись, так как количество предметов стало 0
                DELETE FROM "Items_in_warehouse"
                WHERE ID = warehouse_item.ID;
            END IF;
        END LOOP;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер
CREATE TRIGGER after_insert_order_line
AFTER INSERT ON "Order_line"
FOR EACH ROW
EXECUTE FUNCTION decrease_items_in_warehouse();


--4. Удаление просроченных продуктов 
CREATE OR REPLACE PROCEDURE remove_expired_products()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM "Items_in_warehouse"
    WHERE "days_until_end_storage" <= 0;
END;
$$;


--5. Выдача списка просроченных продуктов
CREATE OR REPLACE FUNCTION get_list_expired_products()
RETURNS TABLE(item_name varchar(100), quantity_of_item integer, days_until_end_storage integer, storage_name varchar(100)) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
		si."name", iiw."quantity_of_item", iiw."days_until_end_storage", ws."name"
    FROM 
		"Items_in_warehouse" iiw
	JOIN "Warehouse_spaces" ws
		ON ws."ID" = iiw."warehouse_place_id"
	JOIN "Storage_items" si
		ON si."ID" = "item_id"
    WHERE 
		iiw."days_until_end_storage" <= 0;
END;
$$;


--6. Выдача списка не просроченных продуктов
CREATE OR REPLACE FUNCTION get_list_not_expired_products()
RETURNS TABLE(item_name varchar(100), quantity_of_item integer, days_until_end_storage integer, storage_name varchar(100)) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
		si."name", iiw."quantity_of_item", iiw."days_until_end_storage", ws."name"
    FROM 
		"Items_in_warehouse" iiw
	JOIN "Warehouse_spaces" ws
		ON ws."ID" = iiw."warehouse_place_id"
	JOIN "Storage_items" si
		ON si."ID" = "item_id"
    WHERE 
		iiw."days_until_end_storage" > 0;
END;
$$;

--7. Обновление зарплаты работника при добавлении переработки 
-- Функция для обновления зарплаты работника при добавлении переработки
CREATE OR REPLACE FUNCTION update_employee_salary_overtime()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "Employees"
    SET "final_payment" = "final_payment" + (NEW."overtime_minutes" * (SELECT "salary" / 60 FROM "Job_titles" WHERE "ID" = NEW."job_titel_ID") / 60)
    WHERE "ID" = NEW."ID";

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для вызова функции после обновления информации о переработке сотрудника
CREATE TRIGGER after_updating_employee_overtime
AFTER UPDATE OF "overtime_minutes" ON "Employees"
FOR EACH ROW
EXECUTE FUNCTION update_employee_salary_overtime();


--8. Обновление зарплаты работника при выплате зарплаты
-- Функция для обновления зарплаты работника при выплате зарплаты
CREATE OR REPLACE FUNCTION update_employee_salary_payment_date()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO "Expenses" ("employee_id", "date", "element_quantity", "total", "type_ID")
		VALUES (NEW."ID", CURRENT_DATE, 1, NEW."final_payment", 2);
	
    UPDATE "Employees"
    SET "final_payment" = (SELECT "salary" FROM "Job_titles" WHERE "ID" = NEW."job_titel_ID")
    WHERE "ID" = NEW."ID";

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для вызова функции после обновления даты выплаты зарплаты
CREATE TRIGGER after_updating_employee_payment_date
AFTER UPDATE OF "payment_date" ON "Employees"
FOR EACH ROW
EXECUTE FUNCTION update_employee_salary_payment_date();

-- Выплатить зарплату
CREATE OR REPLACE PROCEDURE pay_employee_salary()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE "Employees"
	SET "payment_date" = "payment_date" + INTERVAL '1 month'
	WHERE "payment_date" = CURRENT_DATE;
END;
$$;



--9. Обновление зарплаты работника при смене должности
-- Функция для обновления зарплаты работника при смене должности
CREATE OR REPLACE FUNCTION update_employee_salary_job_title()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "Employees"
    SET "final_payment" = (SELECT "salary" FROM "Job_titles" WHERE "ID" = NEW."job_titel_ID")
    WHERE "ID" = NEW."ID";

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для вызова функции после обновления должности сотрудника
CREATE TRIGGER after_updating_employee_job_title
AFTER UPDATE OF "job_titel_ID" ON "Employees"
FOR EACH ROW
EXECUTE FUNCTION update_employee_salary_job_title();


--10. Выдача расходов, доходов и прибыли за заданный период 
-- Функция для получения расходов за заданный период
CREATE OR REPLACE FUNCTION get_expenses(start_date date, end_date date)
RETURNS integer 
LANGUAGE plpgsql
AS $$
DECLARE
    expenses_sum integer;
BEGIN
    SELECT SUM("total") INTO expenses_sum
    FROM "Expenses"
    WHERE "date" BETWEEN start_date AND end_date;

    RETURN expenses_sum;
END;
$$;

-- Функция для получения доходов за заданный период
CREATE OR REPLACE FUNCTION get_income(start_date date, end_date date)
RETURNS integer 
LANGUAGE plpgsql
AS $$
DECLARE
    income_sum integer;
BEGIN
    SELECT SUM("total") INTO income_sum
    FROM "Orders"
    WHERE "date" BETWEEN start_date AND end_date;

    RETURN income_sum;
END;
$$;

-- Функция для получения прибыли за заданный период
CREATE OR REPLACE FUNCTION get_profit(start_date date, end_date date)
RETURNS integer 
LANGUAGE plpgsql
AS $$
DECLARE
    expenses integer;
    income integer;
BEGIN
    SELECT get_expenses(start_date, end_date) INTO expenses;
    SELECT get_income(start_date, end_date) INTO income;

    RETURN income - expenses;
END;
$$;

--11. Выдавать доход за определенный период при изменении цены предметов, участвующих в создании пунктов меню
--

--12. Выдавать доход за определенный период при изменении цены предметов, участвующих в создании пунктов меню  
CREATE OR REPLACE FUNCTION get_income_when_price_items_warehouse_changes(start_date date, end_date date, item_id integer, new_price integer)
RETURNS integer 
LANGUAGE plpgsql
AS $$
DECLARE
    income_sum integer;
    old_price integer;
BEGIN
    -- Изменяем цену предмета
    SELECT "price" INTO old_price
    FROM "Storage_items"
    WHERE "ID" = item_id;

    UPDATE "Storage_items"
    SET "price" = new_price
    WHERE "ID" = item_id;

    -- Рассчитываем доход за указанный период
    SELECT SUM("total") INTO income_sum
    FROM "Orders"
    WHERE "date" BETWEEN start_date AND end_date;

    UPDATE "Storage_items"
    SET "price" = old_price
    WHERE "ID" = item_id;

    RETURN income_sum;
END;
$$;

-- 13. Выдавать возможно ли положить предмет на склад
CREATE OR REPLACE FUNCTION is_possibly_put_in_storage(IN item_name varchar(100), IN quantity integer)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	available_volume REAL;
	item_volume REAL;
	item_storage_cond_ID integer;
	item_ID integer;
BEGIN 
	--получить объем предмета и storage_cond
	SELECT 
		si."volume", si."storage_condition_ID", si."ID" INTO item_volume, item_storage_cond_ID, item_ID
	FROM 
		"Storage_items" si
	WHERE 
		si."name" = item_name;

-- получить доступные объемы в каждом нужном спэйсе (изначальные - занятый - (остаток от деления на объем предмета)) 
-- сумировать доступные объемы 
-- вернуть: сумма доступных объемов >= необходимый объем
	
	WITH volumes_occupied AS (
	-- получить занимаемые объемы в каждом спэйсе
		SELECT 
			iiw."warehouse_place_id" wp_ID, SUM(si."volume" * iiw."quantity_of_item") v
		FROM 
			"Items_in_warehouse" iiw
		JOIN "Storage_items" si
			ON si."ID" = iiw."item_id"
		GROUP BY
			iiw."warehouse_place_id"
	), av_vol AS(
		-- получить доступные объемы в каждом нужном спэйсе
		SELECT 
			ws."capacity" - vo.v - (ws."capacity" - (ws."capacity"::INTEGER / CAST(item_volume AS INTEGER)) * item_volume) v
		FROM 
			volumes_occupied vo
		JOIN "Warehouse_spaces" ws
			ON ws."ID" = vo.wp_ID
		GROUP BY
			ws."ID", ws."capacity", vo.v
		HAVING 
			ws."storage_condition_ID" = item_storage_cond_ID
	) 
	SELECT 
		SUM(av.v) INTO available_volume
	FROM av_vol av;

	RETURN available_volume >= (item_volume * quantity);
END;
$$;


-- 14. Класть вещи на склад 
CREATE OR REPLACE PROCEDURE insert_in_warehouse(IN item_name varchar(100), IN quantity integer)
LANGUAGE plpgsql
AS $$
DECLARE
	available_volume REAL;
	item_volume REAL;
	item_storage_cond_ID integer;
	item_days_unti_end_stor integer;
	total_insert_volume real;
	record RECORD;
	item_ID integer;
BEGIN
	--получить объем предмета и storage_cond
	SELECT 
		si."volume", si."storage_condition_ID", si."shell_life_in_days" , si."ID" 
		INTO item_volume, item_storage_cond_ID, item_days_unti_end_stor, item_ID
	FROM 
		"Storage_items" si
	WHERE 
		si."name" = item_name;

	total_insert_volume := item_volume * quantity;
	
	FOR record IN (
		WITH volumes_occupied AS (
		-- получить занимаемые объемы в каждом спэйсе
			SELECT 
				iiw."warehouse_place_id" wp_ID, SUM(si."volume" * iiw."quantity_of_item") v
			FROM 
				"Items_in_warehouse" iiw
			JOIN "Storage_items" si
				ON si."ID" = iiw."item_id"
			GROUP BY
				iiw."warehouse_place_id"
		)
			-- получить доступные объемы в каждом нужном спэйсе
			SELECT 
				ws."ID" ws_ID, 
				ws."capacity" - vo.v - (ws."capacity" - (ws."capacity"::INTEGER / CAST(item_volume AS INTEGER)) * item_volume) vol
			FROM 
				volumes_occupied vo
			JOIN "Warehouse_spaces" ws
				ON ws."ID" = vo.wp_ID
			GROUP BY
				ws."ID", ws."capacity", vo.v
			HAVING 
				ws."storage_condition_ID" = item_storage_cond_ID
	)	LOOP 
			IF total_insert_volume <= 0 THEN
				RETURN;
			END IF;
		
			INSERT INTO "Items_in_warehouse" ("item_id", "warehouse_place_id", "quantity_of_item", "days_until_end_storage")
				VALUES 
					(item_ID, record.ws_ID,  FLOOR(CAST(LEAST(total_insert_volume, record.vol) AS REAL) / item_volume), item_days_unti_end_stor);
			total_insert_volume := total_insert_volume - record.vol;
		END LOOP;	
END;
$$;


-- 15. Вставлять траты на предметы
CREATE OR REPLACE PROCEDURE insert_in_expenses(IN item_name varchar(100), IN quantity integer)
LANGUAGE plpgsql
AS $$
DECLARE
    item_id INTEGER;
    type_id INTEGER;
    item_price NUMERIC;
BEGIN
    SELECT si."ID", si."price"
    INTO item_id, item_price
    FROM "Storage_items" si
    WHERE si."name" = item_name;

    SELECT "t"."ID"
    INTO type_id
    FROM "Types_of_expenditure" "t"
    WHERE "t"."name" = 'Расходный материалы';

    INSERT INTO "Expenses" ("storage_item_ID", "date", "element_quantity", "total", "type_ID")
    VALUES (item_id, CURRENT_DATE, quantity, quantity * item_price, type_id);
END;
$$;








