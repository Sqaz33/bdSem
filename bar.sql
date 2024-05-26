--<<<<<<<<<<<<работа с сотрудниками<<<<<<<<<<<<<<<<<
--таблица сотрудников
CREATE TABLE IF NOT EXISTS "Employees" (
	"ID" serial PRIMARY KEY,
	"full_name" varchar(100) NOT NULL,
	"job_titel_ID" integer NOT NULL,
	"overtime_hours" integer,
	"payment" date NOT NULL,
	"final_payment" integer NOT NULL,
	"salary_accounting_ID" integer NOT NULL UNIQUE
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
	PRIMARY KEY ("item_ID", "menu_item_ID")
);


--<<<<<<<<<<<<работа с заказами<<<<<<<<<<<<<<<<
--таблица заказов
CREATE TABLE IF NOT EXISTS "Orders" (
	"ID" serial PRIMARY KEY,
	"date" timestamp NOT NULL,
	"client_ID" integer,
	"employee_ID" integer NOT NULL,
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
	"type_ID" integer NOT NULL
);

--таблица видов трат
CREATE TABLE IF NOT EXISTS "Types_of_expenditure" (
	"ID" serial PRIMARY KEY,
	"name" varchar(10) NOT NULL
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
		REFERENCES "Clients"("ID");

--<<<<<<<<<связи для клиетнов
--один-к-одному
ALTER TABLE "Clients" 
	ADD CONSTRAINT "Clients_fk2" 
		FOREIGN KEY ("prgr_ID")
		REFERENCES "Loyalty_program_accounts"("ID")
		ON DELETE CASCADE;

--<<<<<<<<<связи для заказов
ALTER TABLE "Orders" 
	--многие-к-одному
	ADD CONSTRAINT "Order_fk1"
		FOREIGN KEY ("status_ID")
		REFERENCES "Order_statuses"("ID"),
	--многие-к-одному
	ADD CONSTRAINT "Order_fk2"
		FOREIGN KEY ("client_ID")
		REFERENCES "Order_statuses"("ID"),
	--многие-к-одному
	ADD CONSTRAINT "Order_fk3"
		FOREIGN KEY ("employee_ID")
		REFERENCES "Employees"("ID");

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



-- DO $$ DECLARE
--     r RECORD;
-- BEGIN
--     FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
--         EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
--     END LOOP;
-- END $$;

