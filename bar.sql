CREATE TABLE IF NOT EXISTS `Clients` (
	`phone_number` int AUTO_INCREMENT NOT NULL UNIQUE,
	`full_name` varchar(255) NOT NULL,
	PRIMARY KEY (`phone_number`)
);

CREATE TABLE IF NOT EXISTS `Loyalty_program_accounts` (
	`money_spent` int AUTO_INCREMENT NOT NULL,
	`client_phone_number` varchar(255) NOT NULL UNIQUE,
	`lvl_name` int NOT NULL,
	`id` int NOT NULL UNIQUE,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Loyalty_program_levels` (
	`name` varchar(255) NOT NULL UNIQUE,
	`discount` int NOT NULL,
	`price` int NOT NULL,
	PRIMARY KEY (`name`)
);

CREATE TABLE IF NOT EXISTS `Orders` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`date` int NOT NULL,
	`clients_phone_number` varchar(255),
	`who_issued` int NOT NULL,
	`status` int NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Menu_items` (
	`name` int AUTO_INCREMENT NOT NULL UNIQUE,
	`id` int NOT NULL UNIQUE,
	`price` int NOT NULL,
	`manufacturer` int NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Order_line` (
	`order` int NOT NULL,
	`menu_item` int NOT NULL,
	PRIMARY KEY (`order`, `menu_item`)
);

CREATE TABLE IF NOT EXISTS `Employees` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`full_name` int NOT NULL,
	`job_title` varchar(255) NOT NULL,
	`overtime_hours` int NOT NULL,
	`salary_accountig_id` int NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Job_titles` (
	`name` int AUTO_INCREMENT NOT NULL UNIQUE,
	`id` int NOT NULL UNIQUE,
	`salary` int NOT NULL,
	`duty` varchar(255) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Menu_item_composition` (
	`ingredient_name` varchar(255) NOT NULL UNIQUE,
	`menu_item` int NOT NULL UNIQUE,
	PRIMARY KEY (`ingredient_name`, `menu_item`)
);

CREATE TABLE IF NOT EXISTS `Salary_accountings` (
	`employee_id` int NOT NULL UNIQUE,
	`Id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`payment_date` date NOT NULL,
	`final_payment` int NOT NULL,
	PRIMARY KEY (`Id`)
);

CREATE TABLE IF NOT EXISTS `Statuses` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Menu_item_2_container` (
	`container_name` varchar(255) NOT NULL UNIQUE,
	`menu_item` int NOT NULL UNIQUE,
	PRIMARY KEY (`container_name`, `menu_item`)
);

CREATE TABLE IF NOT EXISTS `Warehouse_spaces` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`type` int NOT NULL,
	`name` varchar(255) NOT NULL,
	`capacity` int NOT NULL,
	`number_of_items` int NOT NULL,
	`conditions` int NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Storage_conditions` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`conditions` varchar(255) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Storage_Items` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`name` int NOT NULL UNIQUE,
	`characteristics` int NOT NULL,
	`price` int NOT NULL,
	`storage` int NOT NULL,
	`storage_condition` int NOT NULL,
	`shelf_life_in_days` int NOT NULL,
	`type` int NOT NULL,
	`supplier` varchar(255),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Item_types` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`types` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Expenses` (
	`id` int NOT NULL UNIQUE,
	`storage_item_id` int,
	`salary_id` int,
	`element_quantity` int NOT NULL,
	`date` date NOT NULL,
	`type` int NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Types_of_expenditure` (
	`id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`name` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`id`)
);

ALTER TABLE `Clients` ADD CONSTRAINT `Clients_fk0` FOREIGN KEY (`phone_number`) REFERENCES `Loyalty_program_accounts`(`client_phone_number`);
ALTER TABLE `Loyalty_program_accounts` ADD CONSTRAINT `Loyalty_program_accounts_fk2` FOREIGN KEY (`lvl_name`) REFERENCES `Loyalty_program_levels`(`name`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk0` FOREIGN KEY (`id`) REFERENCES `Order_line`(`order`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk2` FOREIGN KEY (`clients_phone_number`) REFERENCES `Clients`(`phone_number`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk3` FOREIGN KEY (`who_issued`) REFERENCES `Employees`(`id`);

ALTER TABLE `Orders` ADD CONSTRAINT `Orders_fk4` FOREIGN KEY (`status`) REFERENCES `Statuses`(`id`);
ALTER TABLE `Menu_items` ADD CONSTRAINT `Menu_items_fk1` FOREIGN KEY (`id`) REFERENCES `Order_line`(`menu_item`);

ALTER TABLE `Menu_items` ADD CONSTRAINT `Menu_items_fk3` FOREIGN KEY (`manufacturer`) REFERENCES `Employees`(`id`);

ALTER TABLE `Employees` ADD CONSTRAINT `Employees_fk2` FOREIGN KEY (`job_title`) REFERENCES `Job_titles`(`id`);

ALTER TABLE `Employees` ADD CONSTRAINT `Employees_fk4` FOREIGN KEY (`salary_accountig_id`) REFERENCES `Salary_accountings`(`Id`);

ALTER TABLE `Menu_item_composition` ADD CONSTRAINT `Menu_item_composition_fk0` FOREIGN KEY (`ingredient_name`) REFERENCES `Storage_Items`(`id`);

ALTER TABLE `Menu_item_composition` ADD CONSTRAINT `Menu_item_composition_fk1` FOREIGN KEY (`menu_item`) REFERENCES `Menu_items`(`id`);
ALTER TABLE `Salary_accountings` ADD CONSTRAINT `Salary_accountings_fk0` FOREIGN KEY (`employee_id`) REFERENCES `Employees`(`id`);

ALTER TABLE `Menu_item_2_container` ADD CONSTRAINT `Menu_item_2_container_fk0` FOREIGN KEY (`container_name`) REFERENCES `Storage_Items`(`id`);

ALTER TABLE `Menu_item_2_container` ADD CONSTRAINT `Menu_item_2_container_fk1` FOREIGN KEY (`menu_item`) REFERENCES `Menu_items`(`id`);
ALTER TABLE `Warehouse_spaces` ADD CONSTRAINT `Warehouse_spaces_fk5` FOREIGN KEY (`conditions`) REFERENCES `Storage_conditions`(`id`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk4` FOREIGN KEY (`storage`) REFERENCES `Warehouse_spaces`(`id`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk5` FOREIGN KEY (`storage_condition`) REFERENCES `Storage_conditions`(`id`);

ALTER TABLE `Storage_Items` ADD CONSTRAINT `Storage_Items_fk7` FOREIGN KEY (`type`) REFERENCES `Item_types`(`id`);

ALTER TABLE `Expenses` ADD CONSTRAINT `Expenses_fk1` FOREIGN KEY (`storage_item_id`) REFERENCES `Storage_Items`(`id`);

ALTER TABLE `Expenses` ADD CONSTRAINT `Expenses_fk2` FOREIGN KEY (`salary_id`) REFERENCES `Job_titles`(`id`);

ALTER TABLE `Expenses` ADD CONSTRAINT `Expenses_fk5` FOREIGN KEY (`type`) REFERENCES `Types_of_expenditure`(`id`);
