from typing import Any

from PyQt6.QtCore import QObject, QDate
from PyQt6.QtWidgets import QTableWidgetItem

from datetime import datetime

from model import Model
from view import View


class Controller(QObject):
    def __init__(self):
        super().__init__()
        self.model = Model()
        self.view = View()

        self.cur_client_id = -1
        self.cur_order_client_id = -1

        self.cur_order_id = -1
        self.cur_menu_item_to_order_id = -1
        self.cur_menu_item_from_order_id = -1

        self.cur_status_id = 1
        self.cur_employee_id = 1

        self.cur_calculation = 0

        self.clients = self.model.get_clients()
        self.orders = self.model.get_orders()
        if len(self.clients):
            self.cur_client_id = self.clients[-1][4]
        if len(self.orders):
            self.cur_order_id = self.orders[-1][5]

        self.menu_items = self.model.get_menu_items()
        self.statuses = self.model.get_order_statuses()
        self.employees = self.model.get_employees()

        self.view.form.stackedWidget.setCurrentIndex(0)

        self.view.form.page_name_CB.currentIndexChanged.connect(self.page_name_CB_index_change)

        self.view.form.clients_table.currentItemChanged.connect(self.cur_client_index_change)
        self.view.form.add_client_button.clicked.connect(self.add_client)
        self.view.form.change_client_button.clicked.connect(self.edit_client)
        self.view.form.delete_client_button.clicked.connect(self.delete_client)

        self.view.form.orders_table.currentItemChanged.connect(self.cur_order_index_change)
        self.view.form.clients_table_for_order.currentItemChanged.connect(self.cur_client_for_order_index_change)
        self.view.form.orders_statuse_table.currentItemChanged.connect(self.cur_orders_statuses_index_change)
        self.view.form.employee_table_for_order.currentItemChanged.connect(self.cur_employee_index_change)
        self.view.form.menu_items_table_to_order.currentItemChanged.connect(self.cur_menu_item_to_order_index_change)
        self.view.form.menu_item_from_order_table.currentItemChanged.connect(self.cur_menu_item_from_order_index_change)
        # buttons for orders
        self.view.form.add_order_button.clicked.connect(self.add_order)
        self.view.form.delete_order_button.clicked.connect(self.delete_order)
        self.view.form.change_order_status_button.clicked.connect(self.edit_order)
        self.view.form.add_menu_item_to_order_button.clicked.connect(self.add_menu_item_to_order)
        self.view.form.del_menu_item_from_order_button.clicked.connect(self.delete_menu_item_from_order)

        self.view.form.comboBox.currentIndexChanged.connect(self.calculate_change)
        self.view.form.start_DE_1.dateChanged.connect(self.calculate_money)
        self.view.form.end_DE_1.dateChanged.connect(self.calculate_money)

        self.view.form.compute_most_popular_button.clicked.connect(self.calculate_most_popular_menu_item)

        self.fill_clients_table(self.view.form.clients_table)

    def page_name_CB_index_change(self, new_index: int):
        self.view.form.stackedWidget.setCurrentIndex(new_index)
        
        match new_index:
            case 0:
                self.fill_clients_table(self.view.form.clients_table)
            case 1:
                self.fill_clients_table(self.view.form.clients_table_for_order)
                self.fill_orders_table()
                self.fill_employees_table()
                self.fill_menu_items_to_order_table()
                self.fill_statuses_table()

        if len(self.clients):
            self.cur_order_client_id = self.cur_client_id = self.clients[-1][4]

    def fill_clients_table(self, client_table):
        client_table.setRowCount(len(self.clients))
        i = 0
        for rec in self.clients:
            client_table.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            client_table.setItem(
                i, 1, QTableWidgetItem(str(rec[1]))
            )
            client_table.setItem(
                i, 2, QTableWidgetItem(str(rec[2]))
            )
            client_table.setItem(
                i, 3, QTableWidgetItem(str(rec[3]))
            )
            i += 1

    def cur_client_index_change(self, current, previous):
        if current is not None:
            new_cur = current.row()
            self.set_cur_client(new_cur)

    def set_cur_client(self, new_cur: int):
        self.cur_client_id = self.clients[new_cur][4]
        self.view.form.clients_full_name_LE.setText(str(self.clients[new_cur][0]))
        self.view.form.cliens_phone_LE.setText(str(self.clients[new_cur][1]))

    def add_client(self):
        full_name = self.view.form.clients_full_name_LE.text()
        phone_number = self.view.form.cliens_phone_LE.text()

        if len(phone_number) > 20:
            return

        if not self.model.is_exist_client(phone_number):
            self.model.insert_client(phone_number, full_name)
            self.cur_client_id = self.model.get_client_id_by_phone(phone_number)
            self.model.insert_loyalty_program_account(0, self.cur_client_id, 1)
            self.model.update_client_lpa(self.cur_client_id)
            self.clients = self.model.get_clients()
            self.fill_clients_table(self.view.form.clients_table)

    def edit_client(self):
        full_name = self.view.form.clients_full_name_LE.text()
        phone_number = self.view.form.cliens_phone_LE.text()

        if len(phone_number) > 20:
            return

        cl_by_phone = self.model.get_client_id_by_phone(phone_number)
        if cl_by_phone == self.cur_client_id or cl_by_phone == -1:
            self.model.edit_client(self.cur_client_id, phone_number, full_name)
            self.clients = self.model.get_clients()
            self.fill_clients_table(self.view.form.clients_table)

    def delete_client(self):
        if self.cur_client_id < 0:
            return
        self.model.delete_client(self.cur_client_id)
        if len(self.clients) == 1:
            self.cur_client_id = -1
        else:
            cur_cl_ind = 0
            for i in range(0, len(self.clients)):
                if self.clients[i][4] == self.cur_client_id:
                    cur_cl_ind = i
                    break
            self.cur_order_client_id = self.cur_client_id = self.clients[max(0, cur_cl_ind - 1)][4]
            self.set_cur_client(cur_cl_ind)
        self.clients = self.model.get_clients()
        self.fill_clients_table(self.view.form.clients_table)

    def fill_orders_table(self):
        self.view.form.orders_table.setRowCount(len(self.orders))
        i = 0
        orders_table = self.view.form.orders_table
        for rec in self.orders:
            orders_table.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            orders_table.setItem(
                i, 1, QTableWidgetItem(str(rec[1]))
            )
            orders_table.setItem(
                i, 2, QTableWidgetItem(str(rec[2]))
            )
            orders_table.setItem(
                i, 3, QTableWidgetItem(str(rec[3]))
            )
            orders_table.setItem(
                i, 4, QTableWidgetItem(str(rec[4]))
            )
            i += 1

    def fill_employees_table(self):
        self.view.form.employee_table_for_order.setRowCount(len(self.employees))
        i = 0
        employees_table = self.view.form.employee_table_for_order
        for rec in self.employees:
            employees_table.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            employees_table.setItem(
                i, 1, QTableWidgetItem(str(rec[1]))
            )
            i += 1

    def fill_menu_items_to_order_table(self):
        self.view.form.menu_items_table_to_order.setRowCount(len(self.menu_items))
        i = 0
        menu_items_table = self.view.form.menu_items_table_to_order
        for rec in self.menu_items:
            menu_items_table.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            menu_items_table.setItem(
                i, 1, QTableWidgetItem(str(rec[1]))
            )
            i += 1

    def fill_menu_items_from_order_table(self, items: list[Any]):
        self.view.form.menu_item_from_order_table.setRowCount(len(items))
        i = 0
        menu_items = self.view.form.menu_item_from_order_table
        for rec in items:
            menu_items.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            menu_items.setItem(
                i, 1, QTableWidgetItem(str(rec[1]))
            )
            menu_items.setItem(
                i, 2, QTableWidgetItem(str(rec[2]))
            )
            i += 1

    def fill_statuses_table(self):
        self.view.form.orders_statuse_table.setRowCount(len(self.statuses))
        i = 0
        orders_statuses_table = self.view.form.orders_statuse_table
        for rec in self.statuses:
            orders_statuses_table.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            i += 1

    def cur_order_index_change(self, current, previous):
        if current is not None:
            new_cur = current.row()
            self.set_cur_order(new_cur)

    def set_cur_order(self, new_cur: int):
        if new_cur < 0:
            return
        self.cur_order_id = self.orders[new_cur][5]
        items = self.model.get_menu_items_from_order(self.cur_order_id)
        self.fill_menu_items_from_order_table(items)

    def cur_client_for_order_index_change(self, current, previous):
        if current is not None:
            self.cur_order_client_id = self.clients[current.row()][4]

    def cur_employee_index_change(self, current, previous):
        if current is not None:
            self.cur_employee_id = self.employees[current.row()][2]

    def cur_menu_item_to_order_index_change(self, current, previous):
        if current is not None:
            self.cur_menu_item_to_order_id = self.menu_items[current.row()][2]

    def cur_menu_item_from_order_index_change(self, current, previous):
        if current is not None:
            self.cur_menu_item_from_order_id = self.model.get_menu_items_from_order(self.cur_order_id)[current.row()][4]

    def cur_orders_statuses_index_change(self, current, previous):
        if current is not None:
            self.cur_menu_item_from_order_id = 1
            self.cur_status_id = self.statuses[current.row()][1]

    def add_order(self):
        if self.cur_order_id < 0 or self.cur_client_id < 0:
            return
        self.model.insert_order(
            datetime.now().strftime("%Y-%m-%d"),
            self.cur_order_client_id,
            self.cur_employee_id,
            self.cur_status_id,
            0
        )
        self.orders = self.model.get_orders()
        self.set_cur_order(-1)
        self.fill_orders_table()

    def delete_order(self):
        if self.cur_order_id < 0:
            return
        self.model.delete_order(self.cur_order_id)
        if len(self.orders) == 1:
            self.cur_order_id = -1
        else:
            cur_ord_ind = 0
            for i in range(0, len(self.orders)):
                if self.orders[i][5] == self.cur_order_id:
                    cur_ord_ind = i
                    break
            self.cur_order_id = self.orders[max(0, cur_ord_ind - 1)][5]
            self.set_cur_order(cur_ord_ind)

        self.orders = self.model.get_orders()
        self.fill_orders_table()

    def edit_order(self):
        if self.cur_order_id < 0 or self.cur_order_client_id < 0:
            return
        self.model.update_order(
            self.cur_order_id,
            self.cur_order_client_id,
            self.cur_employee_id,
            self.cur_status_id
        )
        self.orders = self.model.get_orders()
        self.fill_orders_table()

    def add_menu_item_to_order(self):
        if self.cur_menu_item_to_order_id < 0 or self.cur_order_id < 0:
            return

        order_lines = self.model.get_menu_items_from_order(self.cur_order_id)
        quantity = -1
        for ol in order_lines:
            if ol[3] == self.cur_order_id and ol[4] == self.cur_menu_item_to_order_id:
                quantity = ol[2]
                break

        if quantity < 0:
            self.model.insert_order_line(self.cur_order_id, self.cur_menu_item_to_order_id, 1)
        else:
            self.model.update_order_line(self.cur_order_id, self.cur_menu_item_to_order_id, quantity + 1)

        items = self.model.get_menu_items_from_order(self.cur_order_id)
        self.fill_menu_items_from_order_table(items)

    def delete_menu_item_from_order(self):
        if self.cur_order_id < 0 or self.cur_menu_item_from_order_id < 0:
            return
        items_from = self.model.get_menu_items_from_order(self.cur_order_id)
        self.model.delete_menu_item_from_order(self.cur_order_id, self.cur_menu_item_from_order_id)
        if len(items_from) == 1:
            self.cur_menu_item_from_order_id = -1
            self.fill_menu_items_from_order_table([])
        else:
            cur_item_ind = 0
            for i in range(0, len(items_from)):
                if items_from[i][4] == self.cur_menu_item_from_order_id:
                    cur_item_ind = i
                    break
            self.cur_menu_item_from_order_id = items_from[max(0, cur_item_ind - 1)][4]
            items_from = self.model.get_menu_items_from_order(self.cur_order_id)
            self.fill_menu_items_from_order_table(items_from)

    def calculate_change(self):
        self.cur_calculation = self.view.form.comboBox.currentIndex()

    def calculate_money(self):
        start = (self.view.form.start_DE_1.date()
                 .toString("yyyy-MM-dd"))
        end = (self.view.form.end_DE_1.date()
               .toString("yyyy-MM-dd"))
        money = 0
        match self.cur_calculation:
            case 0:
                money = self.model.get_attendance(start, end)
            case 1:
                money = self.model.get_income(start, end)
            case 2:
                money = self.model.get_profit(start, end)
        if money:
            money = money[0][0]
        else:
            money = 0

        self.view.form.res_label_1.setText(f'Результат: {money}')

    def calculate_most_popular_menu_item(self):
        most_popular = self.model.get_most_popular_menu_item()
        self.view.form.most_popular_label.setText(
            f'Самый популярный пункт меню: {most_popular}'
        )

if __name__ == "__main__":
    import sys
    from PyQt6.QtWidgets import QApplication

    app = QApplication(sys.argv)

    controller = Controller()
    controller.view.show()
    sys.exit(app.exec())
