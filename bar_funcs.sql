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
RETURNS TABLE(item_id integer, quantity_of_item integer, days_until_end_storage integer)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT "item_id", "quantity_of_item", "days_until_end_storage"
    FROM "Items_in_warehouse"
    WHERE "days_until_end_storage" <= 0;
END;
$$;


--6. Выдача списка не просроченных продуктов
CREATE OR REPLACE FUNCTION get_list_not_expired_products()
RETURNS TABLE(item_id integer, quantity_of_item integer, days_until_end_storage integer)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT "item_id", "quantity_of_item", "days_until_end_storage"
    FROM "Items_in_warehouse"
    WHERE "days_until_end_storage" > 0;
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
