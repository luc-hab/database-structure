-- JEDNORIADKOVÝ KOMENTÁR
/*
VIACRIADKOVÝ KOMENTÁR 
*/

-- vkladanie hodnôt do tabuľky pomocou INSER INTO
-- jednoduché úvodzovky špecifikácia stringov 
-- dvojité úvodzovky na rozlišovanie malých a veľkých písmen

INSERT INTO product_data(code, "pairCode", name, "shortDescription", description, supplier, price, "freeShipping", "freeBilling")
VALUES ('ABO83748', NULL, 'Šiltovky pre chlapov', 'Text o šiltovkách', 'Popis podrobný o produkte', 'NEW', 20.2, TRUE, TRUE);

/*
SELECT, vráti stĺpce - code ... + vráti nový stĺpec s názvom multiple_variants, kde spojí výsledky z tabuliek velkosť + farba
*/ 
SELECT code, "variant:Dĺžka", "variant:Farba", "variant:Veľkosť", "variant:Farba" || '  ' || "variant:Veľkosť" AS multiple_variants 
FROM product_data;

-- kľudne si môžem dať vrátiť len napr. code a nový stĺpec multiple_variants
-- pozor na ALIAS - vždy treba skontrolovať tabuľku vyhodnocovania napr. WHERE ho nemusí poznať
-- operátor konkatenácie = spájania -> || '  ' || 
SELECT code, "variant:Farba" || '  ' || "variant:Veľkosť" AS multiple_variants 
FROM product_data;

-- SELECT DISTINCT vráti jedinečné hodnoty zo stĺpca
-- môžeme hľadať aj jedinečné hodnoty z dvoch a viacerých stĺpcov 

SELECT DISTINCT "pairCode" 
FROM product_data;

-- ORDER BY = zoraď -> ASC - defaultne / DESC - od najväčšieho po najmenší
SELECT code, "pairCode"
FROM product_data
ORDER BY "pairCode" DESC;

-- WHERE pairCode nie je 0 
SELECT code, "pairCode"
FROM product_data
WHERE "pairCode" != 0
ORDER BY "pairCode" ASC;

-- vyber stĺpce code, pairCode, price
-- z tabuľky nazov_tabulky
-- kde pairCode sa nerovná 0
-- zoraď hodnoty od najväčšieho po najmenší podľa pairCode
-- tie čo su zhodné ešte zoraď podľa ceny tiež od najväčšieho po najmenší
-- ak neurčím nič, automaticky sa aplikuje ASC - pre zoradenie
SELECT code, "pairCode", price
FROM product_data
WHERE "pairCode" != 0
ORDER BY "pairCode" DESC, price DESC;

-- kde párovací kód nie je 0 ale zároveň je <= 4 - pomocou AND
SELECT code, "pairCode", price
FROM product_data
WHERE "pairCode" != 0 AND "pairCode" <= 4
ORDER BY "pairCode" DESC, price DESC;

-- vráť všetky riadky okrem tých, ktorých stĺpec "nazovStlpca" má hodnoty 0,1,2
SELECT code, "pairCode", price
FROM product_data
WHERE "pairCode" NOT IN (0, 1, 2);

-- LENGTH() - funkcia vďaka, kt. viem dozistiť aký je najdlhší nadpis...
-- PR: lepšie špecifikovať dátový typ (dĺžku)
SELECT code, name, LENGTH(name)
FROM product_data
WHERE LENGTH(name) > 20 AND LENGTH(name) < 25 ;

-- LIKE - case sensitive - vyfiltruje len tie, ktoré začínajú na veľké M
-- ILIKE - nie je case sensitive 
-- LIKE / ILIKE - nikdy nepoužívať s % na začiatku (indexácia problém!)
SELECT code, name
FROM product_data
WHERE name LIKE 'M%';

-- Vyber 3 riadky, od indexu 5, v SQL indexácia od 1 
SELECT code, "pairCode", price
FROM product_data
LIMIT 3
OFFSET 5;

-- ROUND() - funkcia pre zaokruhlenie - prvá hodnota "čo", "druhá na koľko desatinných miest"
SELECT code, "pairCode", ROUND(price, 1)
FROM product_data
WHERE "pairCode" NOT IN (0, 1, 2);

-- príkaz LIMIT sa nenachádza v SQL štandarde je špeciálne prispôsobený pre postgres
-- SQL LIMIT sa štandardne rieši cez FETCH
-- BETWEEN AND - vyberie v tomto prípade hodnoty medzi 17 a 20
SELECT code, name, price, "pairCode"
FROM product_data
WHERE "pairCode" != 0 AND LENGTH(name) BETWEEN 17 AND 20
ORDER BY price DESC
LIMIT 4;

-- DISTINCT = unikátna hodnota 
SELECT DISTINCT name, price, "pairCode"
FROM product_data
WHERE "pairCode" != 0 AND LENGTH(name) BETWEEN 17 AND 20;

-- PORADIE VYHODNOCOVANIA PRÍKAZOV
-- FROM ->WHERE -> SELECT -> ORDER BY -> LIMIT 

-- ÚPRAVA TABUĽKY - ALTER TABLE
-- RENAME TO - premenovanie tabuľky
ALTER TABLE nazov_tabulky
RENAME TO "nazovTabulky"; 

-- RENAME COLUMN - premenovanie stĺpca tabuľky
ALTER TABLE product_data
RENAME COLUMN "pairCode" TO pair_code; 

-- UPDATE konkrétnej HODNOTY - RIADKU tabuľky
-- UPDATE nazov tabulky SET nastavenie hodnôt
-- POSTUPNOSŤ VYHODNOCOVANIA - NAJPRV sa vyhodnotí podmienka WHERE až potom sa uskutoční SET
-- môžeme updatovať aj viaceré riadky naraz
UPDATE nazov_tabulky
SET "firstName" = 'Nove meno',
    "lastName" = 'Nove priezvisko'
WHERE "customerId" < 14;

-- nájde všetky stĺpce - vybranej tabuľky 
SELECT column_name
FROM information_schema.columns
WHERE table_schema='public' AND table_name = 'product_data';

-- 1. Ak by som chcela pridať column s constrainom NOT NULL vypíše nám chybu
-- nevieme ho pridať jednoduchým spôsobom 
ALTER TABLE product_data
ADD COLUMN "newColumn" VARCHAR(256) NOT NULL;

-- 2. Vytvorím si daný stĺpec bez obmedzenia NOT NULL
ALTER TABLE product_data
ADD COLUMN "newColumn" VARCHAR(256);

-- 3. Updatujeme záznamy v stĺpci "newColumn"
UPDATE product_data
SET "newColumn" = 'x';

-- 4. Kontrola či je všetko ok
SELECT code, name, "newColumn"
FROM product_data;

-- 5. Nastavenie constraintu = NOT NULL -> v tabuľke, v stĺpci, nastav constraint
ALTER TABLE product_data
ALTER COLUMN "newColumn" 
SET NOT NULL;

-- C.R.U.D - DELETE
-- 1. Vymazanie záznamu
DELETE FROM "nazovTabulky"
WHERE "idTabulky" = 2;

-- 2. Niekedy je užitočné nielen záznam vymazať ale aj vrátiť jeho hodnotu RETURNING
-- dôležité napr. pre REST API / BACKEND SERVERS
-- RETURNING funguje ako SELECT 
DELETE FROM "nazovTabulky"
WHERE "idTabulky" = 2
RETURNING *; 

-- 3. Vymazať OBSAH TABUĽKY - VŠETKY ZÁZNAMY - celý príklad
CREATE TABLE "nazovTabulky"(
	name VARCHAR,
	surname VARCHAR,
	tabulka_id SERIAL PRIMARY KEY
);

INSERT INTO "nazovTabulky" (name, surname)
VALUES ('Andrea', 'Priezvisko1');
INSERT INTO "nazovTabulky" (name, surname)
VALUES ('Marek', 'Priezvisko2');
INSERT INTO "nazovTabulky" (name, surname)
VALUES ('Dominik', 'Priezvisko3');

SELECT * FROM "nazovTabulky";

-- ponechá hodnotu autoincrementu - to znamená, že ak potom pridám nové záznamy
-- budú sa priradzovať id od čísla 4 - keďže sme vymazali 3 záznamy
DELETE FROM "nazovTabulky";
-- ostanú len prázdne stĺpce bez záznamov, ktoré sme vyššie insertovali
SELECT * FROM "nazovTabulky";

-- 4. DROP - ZMAŽE CELÚ TABUĽKU SO ZÁZNAMAMI - NEPOUŽÍVAŤ - naozaj iba v najnutnejších prípadoch
-- mazanie údajov - postupne riadok po riadku
DROP TABLE "nazovTabulky";

-- 5. TRUNCATE TABLE - tak isto opatrne! - rýchlejší ako DELETE FROM - súvisí s transakciami
TRUNCATE TABLE "nazovTabulky";

-- 6. TRUNCATE TABLE - RESTART IDENTITY - reštartuje aj autoincrement - čiže by sa počítal opäť od 1
-- uzamyká sa celá tabuľka, rýchlejšie mazanie
TRUNCATE TABLE "nazovTabulky" RESTART IDENTITY;