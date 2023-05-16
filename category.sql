DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS category RESTRICT;

CREATE TABLE IF NOT EXISTS category_data (
	id INT,
	"parentId" INT DEFAULT 1,
	"parentUrl" VARCHAR(255),
	"expandInMenu" BOOLEAN NOT NULL,
	visible BOOLEAN NOT NULL,
	priority SMALLINT NOT NULL,
	access SMALLINT NOT NULL,
	title VARCHAR(255) NOT NULL,
	"linkText" VARCHAR,
	url VARCHAR(255) UNIQUE NOT NULL,
	"topDescription" VARCHAR,
	"bottomDescription" VARCHAR,
	"metaTitle" VARCHAR,
	"metaDescription" VARCHAR,
	CONSTRAINT "PK_category" PRIMARY KEY (id)
);

