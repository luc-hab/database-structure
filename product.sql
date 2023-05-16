DROP TABLE IF EXISTS product CASCADE;

CREATE TYPE visibility AS ENUM -- tvorba vlastného dátového typu
('visible', 'hidden');

CREATE TABLE IF NOT EXISTS product_data(
	code VARCHAR(20),
	"pairCode" SMALLINT,
	name VARCHAR(255) NOT NULL,
	"shortDescription" VARCHAR,
	description VARCHAR,
	supplier VARCHAR(10),
	"defaultCategory" VARCHAR,
	"categoryText" VARCHAR,
	"categoryText2" VARCHAR,
	"categoryText3" VARCHAR,
	"categoryText4" VARCHAR,
	"categoryText5" VARCHAR,
	"categoryText6" VARCHAR,
	"categoryText7" VARCHAR,
	"categoryText8" VARCHAR,
	"categoryText9" VARCHAR,	
	price NUMERIC(10, 2) NOT NULL,
	"freeShipping" BOOLEAN NOT NULL,
	"freeBilling" BOOLEAN NOT NULL,
	"variant:Dĺžka" VARCHAR,
	"variant:Farba" VARCHAR,
	"variant:Veľkosť" VARCHAR,
	"variantVisibility" BOOLEAN,
	"productVisibility" VISIBILITY,
	CONSTRAINT "PK_product" PRIMARY KEY (code)	
);