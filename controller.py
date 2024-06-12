from PyQt6.QtCore import QObject
from model import Model
from view import View


class Controller(QObject):
    def __init__(self):
        super().__init__()
        self.model = Model()
        self.view = View()

        self.view.add_menu_item_button.clicked.connect(self.add_menu_item)

    def add_menu_item(self):
        name = self.view.menu_name_input.text()
        price = int(self.view.menu_price_input.text())
        manufacture_id = int(self.view.menu_manufacture_id_input.text())

        self.model.insert_menu_item(name, price, manufacture_id)
        self.view.display_message("Menu item added successfully!")


if __name__ == "__main__":
    import sys
    from PyQt6.QtWidgets import QApplication

    app = QApplication(sys.argv)

    controller = Controller()
    controller.view.show()

    sys.exit(app.exec())
