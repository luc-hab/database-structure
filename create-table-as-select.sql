CREATE TABLE IF NOT EXISTS product
	AS SELECT
		code AS product_id,
		"pairCode" AS pair_code,
		name,
		"shortDescription" AS short_description,
		description,
		supplier,
		price,
		"freeShipping" AS free_shipping,
		"freeBilling" AS free_billing,
		"productVisibility" AS product_visibility
	FROM product_data;

ALTER TABLE product 
	ADD CONSTRAINT "FK_product_product_data" 
	FOREIGN KEY (product_id) 
	REFERENCES product_data (code)
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE product ADD PRIMARY KEY (product_id);

-- Šablóna pridanie FK do existujúcej tabuľky
/*
ALTER TABLE child_table 
ADD CONSTRAINT constraint_name 
FOREIGN KEY (fk_columns) 
REFERENCES parent_table (parent_key_columns);
ON DELETE CASCADE;
*/

-- Šablóna pridanie PK do existujúcej tabuľky
/*
ALTER TABLE products 
ADD PRIMARY KEY (column-name);
*/

CREATE TABLE IF NOT EXISTS product_variant
AS SELECT
	product_variant_id, 
	code AS product_id,
	"pairCode" AS pair_code,
	"variant:Dĺžka" AS variant_dlzka,
	"variant:Farba" AS variant_farba,
	"variant:Veľkosť" AS variant_velkost,
	"variantVisibility" AS variant_visibility,
FROM product_data;

ALTER TABLE product_variant
ADD CONSTRAINT "FK_product_variant_product" 
FOREIGN KEY (product_id) 
REFERENCES product (product_id)
ON UPDATE CASCADE ON DELETE CASCADE;