-- kontrola, či sa všetky údaje správne insertovali
SELECT * FROM product_administration;
SELECT * FROM product_image;
SELECT * FROM product;
SELECT * FROM variant_template;
SELECT * FROM variant_parameter;
SELECT * FROM variant_parameter_value;
SELECT * FROM variant_parameter_template;
SELECT * FROM category;
SELECT * FROM product_administration_category;

-- kontrola, či sú pre každe id_product_administration pridané správne images
SELECT * 
FROM product_administration AS padmin
FULL OUTER JOIN product_image AS img
ON padmin.id_product_administration=img.id_product_administration;

-- DOPLNIŤ - vypísať iba konkrétne stĺpce, ktoré potrebujem vidieť
SELECT padmin.id_product_administration, padmin.name, padmin.product_visibility, img.id_product_image, img.image_url 
FROM product_administration AS padmin
FULL OUTER JOIN product_image AS img
ON padmin.id_product_administration=img.id_product_administration
WHERE padmin.id_product_administration = 2;

-- skúsila som updatovať hodnotu PRIMÁRNEHO KĽÚČA (id_product) 
-- nebola som si istá či môžem updatovať PK, 
-- či nebude potrebné pridať ešte jeden stĺpec product_id osobitne / kod produktu - osobitne
-- avšak pekne mi zmenilo hodnotu na novú
UPDATE product
SET id_product = 'NovyKod'
WHERE id_product='NK1234';

-- kontrola či zmena prebehla správne
SELECT * FROM product
ORDER BY id_product_administration;

-- všetky udaje z vymenovaných tabuliek
SELECT * 
FROM variant_parameter_template vpt
JOIN variant_template vt
	ON vpt.id_variant_template=vt.id_variant_template
JOIN variant_parameter vp
	ON vpt.id_variant_parameter=vp.id_variant_parameter
JOIN variant_parameter_value vpv
	ON vpt.id_parameter_value=vpv.id_parameter_value;

-- všetky udaje z vymenovaných tabuliek
SELECT 
FROM variant_parameter_template vpt
JOIN variant_template vt
	ON vpt.id_variant_template=vt.id_variant_template
JOIN variant_parameter vp
	ON vpt.id_variant_parameter=vp.id_variant_parameter
JOIN variant_parameter_value vpv
	ON vpt.id_parameter_value=vpv.id_parameter_value;

-- nájde všetky varianty pre template - s indexom 1 - DEKA 
SELECT vt.id_variant_template, vt.name_template, vp.name_parameter, vpv.name_parameter_value
FROM variant_parameter_template vpt
JOIN variant_template vt
	ON vpt.id_variant_template=vt.id_variant_template
JOIN variant_parameter vp
	ON vpt.id_variant_parameter=vp.id_variant_parameter
JOIN variant_parameter_value vpv
	ON vpv.id_variant_parameter=vp.id_variant_parameter
WHERE vpt.id_variant_template = 1;

-- VYHĽADANIE PODKATEGÓRIÍ
SELECT subcategory.id_category, subcategory.name_category, main_category.name_category AS parent_category
FROM category subcategory
JOIN category main_category ON subcategory.id_parent_category = main_category.id_category
ORDER BY parent_category, id_category;

-- VYHĽADANIE HLAVNÝCH KATEGÓRIÍ
SELECT id_category, name_category
FROM category
WHERE id_parent_category IS NULL;

-- kontrola či sa správne insertovali hodnoty produktadmin a kategórie
SELECT * 
FROM product_administration AS padmin
JOIN product_administration_category AS padmin_category
ON padmin.id_product_administration=padmin_category.id_product_administration
JOIN product AS code_product
ON padmin.id_product_administration=code_product.id_product_administration;

-- nájde produkt AN15446P/2, ktorý patrí ku jednej kategórii
SELECT * 
FROM product_administration AS padmin
JOIN product_administration_category AS padmin_category
ON padmin.id_product_administration=padmin_category.id_product_administration
JOIN product AS code_product
ON padmin.id_product_administration=code_product.id_product_administration
WHERE code_product.id_product = 'AN15446/2';

-- vypíše konkrétne stĺpce, ktoré nás primárne zaujímajú, pekne vidíme, v ktorých kategóriach bude produkt prítomný
SELECT padmin.id_product_administration, padmin.name, padmin_category.id_category, code_product.id_product
FROM product_administration AS padmin
JOIN product_administration_category AS padmin_category
ON padmin.id_product_administration=padmin_category.id_product_administration
JOIN product AS code_product
ON padmin.id_product_administration=code_product.id_product_administration
WHERE code_product.id_product = 'NK156/4';