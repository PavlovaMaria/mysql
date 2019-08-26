drop database if exists small_clinic;
create database small_clinic;
use small_clinic;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '���',
	post ENUM('�������������', '������', '��������� ���������') COMMENT '���������',
	proxy VARCHAR(255) COMMENT '������ ������������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '�������������� �����������';



DROP TABLE IF EXISTS patients;
CREATE TABLE patients (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '���',
	discounts INT(10) DEFAULT 0 COMMENT '������� ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����� ������ ���������';



DROP TABLE IF EXISTS patients_under_18;
CREATE TABLE patients_under_18 (
	patient_id SERIAL PRIMARY KEY,
	gender CHAR(1),
	birthday DATE,
	address TEXT , 
	nationality VARCHAR(40),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
foreign key (patient_id) references patients(id) on update cascade on delete restrict
) COMMENT = '�������� - ����';



DROP TABLE IF EXISTS representatives;
CREATE TABLE representatives (
	representative_id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '���',
	gender CHAR(1),
	birthday DATE,
	address TEXT, 
	nationality VARCHAR(40),
	passport VARCHAR(255),
	phone BIGINT,
	e_mail VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
foreign key (representative_id) references patients_under_18(patient_id) on update cascade on delete restrict
) COMMENT = '�������� ������������� �����';



DROP TABLE IF EXISTS patients_upper_18;
CREATE TABLE patients_upper_18 (
	patient_id SERIAL PRIMARY KEY,
	gender CHAR(1),
	birthday DATE,
	address TEXT, 
	nationality VARCHAR(40),
	passport VARCHAR(255),
	phone BIGINT,
	e_mail VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
foreign key (patient_id) references patients(id) on update cascade on delete restrict
) COMMENT = '�������� - ��������';



DROP TABLE IF EXISTS templates;
CREATE TABLE templates (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '�������� ���������',
	contain TEXT COMMENT '���������� ���������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '��������� ��� ���������� ';



DROP TABLE IF EXISTS documents;
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
	numbers BIGINT COMMENT '����� ���������',
	documents_id  BIGINT unsigned not null,
	patient_id BIGINT unsigned not null,
	signature_from_clinik BIGINT unsigned not null,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
foreign key (signature_from_clinik) references users(id) on update restrict on delete restrict,
foreign key (documents_id) references templates(id) on update restrict on delete restrict,
foreign key (patient_id) references patients(id) on update restrict on delete restrict
) COMMENT = '��������� ��� ���������� ';



DROP TABLE IF EXISTS main_price;
CREATE TABLE main_price (
	id SERIAL PRIMARY KEY,
	code BIGINT COMMENT '��� ������',
	name VARCHAR(255) COMMENT '�������� ������', 
	price FLOAT UNSIGNED COMMENT '���������',
	payment_doc FLOAT UNSIGNED COMMENT '����� ������ �����',
	payment_nur FLOAT UNSIGNED COMMENT '����� ������ ���. ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
) COMMENT = '����� �� �������� ������';



DROP TABLE IF EXISTS extra_price;
CREATE TABLE extra_price (
	id SERIAL PRIMARY KEY,
	code BIGINT COMMENT '��� ������',
	name VARCHAR(255) COMMENT '�������� ������', 
	price FLOAT UNSIGNED COMMENT '���������',
	payment FLOAT UNSIGNED COMMENT '����� ������ �� ��������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
) COMMENT = '����� �� ������ ����������� ��������� ������������';



DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '���',
	specialization VARCHAR(255) COMMENT '�������������',
	academic_degree VARCHAR(255) COMMENT '������ �������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����� - ������� ����������� �����';



DROP TABLE IF EXISTS nurses;
CREATE TABLE nurses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '���',
	specialization VARCHAR(255) COMMENT '�������������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������� ����������� ��������';




DROP TABLE IF EXISTS main_service;
CREATE TABLE main_service (
	id SERIAL PRIMARY KEY,
	main_service_id BIGINT unsigned not null,
	patient_id BIGINT unsigned not null,
	discount BIGINT  unsigned not null,
	price  FLOAT unsigned not null,
	total_price FLOAT unsigned not null,
	payment_method CHAR(5),
	user_id BIGINT unsigned not null,
	doctor_id BIGINT  unsigned,
	nurse_id BIGINT  unsigned,
	created_at DATETIME default NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
foreign key (doctor_id) references doctors(id) on update restrict on delete restrict,
foreign key (nurse_id) references nurses(id) on update restrict on delete restrict,
foreign key (user_id) references users(id) on update restrict on delete restrict,
foreign key (main_service_id) references main_price(id) on update restrict on delete restrict,
foreign key (patient_id) references patients(id) on update restrict on delete restrict
) COMMENT = '������ ��������� �� ��������� ������';



DROP TABLE IF EXISTS extra_service;
CREATE TABLE extra_service (
	id SERIAL PRIMARY KEY,
	extra_service_id BIGINT unsigned not null,
	patient_id BIGINT unsigned not null,
	discount INT(10) unsigned not null,
	price  FLOAT unsigned not null,
	total_price FLOAT unsigned not null,
	payment_method CHAR(5),
	user_id BIGINT unsigned not null,
	created_at DATETIME default NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
foreign key (user_id) references users(id) on update restrict on delete restrict,
foreign key (extra_service_id) references extra_price(id) on update restrict on delete restrict,
foreign key (patient_id) references patients(id) on update restrict on delete restrict
) COMMENT = '������ ��������� �� ��������� ���������';





