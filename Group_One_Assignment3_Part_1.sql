/* 
Assignment 3 Part 1
Date: July 19, 2023

Group Member			Student Number
John Gu					200327450
Matthew Antonis 		200373088
Dain Shin 				200535561
Emily Rose 				200553504
Karsten Leung			200547539	
*/

-- Step One
# Create and use database for part 1 of our group:
CREATE DATABASE Group_1_Assignment_3_Part_1;
USE Group_1_Assignment_3_Part_1;

# Open my_contacts_a3 and run the script to create and populate our table

-- Step Two

INSERT INTO my_contacts (last_name, first_name, email, gender, birthday, profession, postal_code, status, attributes, friends)
VALUES
  ('Smith', 'John', 'john.smith@burgerwang.com', 'M', '1985-03-15', 'Software Engineer', 'Toronto, M3A 1A1', 'single', 'Friendly;Hardworking', 'Jane Doe'),
  ('Doe', 'Jane', 'jane.doe@mumstouch.com', 'F', '1990-08-20', 'Graphic Designer', 'Ottawa, V5K 2P9', 'married', 'Creative;Organized', 'John Smith'),
  ('Lee', 'David', 'david.lee@dunkingdonut.com', 'M', '1979-11-03', 'Teacher', 'Mississauga, L4B 3P2', 'single', 'Patient;Knowledgeable', 'Sarah Johnson'),
  ('Johnson', 'Sarah', 'sarah.johnson@samsong.com', 'F', '1982-06-10', 'Doctor', 'Brampton, H2J 1X7', 'married', 'Empathetic;Caring', 'David Lee'),
  ('Kim', 'Sophia', 'sophia.kim@hyunda.com', 'F', '1995-02-25', 'Accountant', 'Hamilton, T2M 0K5', 'single', 'Detail-oriented;Analytical', 'Michael Brown'),
  ('Brown', 'Michael', 'michael.brown@gia.com', 'M', '1988-09-12', 'Marketing Manager', 'Markham, R3T 4S9', 'divorced', 'Creative;Adaptable', 'Sophia Kim'),
  ('Park', 'Daniel', 'daniel.park@pizzahat.com', 'M', '1983-07-05', 'Architect', 'Vaughan, L6G 1C5', 'single', 'Innovative;Precise', 'Emily Wilson'),
  ('Wilson', 'Emily', 'emily.wilson@tomhortons.com', 'F', '1991-04-30', 'Writer', 'Kitchener, B3H 3A6', 'married', 'Imaginative;Expressive', 'Daniel Park'),
  ('Choi', 'Hannah', 'hannah.choi@lenobo.com', 'F', '1998-12-08', 'Student', 'Windsor, N2L 3G1', 'single', 'Curious;Ambitious', 'Matthew Turner'),
  ('Turner', 'Matthew', 'matthew.turner@georgiac.com', 'M', '2000-01-18', 'Artist', 'Barrie, G1R 4K8', 'single', 'Creative;Passionate', 'Hannah Choi');

-- Step Three
# Add new column id, make it he Primary Key, and sit at the first position.
ALTER TABLE my_contacts
ADD COLUMN ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

# Add 3 columns to parse attribute valuse from the non-atomic column attributes
ALTER TABLE my_contacts
ADD COLUMN (
	attribute1 VARCHAR(20),
    attribute2 VARCHAR(20),
    attribute3 VARCHAR(20));
    
# Parses out atomic attribute1 from the attributes column
UPDATE my_contacts SET
	attribute1 = SUBSTRING_INDEX(attributes,';',1),
    attributes = SUBSTR(attributes,LENGTH(attribute1)+2)
WHERE LENGTH (attributes) > 0;
    
# Parses out atomic attribute2 from the attributes column
UPDATE my_contacts SET
	attribute2 = SUBSTRING_INDEX(attributes,';',1),
    attributes = SUBSTR(attributes,LENGTH(attribute2)+2)
WHERE LENGTH (attributes) > 0;
    
# Parses out atomic attribute3 from the attributes column
UPDATE my_contacts SET
	attribute3 = SUBSTRING_INDEX(attributes,';',1),
    attributes = SUBSTR(attributes,LENGTH(attribute2)+2)
WHERE LENGTH (attributes) > 0;

# Drop the attributes column as it is empty now
ALTER TABLE my_contacts
DROP COLUMN attributes;

# Create a new table attributes and union interest 1, 2, and 3
CREATE TABLE attributes AS
		SELECT attribute1 AS attribute
        FROM my_contacts
        WHERE attribute1 IS NOT NULL
	UNION
		SELECT attribute2 AS attribute
        FROM my_contacts
        WHERE attribute2 IS NOT NULL
    UNION
		SELECT attribute3 AS attribute
        FROM my_contacts
        WHERE attribute3 IS NOT NULL
ORDER BY attribute;
# Note: the Union operator will combine results and remove dupicate rows

# Add primary key ID for attribute table.
ALTER TABLE attributes
ADD COLUMN ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

# Create a junction table connectes my_contacts and attribute
CREATE TABLE contact_attributes AS
	SELECT mc.ID AS contact_id, a.ID AS attribute_id
    FROM my_contacts AS mc
    INNER JOIN attributes AS a
		ON mc.attribute1 = a.attribute 
        OR mc.attribute2 = a.attribute
        OR mc.attribute3 = a.attribute
ORDER BY mc.ID, a.ID;

# Add primary key and foreign key to the junction table contact_attributes
ALTER TABLE contact_attributes
	ADD PRIMARY KEY(contact_id, attribute_id),
    ADD FOREIGN KEY(contact_id) REFERENCES my_contacts(ID),
    ADD FOREIGN KEY(attribute_id) REFERENCES attributes(ID);
    
# Drop the unwanted/unnecessary columns
ALTER TABLE my_contacts
	DROP COLUMN attribute1,
    DROP COLUMN attribute2,
    DROP COLUMN attribute3;
    
# Add 2 columns to parse attribute valuse from the non-atomic column attributes
ALTER TABLE my_contacts
ADD COLUMN (
	friend1 VARCHAR(20),
    friend2 VARCHAR(20));
    
# Parses out atomic friend1 from the friends column
UPDATE my_contacts SET
	friend1 = SUBSTRING_INDEX(friends,';',1),
    friends = SUBSTR(friends,LENGTH(friend1)+2)
WHERE LENGTH (friends) > 0;

# Parses out atomic friend2 from the friends column
UPDATE my_contacts SET
	friend2 = SUBSTRING_INDEX(friends,';',1),
    friends = SUBSTR(friends,LENGTH(friend1)+2)
WHERE LENGTH (friends) > 0;

# Drop the friends column as it is empty now
ALTER TABLE my_contacts
DROP COLUMN friends;

# Create a new table friends and union friend1 and friend2
CREATE TABLE friends AS
		SELECT friend1 AS friend
        FROM my_contacts
        WHERE friend1 IS NOT NULL
	UNION
		SELECT friend2 AS friend
        FROM my_contacts
        WHERE friend2 IS NOT NULL
ORDER BY friend;

# Add primary key ID for friends table.
ALTER TABLE friends
ADD COLUMN ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

# Create a junction table connectes my_contacts and friends
CREATE TABLE contact_friends AS
	SELECT mc.ID AS contact_id, f.ID AS friend_id
    FROM my_contacts AS mc
    INNER JOIN friends AS f
		ON mc.friend1 = f.friend
        OR mc.friend2 = f.friend
ORDER BY mc.ID, f.ID;

# Add primary key and foreign key to the junction table contact_friends
ALTER TABLE contact_friends
	ADD PRIMARY KEY(contact_id, friend_id),
    ADD FOREIGN KEY(contact_id) REFERENCES my_contacts(ID),
    ADD FOREIGN KEY(friend_id) REFERENCES friends(ID);
    
# Drop the unwanted/unnecessary columns
ALTER TABLE my_contacts
	DROP COLUMN friend1,
    DROP COLUMN friend2;