from PyQt6.QtWidgets import (
    QApplication,
    QMainWindow,
    QVBoxLayout,
    QWidget,
    QPushButton,
    QFormLayout,
    QLineEdit,
    QLabel,
    QDateEdit,
)

import sys

from form import Ui_Form


class View(QMainWindow):
    def __init__(self):
        super().__init__()
        self.WT = QWidget()
        self.form = Ui_Form()
        self.form.setupUi(self.WT)

    def show(self):
        self.WT.show()


def main():
    app = QApplication(sys.argv)
    view = View()
    view.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
