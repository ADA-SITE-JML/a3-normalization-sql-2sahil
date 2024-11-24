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

CREATE TABLE first_normal_form (
    CRN INT,
    ISBN VARCHAR(255) NOT NULL,
    Title VARCHAR(255),
    Author VARCHAR(255),
    Edition VARCHAR(50),
    Publisher VARCHAR(255),
    Publisher_address VARCHAR(255),
    Pages INT,
    Year INT,
    Course_name VARCHAR(255)
);

INSERT INTO first_normal_form (CRN, ISBN, Title, Author, Edition, Publisher, Publisher_address, Pages, Year, Course_name)
SELECT
    CRN,
    ISBN,
    Title,
	unnest(string_to_array(REGEXP_REPLACE(Authors, '[^[:print:]]', ' ', 'g'), ', ')) AS Author, -- Replace non-printing characters with spaces
    Edition,
    Publisher,
    Publisher_address,
    Pages,
    Year,
    Course_name
FROM Unnormalized1;

SELECT * FROM first_normal_form;

