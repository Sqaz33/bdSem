from typing import Any

import psycopg2
from psycopg2 import sql


class Model:
    def __init__(self):
        self.conn = psycopg2.connect(
            dbname="postgres",
            user="postgres",
            password="1568",
            host="localhost",
            port="5432"
        )
        self.cur = self.conn.cursor()

    def insert_menu_item(self, name: str, price: int, manufacture_id: int) -> None:
        query = sql.SQL("INSERT INTO Menu_items (name, price, manufacture_id) VALUES (%s, %s, %s)")
        self.cur.execute(query, (name, price, manufacture_id))
        self.conn.commit()

    def insert_menu_item_composition(self, item_id: int, menu_item_id: int, quantity: int) -> None:
        query = sql.SQL(
            "INSERT INTO Menu_item_composition_container (item_ID, menu_item_ID, quantity) VALUES (%s, %s, %s)")
        self.cur.execute(query, (item_id, menu_item_id, quantity))
        self.conn.commit()

    def insert_storage_item(
            self, name: str,
            characteristics: str,
            volume: float,
            price: int,
            storage_condition_id: int,
            shell_life_in_days: int,
            supplier: str,
            item_type_id: int
    ) -> None:
        query = sql.SQL("""
            INSERT INTO Storage_items (name, characteristics, volume, price, storage_condition_id, shell_life_in_days, supplier, item_type_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """)
        self.cur.execute(query, (
            name, characteristics, volume, price, storage_condition_id, shell_life_in_days, supplier, item_type_id
        ))
        self.conn.commit()

    def insert_warehouse_space(self, name: str, capacity: float, storage_condition_id: int) -> None:
        query = sql.SQL("INSERT INTO Warehouse_spaces (name, capacity, storage_condition_id) VALUES (%s, %s, %s)")
        self.cur.execute(query, (name, capacity, storage_condition_id))
        self.conn.commit()

    def insert_item_in_warehouse(self, item_name: str, quantity_of_item: int) -> bool:
        if self.is_possibly_put_in_storage(item_name, quantity_of_item):
            query = sql.SQL("""
                CALL insert_in_warehouse(%s, %s)
            """)
            self.cur.execute(query, (item_name, quantity_of_item))
            self.cur.execute("CALL insert_in_expenses(%s, %s)", (item_name, quantity_of_item))
            self.conn.commit()
            return True
        return False

    def is_possibly_put_in_storage(self, item_name: str, quantity: int) -> bool:
        query = sql.SQL("SELECT is_possibly_put_in_storage(%s, %s)")
        self.cur(query, (item_name, quantity))
        return self.cur.fetchall()

    def insert_client(self, phone_number: str, full_name: str, prgr_id: int = None) -> None:
        query = sql.SQL("INSERT INTO Clients (phone_number, full_name, prgr_id) VALUES (%s, %s, %s)")
        self.cur.execute(query, (phone_number, full_name, prgr_id))
        self.conn.commit()

    def insert_loyalty_program_account(self, money_spent: int, client_id: int, lvl_id: int) -> None:
        query = sql.SQL("INSERT INTO Loyalty_program_accounts (money_spent, client_id, lvl_id) VALUES (%s, %s, %s)")
        self.cur.execute(query, (money_spent, client_id, lvl_id))
        self.conn.commit()

    def insert_employee(self, full_name: str, job_title_id: int, overtime_minutes: int, final_payment: int,
                        payment_date: str) -> None:
        query = sql.SQL("""
            INSERT INTO Employees (full_name, job_titel_ID, overtime_minutes, final_payment, payment_date)
            VALUES (%s, %s, %s, %s, %s)
        """)
        self.cur.execute(query, (full_name, job_title_id, overtime_minutes, final_payment, payment_date))
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

    def get_warehouse_inventory(self):
        self.cur.execute("""
                            SELECT 
                                si."name" "name",
                                iiw."quantity_of_item" "quantity",
                                ws."name" "storage_name"
                            FROM 
                                "Items_in_warehouse" iiw
                            JOIN "Storage_items" si
                                ON si."ID" = iiw."item_id"
                            JOIN "Warehouse_spaces" ws
                                ON ws."ID" = iiw."warehouse_place_id"
                        """)
        return self.cur.fetchall()

    def get_list_expired_products(self) -> list[Any]:
        self.cur.execute("SELECT get_list_expired_products()")
        return self.cur.fetchall()

    def get_list_not_expired_products(self) -> list[Any]:
        self.cur.execute("SELECT get_list_not_expired_products()")
        return self.cur.fetchall()

    def remove_expired_products(self):
        self.cur.execute("CALL remove_expired_products()")
        self.conn.commit()

    def process_payroll(self):
        self.cur.execute("UPDATE Employees SET final_payment = final_payment + overtime_minutes * 50")
        self.conn.commit()

    def get_orders_in_progress(self) -> list[int]:
        self.cur.execute("SELECT * FROM Orders WHERE status_ID IN (2, 3, 4)")
        return self.cur.fetchall()

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

    def get_profit(self, start_date: str, end_date: str) -> int:
        self.cur.execute("SELECT get_profit(%s, %s)", (start_date, end_date))
        return self.cur.fetchall()

    def get_income_when_price_items_warehouse_changes(self, start_date: str, end_date: str, item_id: int,
                                                      new_price: int) -> int:
        self.cur.execute(
            "select get_income_when_price_items_warehouse_changes(%s, %s, %s, %s)",
            (start_date, end_date, item_id, new_price)
        )
        return self.cur.fetchall()

    def pay_employee_salary(self) -> None:
        self.cur.execute("CALL pay_employee_salary()")

    def close(self):
        self.cur.close()
        self.conn.close()


if __name__ == "__main__":
    print(Model().get_list_expired_products())
