DROP TABLE IF EXISTS Unnormalized1;
DROP TABLE IF EXISTS first_normal_form;

CREATE TABLE Unnormalized1 (
    CRN INT,
    ISBN VARCHAR(20),
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

-- Second Normal Form --

DROP TABLE IF EXISTS Textbooks CASCADE;
DROP TABLE IF EXISTS Courses_Textbooks CASCADE;
DROP TABLE IF EXISTS Textbooks_Authors CASCADE;
DROP TABLE IF EXISTS Courses CASCADE;
DROP TABLE IF EXISTS Authors CASCADE;

CREATE TABLE Courses AS
SELECT DISTINCT
    CRN,
    Course_name
FROM first_normal_form;

ALTER TABLE Courses
ADD PRIMARY KEY (CRN);

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

ALTER TABLE Textbooks
ADD PRIMARY KEY (ISBN);


CREATE TABLE Authors AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY author) AS author_id,
    author
FROM (
    SELECT DISTINCT author
    FROM first_normal_form
) AS distinct_authors;

ALTER TABLE Authors
ADD PRIMARY KEY (author_id);

CREATE TABLE Courses_Textbooks AS
SELECT DISTINCT
    CRN,
    ISBN
FROM first_normal_form;

ALTER TABLE Courses_Textbooks 
ADD CONSTRAINT fk_courses 
FOREIGN KEY (CRN) REFERENCES Courses(CRN),
ADD CONSTRAINT fk_textbooks 
FOREIGN KEY (ISBN) REFERENCES Textbooks(ISBN);

CREATE TABLE Textbooks_Authors AS
SELECT DISTINCT
    t.ISBN,
    a.author_id
FROM first_normal_form t
JOIN Authors a ON t.author = a.author;

ALTER TABLE Textbooks_Authors 
ADD CONSTRAINT fk_textbooks 
FOREIGN KEY (ISBN) REFERENCES Textbooks(ISBN),
ADD CONSTRAINT fk_authors
FOREIGN KEY (author_id) REFERENCES Authors(author_id);

-- Third Normal Form--

DROP TABLE IF EXISTS Textbooks_Publisher CASCADE;
DROP TABLE IF EXISTS Publisher CASCADE;
DROP TABLE IF EXISTS Textbooks CASCADE;

CREATE TABLE Publisher AS
SELECT DISTINCT 
    Publisher AS Publisher_name,
    Publisher_address
FROM first_normal_form;

ALTER TABLE Publisher
ADD PRIMARY KEY (Publisher_name);

CREATE TABLE Textbooks AS
SELECT DISTINCT 
    ISBN,
    Title,
    Edition,
    Pages,
    Year
FROM first_normal_form;

ALTER TABLE Textbooks
ADD PRIMARY KEY (ISBN);

CREATE TABLE Textbooks_Publisher AS
SELECT DISTINCT 
    ISBN,
    Publisher AS Publisher_name
FROM first_normal_form;


ALTER TABLE Textbooks_Publisher
ADD CONSTRAINT fk_textbooks FOREIGN KEY (ISBN) REFERENCES Textbooks(ISBN),
ADD CONSTRAINT fk_publishers FOREIGN KEY (Publisher_name) REFERENCES Publisher(Publisher_name);




