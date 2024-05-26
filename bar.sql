--<<<<<<<<<<<<работа с клиентами<<<<<<<<<<<<<<<<<
--таблица клиентов
CREATE TABLE IF NOT EXISTS "Clients" (
	"ID" serial PRIMARY KEY, 
	"phone_number" text UNIQUE NOT NULL,
	"full_name" text NOT NULL,
	"prgr_ID" bigint UNIQUE
);

--таблицы аккаунтов программы лояльности
CREATE TABLE IF NOT EXISTS "Loyalty_program_accounts" (
	"ID" serial UNIQUE PRIMARY KEY,
	"money_spent" bigint NOT NULL,
	"client_ID" bigint NOT NULL UNIQUE,
	"lvl_ID" bigint NOT NULL
);

--таблица уровней программы лояльности 
CREATE TABLE IF NOT EXISTS "Loyalty_program_levels" (
	"ID" serial UNIQUE PRIMARY KEY,
	"name" text NOT NULL UNIQUE,
	"discount" bigint NOT NULL,
	"price" bigint NOT NULL
);

ALTER TABLE "Loyalty_program_accounts" 
	ADD CONSTRAINT "Loyalty_prgr_fk1" 
		FOREIGN KEY ("lvl_ID")
		REFERENCES "Loyalty_program_levels"("ID");
	
ALTER TABLE "Loyalty_program_accounts" 
	ADD CONSTRAINT "Loyalty_prgr_fk2" 
		FOREIGN KEY ("client_ID")
		REFERENCES "Clients"("ID");

ALTER TABLE "Clients" 
	ADD CONSTRAINT "Clients_fk2" 
		FOREIGN KEY ("prgr_ID")
		REFERENCES "Loyalty_program_accounts"("ID")
		ON DELETE CASCADE;
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- DO $$ DECLARE
--     r RECORD;
-- BEGIN
--     FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
--         EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
--     END LOOP;
-- END $$;

