# Form implementation generated from reading ui file 'form.ui'
#
# Created by: PyQt6 UI code generator 6.7.0
#
# WARNING: Any manual changes made to this file will be lost when pyuic6 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt6 import QtCore, QtGui, QtWidgets


class Ui_Form(object):
    def setupUi(self, Form):
        Form.setObjectName("Form")
        Form.resize(1180, 883)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Policy.Expanding, QtWidgets.QSizePolicy.Policy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(Form.sizePolicy().hasHeightForWidth())
        Form.setSizePolicy(sizePolicy)
        self.verticalLayout = QtWidgets.QVBoxLayout(Form)
        self.verticalLayout.setObjectName("verticalLayout")
        self.page_name_CB = QtWidgets.QComboBox(parent=Form)
        self.page_name_CB.setObjectName("page_name_CB")
        self.page_name_CB.addItem("")
        self.page_name_CB.addItem("")
        self.page_name_CB.addItem("")
        self.page_name_CB.addItem("")
        self.verticalLayout.addWidget(self.page_name_CB)
        self.stackedWidget = QtWidgets.QStackedWidget(parent=Form)
        self.stackedWidget.setObjectName("stackedWidget")
        self.page_1 = QtWidgets.QWidget()
        self.page_1.setObjectName("page_1")
        self.horizontalLayoutWidget = QtWidgets.QWidget(parent=self.page_1)
        self.horizontalLayoutWidget.setGeometry(QtCore.QRect(9, 19, 1151, 811))
        self.horizontalLayoutWidget.setObjectName("horizontalLayoutWidget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.clients_table = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget)
        self.clients_table.setObjectName("clients_table")
        self.clients_table.setColumnCount(4)
        self.clients_table.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table.setHorizontalHeaderItem(1, item)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table.setHorizontalHeaderItem(2, item)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table.setHorizontalHeaderItem(3, item)
        self.horizontalLayout.addWidget(self.clients_table)
        self.verticalLayout_2 = QtWidgets.QVBoxLayout()
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.clients_full_name_LE = QtWidgets.QLineEdit(parent=self.horizontalLayoutWidget)
        self.clients_full_name_LE.setObjectName("clients_full_name_LE")
        self.verticalLayout_2.addWidget(self.clients_full_name_LE)
        self.cliens_phone_LE = QtWidgets.QLineEdit(parent=self.horizontalLayoutWidget)
        self.cliens_phone_LE.setObjectName("cliens_phone_LE")
        self.verticalLayout_2.addWidget(self.cliens_phone_LE)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.add_client_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget)
        self.add_client_button.setObjectName("add_client_button")
        self.horizontalLayout_3.addWidget(self.add_client_button)
        self.change_client_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget)
        self.change_client_button.setObjectName("change_client_button")
        self.horizontalLayout_3.addWidget(self.change_client_button)
        self.delete_client_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget)
        self.delete_client_button.setObjectName("delete_client_button")
        self.horizontalLayout_3.addWidget(self.delete_client_button)
        self.verticalLayout_2.addLayout(self.horizontalLayout_3)
        self.horizontalLayout.addLayout(self.verticalLayout_2)
        self.stackedWidget.addWidget(self.page_1)
        self.page_2 = QtWidgets.QWidget()
        self.page_2.setObjectName("page_2")
        self.horizontalLayoutWidget_3 = QtWidgets.QWidget(parent=self.page_2)
        self.horizontalLayoutWidget_3.setGeometry(QtCore.QRect(9, 9, 1151, 831))
        self.horizontalLayoutWidget_3.setObjectName("horizontalLayoutWidget_3")
        self.horizontalLayout_4 = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget_3)
        self.horizontalLayout_4.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_4.setObjectName("horizontalLayout_4")
        self.orders_table = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget_3)
        self.orders_table.setObjectName("orders_table")
        self.orders_table.setColumnCount(5)
        self.orders_table.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.orders_table.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.orders_table.setHorizontalHeaderItem(1, item)
        item = QtWidgets.QTableWidgetItem()
        self.orders_table.setHorizontalHeaderItem(2, item)
        item = QtWidgets.QTableWidgetItem()
        self.orders_table.setHorizontalHeaderItem(3, item)
        item = QtWidgets.QTableWidgetItem()
        self.orders_table.setHorizontalHeaderItem(4, item)
        self.horizontalLayout_4.addWidget(self.orders_table)
        self.verticalLayout_4 = QtWidgets.QVBoxLayout()
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.clients_table_for_order = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget_3)
        self.clients_table_for_order.setObjectName("clients_table_for_order")
        self.clients_table_for_order.setColumnCount(4)
        self.clients_table_for_order.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table_for_order.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table_for_order.setHorizontalHeaderItem(1, item)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table_for_order.setHorizontalHeaderItem(2, item)
        item = QtWidgets.QTableWidgetItem()
        self.clients_table_for_order.setHorizontalHeaderItem(3, item)
        self.verticalLayout_4.addWidget(self.clients_table_for_order)
        self.employee_table_for_order = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget_3)
        self.employee_table_for_order.setObjectName("employee_table_for_order")
        self.employee_table_for_order.setColumnCount(2)
        self.employee_table_for_order.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.employee_table_for_order.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.employee_table_for_order.setHorizontalHeaderItem(1, item)
        self.verticalLayout_4.addWidget(self.employee_table_for_order)
        self.add_order_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget_3)
        self.add_order_button.setObjectName("add_order_button")
        self.verticalLayout_4.addWidget(self.add_order_button)
        self.delete_order_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget_3)
        self.delete_order_button.setObjectName("delete_order_button")
        self.verticalLayout_4.addWidget(self.delete_order_button)
        self.horizontalLayout_6 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_6.setObjectName("horizontalLayout_6")
        self.menu_items_table_to_order = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget_3)
        self.menu_items_table_to_order.setObjectName("menu_items_table_to_order")
        self.menu_items_table_to_order.setColumnCount(2)
        self.menu_items_table_to_order.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.menu_items_table_to_order.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.menu_items_table_to_order.setHorizontalHeaderItem(1, item)
        self.horizontalLayout_6.addWidget(self.menu_items_table_to_order)
        self.menu_item_from_order_table = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget_3)
        self.menu_item_from_order_table.setObjectName("menu_item_from_order_table")
        self.menu_item_from_order_table.setColumnCount(2)
        self.menu_item_from_order_table.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.menu_item_from_order_table.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.menu_item_from_order_table.setHorizontalHeaderItem(1, item)
        self.horizontalLayout_6.addWidget(self.menu_item_from_order_table)
        self.verticalLayout_4.addLayout(self.horizontalLayout_6)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.label_4 = QtWidgets.QLabel(parent=self.horizontalLayoutWidget_3)
        self.label_4.setObjectName("label_4")
        self.horizontalLayout_2.addWidget(self.label_4)
        self.label_3 = QtWidgets.QLabel(parent=self.horizontalLayoutWidget_3)
        self.label_3.setObjectName("label_3")
        self.horizontalLayout_2.addWidget(self.label_3)
        self.verticalLayout_4.addLayout(self.horizontalLayout_2)
        self.add_menu_item_to_order_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget_3)
        self.add_menu_item_to_order_button.setObjectName("add_menu_item_to_order_button")
        self.verticalLayout_4.addWidget(self.add_menu_item_to_order_button)
        self.del_menu_item_from_order_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget_3)
        self.del_menu_item_from_order_button.setObjectName("del_menu_item_from_order_button")
        self.verticalLayout_4.addWidget(self.del_menu_item_from_order_button)
        self.orders_statuse_table = QtWidgets.QTableWidget(parent=self.horizontalLayoutWidget_3)
        self.orders_statuse_table.setObjectName("orders_statuse_table")
        self.orders_statuse_table.setColumnCount(1)
        self.orders_statuse_table.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.orders_statuse_table.setHorizontalHeaderItem(0, item)
        self.verticalLayout_4.addWidget(self.orders_statuse_table)
        self.change_order_status_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget_3)
        self.change_order_status_button.setObjectName("change_order_status_button")
        self.verticalLayout_4.addWidget(self.change_order_status_button)
        self.horizontalLayout_4.addLayout(self.verticalLayout_4)
        self.stackedWidget.addWidget(self.page_2)
        self.page = QtWidgets.QWidget()
        self.page.setObjectName("page")
        self.verticalLayoutWidget_4 = QtWidgets.QWidget(parent=self.page)
        self.verticalLayoutWidget_4.setGeometry(QtCore.QRect(9, 9, 1151, 821))
        self.verticalLayoutWidget_4.setObjectName("verticalLayoutWidget_4")
        self.verticalLayout_5 = QtWidgets.QVBoxLayout(self.verticalLayoutWidget_4)
        self.verticalLayout_5.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_5.setObjectName("verticalLayout_5")
        self.comboBox = QtWidgets.QComboBox(parent=self.verticalLayoutWidget_4)
        self.comboBox.setObjectName("comboBox")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.verticalLayout_5.addWidget(self.comboBox)
        self.horizontalLayout_5 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_5.setObjectName("horizontalLayout_5")
        self.label = QtWidgets.QLabel(parent=self.verticalLayoutWidget_4)
        self.label.setObjectName("label")
        self.horizontalLayout_5.addWidget(self.label)
        self.start_DE_1 = QtWidgets.QDateEdit(parent=self.verticalLayoutWidget_4)
        self.start_DE_1.setObjectName("start_DE_1")
        self.horizontalLayout_5.addWidget(self.start_DE_1)
        self.verticalLayout_5.addLayout(self.horizontalLayout_5)
        self.horizontalLayout_7 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_7.setObjectName("horizontalLayout_7")
        self.label_2 = QtWidgets.QLabel(parent=self.verticalLayoutWidget_4)
        self.label_2.setObjectName("label_2")
        self.horizontalLayout_7.addWidget(self.label_2)
        self.end_DE_1 = QtWidgets.QDateEdit(parent=self.verticalLayoutWidget_4)
        self.end_DE_1.setObjectName("end_DE_1")
        self.horizontalLayout_7.addWidget(self.end_DE_1)
        self.verticalLayout_5.addLayout(self.horizontalLayout_7)
        self.res_label_1 = QtWidgets.QLabel(parent=self.verticalLayoutWidget_4)
        self.res_label_1.setObjectName("res_label_1")
        self.verticalLayout_5.addWidget(self.res_label_1)
        self.stackedWidget.addWidget(self.page)
        self.page_3 = QtWidgets.QWidget()
        self.page_3.setObjectName("page_3")
        self.horizontalLayoutWidget_6 = QtWidgets.QWidget(parent=self.page_3)
        self.horizontalLayoutWidget_6.setGeometry(QtCore.QRect(9, 9, 1141, 821))
        self.horizontalLayoutWidget_6.setObjectName("horizontalLayoutWidget_6")
        self.horizontalLayout_8 = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget_6)
        self.horizontalLayout_8.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_8.setObjectName("horizontalLayout_8")
        self.compute_most_popular_button = QtWidgets.QPushButton(parent=self.horizontalLayoutWidget_6)
        self.compute_most_popular_button.setObjectName("compute_most_popular_button")
        self.horizontalLayout_8.addWidget(self.compute_most_popular_button)
        self.most_popular_label = QtWidgets.QLabel(parent=self.horizontalLayoutWidget_6)
        self.most_popular_label.setObjectName("most_popular_label")
        self.horizontalLayout_8.addWidget(self.most_popular_label)
        self.stackedWidget.addWidget(self.page_3)
        self.verticalLayout.addWidget(self.stackedWidget)

        self.retranslateUi(Form)
        self.stackedWidget.setCurrentIndex(1)
        QtCore.QMetaObject.connectSlotsByName(Form)

    def retranslateUi(self, Form):
        _translate = QtCore.QCoreApplication.translate
        Form.setWindowTitle(_translate("Form", "Form"))
        self.page_name_CB.setItemText(0, _translate("Form", "Добавить клиента"))
        self.page_name_CB.setItemText(1, _translate("Form", "Добавить заказ"))
        self.page_name_CB.setItemText(2, _translate("Form", "Получить доходы, расходы и прибыль"))
        self.page_name_CB.setItemText(3, _translate("Form", "Получить посещаемость за определенный период"))
        item = self.clients_table.horizontalHeaderItem(0)
        item.setText(_translate("Form", "ФИО"))
        item = self.clients_table.horizontalHeaderItem(1)
        item.setText(_translate("Form", "Номер телефона"))
        item = self.clients_table.horizontalHeaderItem(2)
        item.setText(_translate("Form", "Денег потрачено"))
        item = self.clients_table.horizontalHeaderItem(3)
        item.setText(_translate("Form", "Уровень программы лояльности"))
        self.clients_full_name_LE.setText(_translate("Form", "ФИО"))
        self.cliens_phone_LE.setText(_translate("Form", "Номер телефона"))
        self.add_client_button.setText(_translate("Form", "Добавить"))
        self.change_client_button.setText(_translate("Form", "Редактировать"))
        self.delete_client_button.setText(_translate("Form", "Удалить"))
        item = self.orders_table.horizontalHeaderItem(0)
        item.setText(_translate("Form", "Дата"))
        item = self.orders_table.horizontalHeaderItem(1)
        item.setText(_translate("Form", "ФИО клиента"))
        item = self.orders_table.horizontalHeaderItem(2)
        item.setText(_translate("Form", "Сумма"))
        item = self.orders_table.horizontalHeaderItem(3)
        item.setText(_translate("Form", "Статус"))
        item = self.orders_table.horizontalHeaderItem(4)
        item.setText(_translate("Form", "ФИО сотрудника"))
        item = self.clients_table_for_order.horizontalHeaderItem(0)
        item.setText(_translate("Form", "Новый столбец"))
        item = self.clients_table_for_order.horizontalHeaderItem(1)
        item.setText(_translate("Form", "Номер телефона"))
        item = self.clients_table_for_order.horizontalHeaderItem(2)
        item.setText(_translate("Form", "Денег потрачено"))
        item = self.clients_table_for_order.horizontalHeaderItem(3)
        item.setText(_translate("Form", "Программа лояльности"))
        item = self.employee_table_for_order.horizontalHeaderItem(0)
        item.setText(_translate("Form", "ФИО"))
        item = self.employee_table_for_order.horizontalHeaderItem(1)
        item.setText(_translate("Form", "Должность"))
        self.add_order_button.setText(_translate("Form", "Добавить заказ"))
        self.delete_order_button.setText(_translate("Form", "Удалить заказ"))
        item = self.menu_items_table_to_order.horizontalHeaderItem(0)
        item.setText(_translate("Form", "Название"))
        item = self.menu_items_table_to_order.horizontalHeaderItem(1)
        item.setText(_translate("Form", "Цена"))
        item = self.menu_item_from_order_table.horizontalHeaderItem(0)
        item.setText(_translate("Form", "Название"))
        item = self.menu_item_from_order_table.horizontalHeaderItem(1)
        item.setText(_translate("Form", "Цена"))
        self.label_4.setText(_translate("Form", "В заказ"))
        self.label_3.setText(_translate("Form", "Из заказа"))
        self.add_menu_item_to_order_button.setText(_translate("Form", "Добавить в заказ"))
        self.del_menu_item_from_order_button.setText(_translate("Form", "Удалить из заказа"))
        item = self.orders_statuse_table.horizontalHeaderItem(0)
        item.setText(_translate("Form", "Статус"))
        self.change_order_status_button.setText(_translate("Form", "Редактировать заказ"))
        self.comboBox.setItemText(0, _translate("Form", "Доходы"))
        self.comboBox.setItemText(1, _translate("Form", "Расходы"))
        self.comboBox.setItemText(2, _translate("Form", "Прибыль"))
        self.label.setText(_translate("Form", "Начало периода"))
        self.label_2.setText(_translate("Form", "Конец периода"))
        self.res_label_1.setText(_translate("Form", "Результат:"))
        self.compute_most_popular_button.setText(_translate("Form", "Расчитать"))
        self.most_popular_label.setText(_translate("Form", "Самый популярный пункт меню:"))
