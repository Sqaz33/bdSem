CREATE TABLE IF NOT EXISTS `Clients` (
	`phone_number` varchar(255) NOT NULL UNIQUE,
	`full_name` varchar(255) NOT NULL,
	PRIMARY KEY (`phone_number`)
);

CREATE TABLE IF NOT EXISTS `Loyalty_program_accounts` (
	`money_spent` int NOT NULL,
	`client_phone_number` varchar(255) NOT NULL UNIQUE,
	`lvl_ID` int NOT NULL,
	`ID` int NOT NULL UNIQUE,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Loyalty_program_levels` (
	`name` varchar(255) NOT NULL UNIQUE,
	`ID` int NOT NULL UNIQUE,
	`discount` int NOT NULL,
	`price` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Orders` (
	`ID` int NOT NULL UNIQUE,
	`date` int NOT NULL,
	`clients_phone_number` varchar(255),
	`who_issued` int NOT NULL,
	`status` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Menu_items` (
	`name` varchar(255) NOT NULL UNIQUE,
	`ID` int NOT NULL UNIQUE,
	`price` int NOT NULL,
	`manufacturer` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Employees` (
	`ID` int NOT NULL UNIQUE,
	`full_name` int NOT NULL,
	`job_title` varchar(255) NOT NULL,
	`overtime_hours` int NOT NULL,
	`salary_accountig_id` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Job_titles` (
	`name` varchar(255) NOT NULL UNIQUE,
	`ID` int NOT NULL UNIQUE,
	`salary` int NOT NULL,
	`duty` varchar(255) NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Menu_item_composition_container` (
	`item_name` int NOT NULL UNIQUE,
	`menu_item` int NOT NULL UNIQUE,
	`amount_of_ingredient` int NOT NULL,
	PRIMARY KEY (`item_name`, `menu_item`)
);

CREATE TABLE IF NOT EXISTS `Salary_accountings` (
	`employee_id` int NOT NULL UNIQUE,
	`ID` int NOT NULL UNIQUE,
	`payment_date` date NOT NULL,
	`final_payment` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Order_statuses` (
	`ID` int NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Warehouse_spaces` (
	`ID` int NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL,
	`capacity` int NOT NULL,
	`conditions` int NOT NULL,
	`such_places_in_the_warehouse` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Storage_conditions` (
	`ID` int NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Storage_Items` (
	`ID` int NOT NULL UNIQUE,
	`name` int NOT NULL UNIQUE,
	`characteristics` int NOT NULL,
	`price` int NOT NULL,
	`storage` int NOT NULL,
	`storage_condition` int NOT NULL,
	`shelf_life_in_days` int,
	`type` int NOT NULL,
	`supplier` varchar(255),
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Item_types` (
	`ID` int NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL UNIQUE,
	`consumable` bool NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Expenses` (
	`ID` int NOT NULL UNIQUE,
	`storage_item_id` int,
	`employee_id` int,
	`element_quantity` int NOT NULL,
	`date` date NOT NULL,
	`type` int NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Types_of_expenditure` (
	`ID` int NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Items_in_warehouse` (
	`ID` int NOT NULL UNIQUE,
	`item_id` int NOT NULL,
	`warehouse_place_id` int NOT NULL,
	`quantity_of_item` int NOT NULL,
	`days_until_end_storage` int,
	PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Order_line` (
	`order` int NOT NULL,
	`menu_item` int NOT NULL,
	PRIMARY KEY (`order`, `menu_item`)
);

ALTER TABLE `Clients` ADD CONSTRAINT `Clients_fk0` FOREIGN KEY (`phone_number`) REFERENCES `Loyalty_program_accounts`(`client_phone_number`);
ALTER TABLE `Loyalty_program_accounts` ADD CONSTRAINT `Loyalty_program_accounts_fk2` FOREIGN KEY (`lvl_ID`) REFERENCES `Loyalty_program_levels`(`ID`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk0` FOREIGN KEY (`ID`) REFERENCES `Order_line`(`order`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk2` FOREIGN KEY (`clients_phone_number`) REFERENCES `Clients`(`phone_number`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk3` FOREIGN KEY (`who_issued`) REFERENCES `Employees`(`ID`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk4` FOREIGN KEY (`status`) REFERENCES `Order_statuses`(`ID`);
ALTER TABLE `Menu_items` ADD CONSTRAINT `Menu_items_fk1` FOREIGN KEY (`ID`) REFERENCES `Menu_item_composition_container`(`menu_item`);

ALTER TABLE `Menu_items` ADD CONSTRAINT `Menu_items_fk3` FOREIGN KEY (`manufacturer`) REFERENCES `Employees`(`ID`);
ALTER TABLE `Employees` ADD CONSTRAINT `Employees_fk2` FOREIGN KEY (`job_title`) REFERENCES `Job_titles`(`ID`);

ALTER TABLE `Employees` ADD CONSTRAINT `Employees_fk4` FOREIGN KEY (`salary_accountig_id`) REFERENCES `Salary_accountings`(`ID`);

ALTER TABLE `Menu_item_composition_container` ADD CONSTRAINT `Menu_item_composition_container_fk0` FOREIGN KEY (`item_name`) REFERENCES `Storage_Items`(`ID`);
ALTER TABLE `Salary_accountings` ADD CONSTRAINT `Salary_accountings_fk0` FOREIGN KEY (`employee_id`) REFERENCES `Employees`(`ID`);

ALTER TABLE `Warehouse_spaces` ADD CONSTRAINT `Warehouse_spaces_fk3` FOREIGN KEY (`conditions`) REFERENCES `Storage_conditions`(`ID`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk0` FOREIGN KEY (`ID`) REFERENCES `Items_in_warehouse`(`item_id`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk4` FOREIGN KEY (`storage`) REFERENCES `Warehouse_spaces`(`ID`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk5` FOREIGN KEY (`storage_condition`) REFERENCES `Storage_conditions`(`ID`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk7` FOREIGN KEY (`type`) REFERENCES `Item_types`(`ID`);

ALTER TABLE `Expenses` ADD CONSTRAINT `Expenses_fk1` FOREIGN KEY (`storage_item_id`) REFERENCES `Storage_Items`(`ID`);

ALTER TABLE `Expenses` ADD CONSTRAINT `Expenses_fk2` FOREIGN KEY (`employee_id`) REFERENCES `Employees`(`ID`);

ALTER TABLE `Expenses` ADD CONSTRAINT `Expenses_fk5` FOREIGN KEY (`type`) REFERENCES `Types_of_expenditure`(`ID`);

ALTER TABLE `Items_in_warehouse` ADD CONSTRAINT `Items_in_warehouse_fk2` FOREIGN KEY (`warehouse_place_id`) REFERENCES `Warehouse_spaces`(`ID`);
ALTER TABLE `Order_line` ADD CONSTRAINT `Order_line_fk1` FOREIGN KEY (`menu_item`) REFERENCES `Menu_items`(`ID`);