from controller import Controller
import sys
from PyQt6.QtWidgets import QApplication

if __name__ == "__main__":
    app = QApplication(sys.argv)

    controller = Controller()
    controller.view.show()

    sys.exit(app.exec())


