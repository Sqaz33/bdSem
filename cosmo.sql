DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;


-- Таблица статусов космических запусков
CREATE TABLE statuses_of_space_launches (
	id_statuse_of_space_launches serial PRIMARY KEY,
	title VARCHAR(80) NOT NULL
);

INSERT INTO statuses_of_space_launches(title) 
	VALUES ('Запланирован'),
		   ('Проведен'),
	       ('Отменен');
	
-- SELECT * FROM statuses_of_space_launches;

-- Таблица с данными организаторов космических запусков 
CREATE TABLE organizers (
	id_organizer serial PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL
);

-- Таблица результатов космических запусков 
CREATE TABLE results_launches (
	id_result_launche serial PRIMARY KEY,
    title VARCHAR(80) NOT NULL
);

-- Таблица с космическими запусками
CREATE TABLE space_launches(
	id_space_launche serial PRIMARY KEY,
    buget DECIMAL(10, 2) NOT NULL,
	launche_date DATE NOT NULL,
    launche_time TIME NOT NULL,
    id_status INT NOT NULL,
    id_organizer_launche INT NOT NULL,
    id_result INT,
    id_space_device INT,
    id_booster_rocket INT NOT NULL,
    id_cosmodrome INT NOT NULL,
    id_mission INT NOT NULL
);


-- Таблица id работников и id соответствующих им космических запусков
CREATE TABLE space_launches_has_staff (
    id_worker serial,
    id_space_launche serial,
    
    PRIMARY KEY (id_worker, id_space_launche)
);

-- Таблица с контактной информацией работников
CREATE TABLE contact_information_workers (
	id_contact_information_worker serial PRIMARY KEY,
    number_phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Таблица с местами работ сотрудников
CREATE TABLE places_of_work (
	id_place_of_work serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблиица с отделами 
CREATE TABLE departments (
	id_department serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблица с должностями сотрудников
CREATE TABLE positions (
	id_post serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблица с квалификациями
CREATE TABLE qualifications (
	id_qualification serial PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

-- Таблица сотрудников
CREATE TABLE staff (
    id_worker serial PRIMARY KEY,
    gender VARCHAR(10) NOT NULL,
    "name" VARCHAR(80) NOT NULL,
    date_of_birth DATE NOT NULL,
    URL_photo VARCHAR(255) NOT NULL,
    country_of_residence VARCHAR(100) NOT NULL,
    id_contact_information_worker INT NOT NULL,
    id_place_of_work INT NOT NULL,
    id_department INT NOT NULL,
    id_post INT NOT NULL,
    id_qualification INT NOT NULL,
    
    FOREIGN KEY (id_contact_information_worker)
        REFERENCES contact_information_workers (id_contact_information_worker),
    FOREIGN KEY (id_place_of_work)
        REFERENCES places_of_work (id_place_of_work),
    FOREIGN KEY (id_department)
        REFERENCES departments (id_department),
    FOREIGN KEY (id_post)
        REFERENCES positions (id_post),
    FOREIGN KEY (id_qualification)
        REFERENCES qualifications (id_qualification)
);

-- Таблица с производителями космических аппаратов 
CREATE TABLE divases_manufacrtures (
	id_divase_manufacrture serial PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL
);

-- Таблица с типами космических аппартов 
CREATE TABLE types_devises (
	id_type_devise serial PRIMARY KEY,
    titlr VARCHAR(100) NOT NULL
);

-- Таблица с источниками энергии космических устройств
CREATE TABLE energy_sources (
	id_energy_source serial PRIMARY KEY,
    title VARCHAR(100) NOT NULL
); 

-- Таблтца с орбитальными параметрами космических аппаратов
CREATE TABLE orbital_parameters (
	id_orbital_parameter serial PRIMARY KEY,
    height_orbit DECIMAL(50, 2) NOT NULL,
    period_circulation INT NOT NULL,
    speed DECIMAL(20, 2) NOT NULL,
    inclination DECIMAL(10, 2) NOT NULL
);

-- Таблица с габаритными размерами космических аппаратов
CREATE TABLE overall_dimensions (
	id_overall_dimensions serial PRIMARY KEY,
    widgth DECIMAL(5, 2) NOT NULL,
    lenght DECIMAL(5, 2) NOT NULL,
    height DECIMAL(5, 2) NOT NULL
); 

-- Таблица с материалами изготовления космических аппаратов 
CREATE TABLE materials_manufacture_devices (
	id_material_manufacture_device serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблтица с двигателями космических аппаратов
CREATE TABLE "engines" (
	id_engine serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
); 

-- Таблица с космическими устройствами 
CREATE TABLE space_devices (
	id_space_device serial PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    URL_photo VARCHAR(255) NOT NULL,
    service_life INT NOT NULL,
    weight INT NOT NULL,
    energy_consumption DECIMAL(10, 3) NOT NULL,
    id_divase_manufacrture INT NOT NULL,
    id_type_devise INT NOT NULL,
    id_energy_source INT NOT NULL,
	id_orbital_parameter INT NOT NULL,
    id_overall_dimensions INT NOT NULL,
    id_material_manufacture_device INT NOT NULL,
    id_engine INT NOT NULL,

    FOREIGN KEY (id_divase_manufacrture) 
		REFERENCES divases_manufacrtures(id_divase_manufacrture),
    FOREIGN KEY (id_type_devise) 
		REFERENCES types_devises(id_type_devise),
    FOREIGN KEY (id_energy_source) 
		REFERENCES energy_sources(id_energy_source),
    FOREIGN KEY (id_orbital_parameter) 
		REFERENCES orbital_parameters(id_orbital_parameter),
    FOREIGN KEY (id_overall_dimensions) 
		REFERENCES overall_dimensions(id_overall_dimensions),
    FOREIGN KEY (id_material_manufacture_device) 
		REFERENCES materials_manufacture_devices(id_material_manufacture_device),
    FOREIGN KEY (id_engine) 
		REFERENCES "engines"(id_engine)
); 

-- Таблица с топливами для ракет носителей
CREATE TABLE fuels (
	id_fuel serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблица со статусами ракет носителей
CREATE TABLE rocket_statuses (
	id_rocket_status serial PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

-- Таблица с производителями ракет носителей
CREATE TABLE rocket_manufacturers (
	id_rocket_manufacturer serial PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL
);

-- Таблица с материалами изготовления ракет носителей
CREATE TABLE rocket_manufacturing_materials (
	id_rocket_manufacturing_material serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблица с системами управления ракет носителей
CREATE TABLE control_systems (
	id_control_system serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Таблица с ракетами носителями
CREATE TABLE booster_rockets (
	id_booster_rocket serial PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    URL_photo VARCHAR(255) NOT NULL,
    flight_range INT NOT NULL,
    maximum_speed DECIMAL(5, 2) NOT NULL,
    number_of_sheps INT NOT NULL,
    lenght DECIMAL(4, 2) NOT NULL,
    diameter DECIMAL(3, 2) NOT NULL,
    load_capaciry DECIMAL(3, 2) NOT NULL,
    id_fuel INT NOT NULL,
    id_rocket_status INT NOT NULL,
    id_rocket_manufacturer INT NOT NULL,
    id_rocket_manufacturing_material INT NOT NULL,
    id_control_system INT NOT NULL,
    
    FOREIGN KEY (id_fuel) 
		REFERENCES fuels(id_fuel),
    FOREIGN KEY (id_rocket_status) 
		REFERENCES rocket_statuses(id_rocket_status),
    FOREIGN KEY (id_rocket_manufacturer) 
		REFERENCES rocket_manufacturers(id_rocket_manufacturer),
    FOREIGN KEY (id_rocket_manufacturing_material) 
		REFERENCES rocket_manufacturing_materials(id_rocket_manufacturing_material),
    FOREIGN KEY (id_control_system) 
		REFERENCES control_systems(id_control_system)
);

-- Таблица с типами космодромов
CREATE TABLE types_cosmodrome (
    id_type_cosmodrome serial PRIMARY KEY,
    title VARCHAR(80) NOT NULL
);

-- Таблица с координатами космодромов
CREATE TABLE locations (
	id_location serial,
    latitude DECIMAL(4, 4) NOT NULL,
    longitude DECIMAL(4, 4) NOT NULL
); 

alter table locations add constraint "locations_pk" primary key ("id_location");

INSERT INTO locations (latitude, longitude)
VALUES 
    (0.75, 0.61),  -- Moscow
    (0.85, 0.35),   -- Paris
    (0.71, -0.01), -- New York
    (0.05, -0.24),-- Los Angeles
    (0.68, 0.76); -- Tokyo

--1. Добавление столбца
ALTER TABLE locations ADD COLUMN "time_zone" varchar(10);
--2. Изменение, удаление столбца
ALTER TABLE locations RENAME COLUMN "time_zone" TO "zone";
ALTER TABLE locations DROP COLUMN "zone";
--3. Добавление внешнего ключа
ALTER TABLE locations ADD COLUMN "tst_c" integer;
ALTER TABLE locations ADD CONSTRAINT "fk_locations"
	FOREIGN KEY ("tst_c" )
		REFERENCES types_cosmodrome(id_type_cosmodrome);
--4. Изменение, удаление внешнего ключа
ALTER TABLE locations DROP CONSTRAINT "fk_locations";
ALTER TABLE locations ADD CONSTRAINT "locations_fk"
	FOREIGN KEY ("tst_c" )
		REFERENCES types_cosmodrome(id_type_cosmodrome);
--5. Добавление, изменение, удаление первичного ключа
ALTER TABLE locations ADD COLUMN "test_key1" serial;
ALTER TABLE locations ADD COLUMN "test_key2" serial;
ALTER TABLE locations DROP CONSTRAINT "locations_pk";
ALTER TABLE locations ADD CONSTRAINT "locations_pk1"
	PRIMARY KEY ("test_key1");
ALTER TABLE locations DROP CONSTRAINT "locations_pk1";
ALTER TABLE locations ADD CONSTRAINT "locations_pk2" PRIMARY KEY ("test_key2");
ALTER TABLE locations DROP CONSTRAINT "locations_pk2";
--6. бавление, изменение, удаление другого ограничения (unique, check и т.д.)
ALTER TABLE locations ADD CONSTRAINT "test_more_0" CHECK ("test_key2" > 0);
ALTER TABLE locations ADD CONSTRAINT "test_uniq" UNIQUE ("test_key2");

create table tst ("test_key1" int, "test_key2" int);

--RENAME скрипты
--Переименование таблицы
ALTER TABLE tst RENAME TO tst2;
--Переименование атрибутов
ALTER TABLE tst2 RENAME COLUMN "test_key1" TO "test1";
ALTER TABLE tst2 RENAME COLUMN "test_key2" TO "test2";
--Удаление атрибутов
DROP TABLE tst2;
-- Таблица со статусами космодромов 
CREATE TABLE statuses_cosmodromes (
	id_status_cosmodrome serial PRIMARY KEY,
    title VARCHAR(50) NOT NULL 
);
--1. Добавление столбца
ALTER TABLE locations ADD COLUMN "test_column" varchar(10);
--2. Изменение, удаление столбца
ALTER TABLE locations RENAME COLUMN "test_column" TO "test_c";
ALTER TABLE locations DROP COLUMN "test_c";

create table types_cosmodromes (id_type_cosmodrome serial primary key);
alter table locations add constraint "locations_pk" primary key (id_location);

-- Таблица с космодромами
CREATE TABLE cosmodromes (
    id_cosmodrome serial PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    square INT NOT NULL,
    country VARCHAR(50) NOT NULL,
    suppored_launch_orbit INT NOT NULL,
    bandwidth INT NOT NULL,
    URL_photo VARCHAR(255) NOT NULL,
    id_type_cosmodrome INT NOT NULL,
    id_location INT NOT NULL,
    id_status_cosmodrome INT NOT NULL,

    FOREIGN KEY (id_type_cosmodrome)
        REFERENCES types_cosmodromes (id_type_cosmodrome),
    FOREIGN KEY (id_location)
        REFERENCES locations (id_location),
    FOREIGN KEY (id_status_cosmodrome)
        REFERENCES statuses_cosmodromes (id_status_cosmodrome)
);

-- Таблица с результатами миссий
CREATE TABLE missions_results (
	id_mission_result serial PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

-- Таблица с типами миссий
CREATE TABLE types_missions (
	id_type_mission serial PRIMARY KEY,
	title VARCHAR(100) NOT NULL
);

-- Таблица со статусами миссий
CREATE TABLE missions_statuses (
	id_mission_status serial PRIMARY KEY,
    title VARCHAR(50) NOT NULL
);

INSERT INTO missions_statuses(title)
	VALUES
		('start'),
		('stop'),
		('end'),
		('sdfv3234'),
		('sjo34233');

-- Таблица с миссиями
CREATE TABLE missions (
	id_mission serial PRIMARY KEY,
	"name" VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    id_mission_result INT,
    id_type_mission INT NOT NULL,
	id_mission_status INT,

	FOREIGN KEY (id_mission_result) 
		REFERENCES missions_results(id_mission_result),
    FOREIGN KEY (id_type_mission) 
		REFERENCES types_missions(id_type_mission),
    FOREIGN KEY (id_mission_status) 
		REFERENCES missions_statuses(id_mission_status)
);


ALTER TABLE space_launches
	ADD CONSTRAINT "space_launches_fk1"
		FOREIGN KEY (id_space_device) 
			REFERENCES space_devices(id_space_device),
	ADD CONSTRAINT "space_launches_fk2"
	    FOREIGN KEY (id_booster_rocket) 
			REFERENCES booster_rockets(id_booster_rocket),
	ADD CONSTRAINT "space_launches_fk3"
		FOREIGN KEY (id_booster_rocket) 
			REFERENCES booster_rockets(id_booster_rocket),
	ADD CONSTRAINT "space_launches_fk4"
	    FOREIGN KEY (id_status) 
			REFERENCES statuses_of_space_launches(id_statuse_of_space_launches),
	ADD CONSTRAINT "space_launches_fk5"
	    FOREIGN KEY (id_organizer_launche) 
			REFERENCES organizers(id_organizer),
	ADD CONSTRAINT "space_launches_fk6"
	    FOREIGN KEY (id_result) 
			REFERENCES results_launches(id_result_launche),
	ADD CONSTRAINT "space_launches_fk7"
	    FOREIGN KEY (id_cosmodrome) 
			REFERENCES cosmodromes(id_cosmodrome),
	ADD CONSTRAINT "space_launches_fk8"
	    FOREIGN KEY (id_mission) 
			REFERENCES missions(id_mission);

ALTER TABLE space_launches_has_staff
	ADD CONSTRAINT "space_launches_has_staff_fk1"
		FOREIGN KEY (id_worker) 
			REFERENCES staff(id_worker),
	ADD CONSTRAINT "space_launches_has_staff_fk2"
		FOREIGN KEY (id_space_launche)
			REFERENCES space_launches(id_space_launche);



