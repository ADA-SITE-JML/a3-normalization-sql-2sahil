
DROP TABLE IF EXISTS temp_Unnormalized1;

CREATE TEMP TABLE temp_Unnormalized1 (
    CRN INT,
    ISBN VARCHAR(20),
    Title VARCHAR(255),
    Authors VARCHAR(255),
    Edition VARCHAR(50),
    Publisher VARCHAR(255),
    Publisher_address VARCHAR(255),
    Pages INT,
    Year INT,
    Course_name VARCHAR(255)
);

SELECT * FROM temp_unnormalized1;




