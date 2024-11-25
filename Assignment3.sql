DROP TABLE IF EXISTS Unnormalized1;
DROP TABLE IF EXISTS first_normal_form;

CREATE TABLE Unnormalized1 (
    CRN INT,
    ISBN VARCHAR(255) NOT NULL,
    Title VARCHAR(255),
    Authors VARCHAR(255),
    Edition VARCHAR(50),
    Publisher VARCHAR(255),
    Publisher_address VARCHAR(255),
    Pages INT,
    Year INT,
    Course_name VARCHAR(255),
    PRIMARY KEY (CRN, ISBN)
);

\copy Unnormalized1 FROM '/Users/sahil/Desktop/Unnormalized1.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';');

-- FIRST NORMAL FORM --
CREATE TABLE first_normal_form AS
SELECT
    CRN,
    ISBN,
    Title,
    unnest(string_to_array(REGEXP_REPLACE(Authors, '[^[:print:]]', ' ', 'g'), ', ')) AS Author,  -- Replace non-printing characters with spaces
    Edition,
    Publisher,
    Publisher_address,
    Pages,
    Year,
    Course_name
FROM Unnormalized1;


-- SECOND NORMAL FORM --

DROP TABLE IF EXISTS Textbooks CASCADE;
DROP TABLE IF EXISTS Courses_Textbooks CASCADE;
DROP TABLE IF EXISTS Textbooks_Authors CASCADE;
DROP TABLE IF EXISTS Courses CASCADE;


CREATE TABLE Courses AS
SELECT DISTINCT
    CRN,
    Course_name
FROM first_normal_form;

CREATE TABLE Textbooks AS
SELECT DISTINCT
    ISBN,
    Title,
    Edition,
    Publisher,
    Publisher_address,
    Pages,
    Year
FROM first_normal_form;


CREATE TABLE Courses_Textbooks AS
SELECT DISTINCT
    CRN,
    ISBN
FROM first_normal_form;

CREATE TABLE Textbooks_Authors AS
SELECT DISTINCT
    ISBN,
    author
FROM first_normal_form;
