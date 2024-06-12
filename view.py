from PyQt6.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QPushButton, QFormLayout, QLineEdit, \
    QLabel, QDateEdit
import sys


class View(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Restaurant Management System")
        self.setGeometry(100, 100, 800, 600)

        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)

        self.layout = QVBoxLayout(self.central_widget)

        self.menu_form = QFormLayout()
        self.layout.addLayout(self.menu_form)

        self.menu_name_input = QLineEdit()
        self.menu_price_input = QLineEdit()
        self.menu_manufacture_id_input = QLineEdit()
        self.menu_form.addRow("Name:", self.menu_name_input)
        self.menu_form.addRow("Price:", self.menu_price_input)
        self.menu_form.addRow("Manufacture ID:", self.menu_manufacture_id_input)

        self.add_menu_item_button = QPushButton("Add Menu Item")
        self.layout.addWidget(self.add_menu_item_button)

        self.result_label = QLabel()
        self.layout.addWidget(self.result_label)

    def display_message(self, message):
        self.result_label.setText(message)


def main():
    app = QApplication(sys.argv)
    view = View()
    view.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
