-- VZOR -- tvorba vlastného dátového typu 
CREATE TYPE visibility AS ENUM 
('visible', 'hidden');

-- 1. TABLE ADMINISTRÁCIA PRODUKTU => spoločné info pre produkt
-- Viac produktov môže mať 1 administráciu
CREATE TABLE IF NOT EXISTS product_administration (
	id_product_administration SERIAL,
	name VARCHAR(255) NOT NULL,
	url VARCHAR NOT NULL, -- URL je tá istá pre všetky produkty s jednotným AD - no niekedy sa napojí na jej koniec id varianty 
	short_description VARCHAR,
	description VARCHAR,
    manufacturer VARCHAR(20),
	supplier VARCHAR(20),	
    product_visibility VISIBILITY, -- ak, bude nastavené na skrytý... treba aby sa skryli všetky varianty
	variant_existence BOOLEAN,
	CONSTRAINT "PK_product_administration" PRIMARY KEY (id_product_administration)	
);

-- 2. TABLE PRODUCT  -> uchováva špecifické info, ktoré prilieha ku konkrétnemu ID - V tomto prípade kódu produktu
CREATE TABLE IF NOT EXISTS product (
    id_product VARCHAR(30), 
    id_product_administration INT,
    price NUMERIC(10, 2) NOT NULL,
    standard_price NUMERIC(10, 2),
    action_price NUMERIC(10, 2),
    action_from DATE,
    action_until DATE,
    stock INT,
    availability_out_stock VARCHAR(20),
    availability_in_stock VARCHAR(20),
	CONSTRAINT "PK_product" PRIMARY KEY (id_product), 
    CONSTRAINT "FK_product_product_administration" FOREIGN KEY (id_product_administration)
    REFERENCES product_administration (id_product_administration)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. IMAGES - Sú pre všetky varianty rovnaké takže FK bude na administráciu produktu
CREATE TABLE IF NOT EXISTS  product_image (
    id_product_image SERIAL PRIMARY KEY,
    id_product_administration INT,
    image_url VARCHAR,
    image_description VARCHAR(255),
    CONSTRAINT "FK_image_product_administration" FOREIGN KEY (id_product_administration)
    REFERENCES product_administration (id_product_administration)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. VARIANT TEMPLATE (šablóny variantov a ich názvy)
CREATE TABLE IF NOT EXISTS variant_template (
    id_variant_template SERIAL PRIMARY KEY,
    name_template VARCHAR(60)
);
-- 5. PARAMETRE VARIÁNT (zoznam parametrov a ich názvov)
CREATE TABLE IF NOT EXISTS variant_parameter (
    id_variant_parameter SERIAL PRIMARY KEY,
    name_parameter VARCHAR(60)
);

-- 6. HODNOTY PRE PARAMETRE (každý parameter má svoje hodnoty)
CREATE TABLE IF NOT EXISTS variant_parameter_value (
    id_parameter_value SERIAL PRIMARY KEY,
    id_variant_parameter INT,
    name_parameter_value VARCHAR(60),
    CONSTRAINT "FK_parameter_value_parameter" FOREIGN KEY (id_variant_parameter)
    REFERENCES variant_parameter (id_variant_parameter)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. ŠABLÓNA VARIANTOV - špeciálne šablóny pre tvorbu variánt 
CREATE TABLE IF NOT EXISTS variant_parameter_template (
    id_variant_template INT NOT NULL,
    id_variant_parameter INT NOT NULL,
    id_parameter_value INT NOT NULL,
    CONSTRAINT "PK_template_parameter_value" PRIMARY KEY (id_variant_template, id_variant_parameter, id_parameter_value),
    FOREIGN KEY (id_variant_template) REFERENCES variant_template(id_variant_template) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_variant_parameter) REFERENCES variant_parameter(id_variant_parameter) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_parameter_value) REFERENCES variant_parameter_value(id_parameter_value) ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABUĽKA PRE KATEGÓRIE A PODKATEGÓRIE
CREATE SEQUENCE category_id_seq START WITH 100;
CREATE TABLE category (
    id_category INT DEFAULT nextval('category_id_seq') PRIMARY KEY,
    id_parent_category INT,
    url_category VARCHAR(255),
    url_parent_category VARCHAR(255),
    name_category VARCHAR(255),
    navigation_title VARCHAR(50),
    meta_title VARCHAR(60),
    meta_description VARCHAR(160),
    top_description VARCHAR,
    bottom_description VARCHAR,
    expand_in_menu BOOLEAN NOT NULL,
    visible BOOLEAN NOT NULL,
    priority SMALLINT NOT NULL,
    access SMALLINT NOT NULL,
    CONSTRAINT chk_id_category CHECK (id_category > 99),
    FOREIGN KEY (id_parent_category) REFERENCES category(id_category) ON DELETE CASCADE ON UPDATE CASCADE
);

-- MANY TO MANY RELATIONSHIP
-- product_administration a category
CREATE TABLE product_administration_category (
  id_product_administration INT,
  id_category INT,
  PRIMARY KEY (id_product_administration, id_category),
  FOREIGN KEY (id_product_administration) REFERENCES product_administration(id_product_administration),
  FOREIGN KEY (id_category) REFERENCES category(id_category)
);