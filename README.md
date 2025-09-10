<h1  align=center  >Database Normalization </h1>

<br>

<img  src="https://miro.medium.com/v2/resize:fit:4800/format:webp/1*HmcXjAZ1VInTlJXqUUBfVg.jpeg"/>



<br>

<h2>Normalizing data till 3rd normal form using SQL</h2>

<p>In this task I used SQL  SHELL (psql) to normalize given unnormalized data which contains "CRN (PK1)	ISBN (PK2)	Title	Authors	Edition	Publisher	Publisher address	Pages	Year	Course name" columns. Before starting, the "DROP TABLE" command exists for every created table to run code from the same file.
</p>
<br>
<h2>Tools and data used for this assignment:</h2>

<p> In this assignment, I used the given csv. file which can be found in "https://github.com/ADA-SITE-JML/a3-normalization-sql-2sahil/blob/main/Unnormalized1.csv", SQL Shell for running code in .sql file, and pgAdmin4 to see outputs since it is better than SQL Shell for this purpose. However, the code should be run in SQL Shell since it uses <b>\copy </b> function to import data. I used <b>\ i </b> command to run code. To run, the path of the .csv file should be changed for specific users, and the path after  <b>\i</b> command should be modified.</p>
<br>
<h2>Steps of normalizing data: Step 1 is importing data into SQL from csv. file.</h2>
<p> This step is straightforward, creating a table using the "CREATE" command and then using <b>\copy </b> command to identify the format of the file which we are importing from and delimiter.  </p>

<br>

<h2>STEP 2: First normal form.</h2>

  <p> In First Normal Form (1NF), each field should contain atomic values, and
repeating groups must be eliminated. In the provided dataset, the “Authors” column
contains multiple values in certain rows, which does not fit the 1NF requirement of
atomicity. In this step, the imported table is normalized into the first normal form by splitting the non-atomic author column and creating rows for each author. For this purpose unnest(string_to_array is used however, I believe there were non-printable characters in some rows since the normal function did not work and I modified it to replace non-printable characters with normal space.</p>  

<br>

<h2>STEP 3: Second normal form.</h2>  

<p> The goal of Second Normal Form (2NF) is to remove partial dependencies:
every non-key attribute must be fully functionally dependent on the primary key. In
the First Normal Form (1NF) structure, there were partial dependencies between the
CRN and some course-specific attributes, as well as between the ISBN and author
details, indicate a need to separate attributes into distinct tables further to remove
these dependencies. I begin by locating and getting rid of partial dependencies to reach 2NF. Features such as the course name and textbook information ought to be fully dependent on their corresponding main keys (the ISBN for textbooks and the CRN for courses), with no partial dependence on composite keys. This forces us to make three distinct tables with distinct primary keys (CRN, ISBN, and Author_ID, respectively) for each entity: courses, textbooks, and authors. After 2nd degree normalization we have 5 tables : Textbooks, Courses_Textbooks, Textbooks_Authors, Courses, Authors.</p> 

<br>  

<h2>STEP 4: Third normal form. </h2>

<p> In the Third Normal Form (3NF), the goal is to remove transitive dependencies and ensure that every non-key attribute is directly dependent on the primary key, rather than on any other non-key attribute. To achieve 3NF, each attribute should be directly related to the entity's primary key, avoiding indirect dependencies through other non-key attributes. In this case, the "Publisher address" attribute depends on the "Publisher" instead of the primary key (ISBN) in the Textbooks table. To address this transitive dependency, I created a Publisher table to store the publisher's name and address, with the publisher's name as the primary key, since it is unique. Additionally, I introduced a textbooks_publisher junction table to link each textbook with its publisher. The relationship between Textbooks and Publisher is many-to-one.</p>
