-- VZOR -- tvorba vlastného dátového typu 
CREATE TYPE visibility AS ENUM 
('visible', 'hidden');

-- 1. TABLE ADMINISTRÁCIA PRODUKTU => spoločné info pre produkt
-- Viac produktov môže mať 1 administráciu
CREATE TABLE IF NOT EXISTS product_administration (
	id_product_administration SERIAL,
	name VARCHAR(255) NOT NULL,
	url VARCHAR, -- URL je tá istá pre všetky produkty s jednotným AD - no niekedy sa napojí na jej koniec id varianty 
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

-- 4. VARIANT TEMPLATE (šablóna variantov)
CREATE TABLE IF NOT EXISTS variant_template (
    id_variant_template SERIAL PRIMARY KEY,
    name VARCHAR(60)
);
-- 5. PARAMETRE VARIÁNT (aké parametre existujú)
CREATE TABLE IF NOT EXISTS variant_parameter (
    id_variant_parameter SERIAL PRIMARY KEY,
    name VARCHAR(60)
);
-- 6. ŠABLÓNA VARIANTOV môže používať rôzne kombinácie PARAMETROV VARIÁNT
-- MANY TO MANY 
CREATE TABLE IF NOT EXISTS variant_parameter_template (
    id_variant_template INT NOT NULL,
    id_variant_parameter INT NOT NULL,
    CONSTRAINT "PK_parameter_template" PRIMARY KEY (id_variant_template, id_variant_parameter),
    FOREIGN KEY (id_variant_template) REFERENCES variant_template(id_variant_template) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_variant_parameter) REFERENCES variant_parameter(id_variant_parameter) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 7. HODNOTY PRE PARAMETRE
CREATE TABLE IF NOT EXISTS variant_parameter_value (
    id_parameter_value INT SERIAL PRIMARY KEY,
    id_variant_parameter INT,
    name VARCHAR(60),
    CONSTRAINT "FK_parameter_value_parameter" FOREIGN KEY (id_variant_parameter)
    REFERENCES variant_parameter (id_variant_parameter)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. VARIANT PRODUKTU 
CREATE TABLE IF NOT EXISTS product_variant (
    id_product_variant INT SERIAL PRIMARY KEY,
    id_product VARCHAR(30),
    id_variant_parameter INT,
    id_parameter_value INT,
    variant_visibility BOOLEAN,
    CONSTRAINT "FK_product_variant_product" FOREIGN KEY (id_product)
    REFERENCES product (id_product)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "FK_product_variant_parameter" FOREIGN KEY (id_variant_parameter )
    REFERENCES variant_parameter (id_variant_parameter)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "FK_product_variant_parameter_value" FOREIGN KEY (id_parameter_value)
    REFERENCES variant_parameter_value (id_parameter_value)
    ON DELETE CASCADE ON UPDATE CASCADE
);