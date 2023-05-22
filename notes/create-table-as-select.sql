CREATE TABLE IF NOT EXISTS product
	AS SELECT
	-- vymenovanie stĺpcov
	FROM product_administration;

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
ON DELETE CASCADE, ON UPDATE CASCADE;
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

-- TVORBA TABUĽKY POMOCOU JOIN
CREATE TABLE IF NOT EXISTS product_variant_template
AS SELECT vt.id_variant_template, vt.name_template, vp.name_parameter, vpv.name_parameter_value
FROM variant_parameter_template vpt
JOIN variant_template vt
	ON vpt.id_variant_template=vt.id_variant_template
JOIN variant_parameter vp
	ON vpt.id_variant_parameter=vp.id_variant_parameter
JOIN variant_parameter_value vpv
	ON vpv.id_variant_parameter=vp.id_variant_parameter;
	
ALTER TABLE product_variant_template
ADD id_product_variant_template SERIAL PRIMARY KEY;
