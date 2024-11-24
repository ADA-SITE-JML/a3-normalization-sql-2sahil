
DROP TABLE IF EXISTS Unnormalized1;

CREATE TABLE Unnormalized1 (
    CRN INT,
    ISBN VARCHAR(20) NOT NULL,
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
SELECT * FROM Unnormalized1;


