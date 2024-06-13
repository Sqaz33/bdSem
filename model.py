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
                lpl."name"
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
            (phone_number, )
        )

    def update_client_lpa(self, client_ID: int, lpa_ID):
        pass

    def is_exist_client(self, phone_number: str) -> bool:
        self.cur.execute("""SELECT EXISTS (
                            SELECT 1
                            FROM "Clients"
                            WHERE "phone_number" = %s
                        );""", (phone_number, ))
        res = self.cur.fetchall()[0][0]
        return res

    def insert_loyalty_program_account(self, money_spent: int, client_id: int, lvl_id: int) -> None:
        query = sql.SQL("INSERT INTO Loyalty_program_accounts (money_spent, client_id, lvl_id) VALUES (%s, %s, %s)")
        self.cur.execute(query, (money_spent, client_id, lvl_id))
        self.conn.commit()

    def insert_order(self, date: str, client_id: int, employee_id: int, status_id: int, total: int) -> None:
        query = sql.SQL(
            "INSERT INTO Orders (date, client_id, employee_id, status_id, total) VALUES (%s, %s, %s, %s, %s)")
        self.cur.execute(query, (date, client_id, employee_id, status_id, total))
        self.conn.commit()

    def insert_order_line(self, order_id: int, menu_item_id: int, quantity: int) -> None:
        query = sql.SQL("INSERT INTO Order_line (order_ID, menu_item_ID, quantity) VALUES (%s, %s, %s)")
        self.cur.execute(query, (order_id, menu_item_id, quantity))
        self.conn.commit()

    def get_most_popular_menu_item(self) -> int:
        self.cur.execute("""
            SELECT "menu_item_ID", COUNT(*) as order_count
            FROM "Order_line"
            GROUP BY "menu_item_ID"
            ORDER BY order_count DESC
            LIMIT 1
        """)
        return self.cur.fetchone()

    def get_attendance(self, start_date: str, end_date: str) -> int:
        self.cur.execute("SELECT get_expenses(%s, %s)", (start_date, end_date))
        return self.cur.fetchall()

    def get_income(self, start_date: str, end_date: str) -> int:
        self.cur.execute("SELECT get_income(%s, %s)", (start_date, end_date))
        return self.cur.fetchall()

    def close(self):
        self.cur.close()
        self.conn.close()


if __name__ == "__main__":
    mod = Model()
    mod.insert_client("123asd41ssdfs", "sdf1")
    
    print(mod.get_clients()[-1])
