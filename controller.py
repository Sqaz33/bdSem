from PyQt6.QtCore import QObject
from PyQt6.QtWidgets import QTableWidgetItem
from model import Model
from view import View


class Controller(QObject):
    def __init__(self):
        super().__init__()
        self.model = Model()
        self.view = View()

        self.curClient = -1
        self.orderClient = -1
        self.clients = []

        self.view.form.stackedWidget.setCurrentIndex(0)

        self.view.form.page_name_CB.currentIndexChanged.connect(self.page_name_CB_index_change)

        self.view.form.clients_table.currentItemChanged.connect(self.set_cur_client)
        self.view.form.add_client_button.clicked.connect(self.add_client)
        self.view.form.change_client_button.clicked.connect(self.edit_client)

        self.clients = self.model.get_clients()
        self.curClient = len(self.clients) - 1
        self.fill_clients_table()

    def page_name_CB_index_change(self, new_index: int):
        self.view.form.stackedWidget.setCurrentIndex(new_index)
        self.fill_clients_table()

    def fill_clients_table(self):
        self.view.form.clients_table.setRowCount(len(self.clients))
        i = 0
        for rec in self.clients:
            self.view.form.clients_table.setItem(
                i, 0, QTableWidgetItem(str(rec[0]))
            )
            self.view.form.clients_table.setItem(
                i, 1, QTableWidgetItem(str(rec[1]))
            )
            self.view.form.clients_table.setItem(
                i, 2, QTableWidgetItem(str(rec[2]))
            )
            self.view.form.clients_table.setItem(
                i, 3, QTableWidgetItem(str(rec[3]))
            )
            i += 1

    def set_cur_client(self, current, previous):
        new_cur = current.row()
        self.curClient = new_cur
        self.view.form.clients_full_name_LE.setText(str(self.clients[new_cur][0]))
        self.view.form.cliens_phone_LE.setText(str(self.clients[new_cur][1]))

    def add_client(self):
        full_name = self.view.form.clients_full_name_LE.text()
        phone_number = self.view.form.cliens_phone_LE.text()
        if len(phone_number) > 20:
             return
         
        if not self.model.is_exist_client(phone_number):
            self.model.insert_client(phone_number, full_name)
            self.clients = self.model.get_clients()
            self.curClient = len(self.clients) - 1
        self.fill_clients_table()

    def edit_client(self):
        full_name = self.view.form.clients_full_name_LE.text()
        phone_number = self.view.form.cliens_phone_LE.text()
        if len(phone_number) > 20:
            return
        if not self.model.is_exist_client(phone_number):
            pass
        
if __name__ == "__main__":
    import sys
    from PyQt6.QtWidgets import QApplication

    app = QApplication(sys.argv)

    controller = Controller()
    controller.view.show()

    sys.exit(app.exec())
