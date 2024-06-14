from typing import Any

import psycopg2
from psycopg2 import sql


class Model:
    def __init__(self):
        self.conn = psycopg2.connect(
            dbname="tst",
            user="postgres",
            password="1568",
            host="localhost",
            port="5432"
        )
        self.cur = self.conn.cursor()

    def get_clients(self) -> list[Any]:
        query = sql.SQL(
            """
            SELECT
                cl."full_name", 
                cl."phone_number",
                lpa."money_spent",
                lpl."name",
                cl."ID"
            FROM 
                "Clients" cl
            LEFT JOIN "Loyalty_program_accounts" lpa
                ON lpa."client_ID" = cl."ID"
            LEFT JOIN "Loyalty_program_levels" lpl 
                ON lpl."ID" = lpa."lvl_ID"
            ORDER BY 
                cl."ID"
            """
        )
        self.cur.execute(query)
        return self.cur.fetchall()

    def insert_client(self, phone_number: str, full_name: str) -> None:
        self.cur.execute(
            'INSERT INTO "Clients"("phone_number", "full_name") VALUES (%s, %s)',
            (phone_number, full_name)
        )
        self.conn.commit()

    def edit_client(self, cl_ID: int, phone_number: str, full_name: str) -> None:
        self.cur.execute(
            'UPDATE "Clients" SET "phone_number" = %s, "full_name" = %s WHERE "ID" = %s',
            (phone_number, full_name, cl_ID)
        )
        self.conn.commit()

    def delete_client(self, cl_ID: int) -> None:
        self.cur.execute(
            'DELETE FROM "Clients" WHERE "ID" = %s',
            (cl_ID,)
        )
        self.conn.commit()

    def update_client_lpa(self, client_ID: int):
        self.cur.execute(
            """
            WITH lpa_ID AS (
                SELECT 
                    "ID", "client_ID"
                FROM 
                    "Loyalty_program_accounts" 
                WHERE
                    "client_ID" = %s
            )
            UPDATE 
                "Clients" cl
            SET 
                "prgr_ID" = lpa_ID."ID"
            FROM 
                lpa_ID
            WHERE 
                cl."ID" = lpa_ID."client_ID"
            """,
            (client_ID,)
        )
        self.conn.commit()

    def is_exist_client(self, phone_number: str) -> bool:
        self.cur.execute("""SELECT EXISTS (
                            SELECT 1
                            FROM "Clients"
                            WHERE "phone_number" = %s
                        );""", (phone_number,))
        res = self.cur.fetchall()[0][0]
        return res

    def insert_loyalty_program_account(self, money_spent: int, client_id: int, lvl_id: int) -> None:
        query = sql.SQL(
            'INSERT INTO "Loyalty_program_accounts" ("money_spent", "client_ID", "lvl_ID") VALUES (%s, %s, %s)'
        )
        self.cur.execute(query, (money_spent, client_id, lvl_id))
        self.conn.commit()

    def insert_order(self, date: str, client_id: int, employee_id: int, status_id: int, total: int) -> None:
        query = sql.SQL(
            'INSERT INTO "Orders" ("date", "client_ID", "employee_ID", "status_ID", "total") VALUES (%s, %s, %s, %s, %s)')
        self.cur.execute(query, (date, client_id, employee_id, status_id, total))
        self.conn.commit()

    def delete_order(self, order_id: int) -> None:
        self.cur.execute(
            'DELETE FROM "Orders" WHERE "ID" = %s',
            (order_id,)
        )
        self.conn.commit()

    def update_order(self, order_id: int, client_id: int, employee_id: int, status_id: int) -> None:
        self.cur.execute(
            """
                UPDATE 
                    "Orders"
                SET
                    "client_ID" = %s,
                    "employee_ID" = %s,
                    "status_ID" = %s
                WHERE
                    "ID" = %s
            """,
            (client_id, employee_id, status_id, order_id)
        )
        self.conn.commit()

    def add_to_order_cost(self, order_id: int, item_id: int) -> None:
        self.cur.execute(
            """
            WITH item AS (
                SELECT "price" pr
                FROM "Menu_items" 
                WHERE "ID" = %s
            )
            UPDATE "Orders" o
            SET "total" = "total" + item.pr
            FROM item
            WHERE o."ID" = %s
            """,
            (item_id, order_id)
        )
        self.conn.commit()

    def get_menu_items_from_order(self, order_id: int) -> list[Any]:
        self.cur.execute(
            """
                SELECT
                    mi."name",
                    mi."price",
                    ol."quantity",
                    ol."order_ID",
                    ol."menu_item_ID"
                FROM 
                    "Order_line" ol
                JOIN "Menu_items" mi
                    ON mi."ID" = ol."menu_item_ID"
                WHERE
                    ol."order_ID" = %s
                """,
            (order_id,)
        )
        return self.cur.fetchall()

    def delete_menu_item_from_order(self, order_id: int, menu_item_id: int) -> None:
        self.cur.execute(
            'DELETE FROM "Order_line" WHERE "menu_item_ID" = %s AND "order_ID" = %s',
            (menu_item_id, order_id)
        )
        self.conn.commit()

    def insert_order_line(self, order_id: int, menu_item_id: int, quantity: int) -> None:
        query = sql.SQL('INSERT INTO "Order_line" ("order_ID", "menu_item_ID", "quantity") VALUES (%s, %s, %s)')
        self.cur.execute(query, (order_id, menu_item_id, quantity))
        self.conn.commit()

    def update_order_line(self, order_id: int, menu_item_id: int, quantity: int) -> None:
        self.cur.execute(
            'UPDATE "Order_line" SET "quantity" = %s WHERE "order_ID" = %s AND "menu_item_ID" = %s',
            (quantity, order_id, menu_item_id)
        )
        self.conn.commit()

    def get_most_popular_menu_item(self) -> int:
        self.cur.execute("""
                        SELECT mi."name", COUNT(*) as order_count
                        FROM "Order_line" ol
                        JOIN "Menu_items" mi
                            ON mi."ID" = ol."menu_item_ID"
                        GROUP BY ol."menu_item_ID", mi."name"
                        ORDER BY order_count DESC
                        LIMIT 1 
                        """)
        return self.cur.fetchone()

    def get_employees(self) -> list[Any]:
        self.cur.execute("""
                        SELECT 
                            e."full_name",
                            jt."name",
                            e."ID"
                        FROM
                            "Employees" e
                        LEFT JOIN "Job_titles" jt
                            ON jt."ID" = e."job_titel_ID"
                        ORDER BY 
                        e."ID"
        """)
        return self.cur.fetchall()

    def get_order_statuses(self) -> list[Any]:
        self.cur.execute(
            'SELECT "name", "ID" FROM "Order_statuses" ORDER BY "ID"'
        )
        return self.cur.fetchall()

    def get_menu_items(self) -> list[Any]:
        self.cur.execute(
            'SELECT "name", "price", "ID" FROM "Menu_items"'
        )
        return self.cur.fetchall()

    def get_orders(self) -> list[Any]:
        self.cur.execute(
            """
            SELECT 
                o."date",
                cl."full_name",
                o."total",
                os."name",
                e."full_name",
                o."ID"
            FROM 
                "Orders" o
            LEFT JOIN "Clients" cl
                ON cl."ID" = o."client_ID"
            LEFT JOIN "Order_statuses" os
                ON os."ID" = o."status_ID"
            LEFT JOIN "Employees" e
                ON e."ID" = o."employee_ID"
            ORDER BY
                o."ID"
            """)
        return self.cur.fetchall()

    def get_attendance(self, start_date: str, end_date: str) -> int:
        self.cur.execute("SELECT get_expenses(%s, %s)", (start_date, end_date))
        return self.cur.fetchall()

    def get_income(self, start_date: str, end_date: str) -> int:
        self.cur.execute("SELECT get_income(%s, %s)", (start_date, end_date))
        return self.cur.fetchall()

    def get_profit(self, start_date: str, end_date: str) -> int:
        self.cur.execute("SELECT get_profit(%s, %s)", (start_date, end_date))
        return self.cur.fetchall()

    def get_client_id_by_phone(self, phone_number: str) -> int:
        self.cur.execute(
            'SELECT cl."ID" FROM "Clients" cl WHERE cl."phone_number" = %s',
            (phone_number,)
        )
        res = self.cur.fetchall()
        if len(res):
            return res[0][0]
        return -1

    def close(self):
        self.cur.close()
        self.conn.close()


if __name__ == "__main__":
    res = Model().get_client_id_by_phone("2asl;oikdjihfa;sldkfjal;skj");

    mod = Model()

    print(mod.get_clients()[-1])
