/* 
Assignment 3 Part 2
Date: July 19, 2023

Group Member			Student Number
John Gu					200327450
Matthew Antonis 		200373088
Dain Shin 				200535561
Emily Rose 				200553504
Karsten Leung			200547539	

*/

-- Part 2

-- Create the database
CREATE DATABASE donation;
USE donation;

-- Create tables
CREATE TABLE donors (
	donor_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL, 
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    sign_up_for_mailing_list BOOLEAN
);

CREATE TABLE campaigns (
	campaign_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    campaign_name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE payment_information (
	payment_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    donor_id INT NOT NULL,
    credit_card_type VARCHAR(10) NOT NULL,
    card_number VARCHAR(16) NOT NULL,
    expiry_date VARCHAR(7) NOT NULL,
    cvv CHAR(3) NOT NULL,
    FOREIGN KEY(donor_id) REFERENCES donors(donor_id)
);


CREATE TABLE donation_information (
	donation_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    donor_id INT NOT NULL,
    date DATE NOT NULL,
    amount DECIMAL(6, 2) NOT NULL,
    note TEXT,
    keep_donation_confidential BOOLEAN,
    FOREIGN KEY(donor_id) REFERENCES donors(donor_id)
);



-- Insert data into donors
INSERT INTO donors (first_name, last_name, address, email, phone, sign_up_for_mailing_list) 
VALUES 
	('Rosa', 'Ruffner', '3846 St. Paul Street, St Catharines, ON, L2S 3A1', 'RoseMRuffner@pookmail.com', '905-401-7824', FALSE),
    ('Jack', 'Bradbury', '867 rue des Églises Est, Ste Cecile De Masham, QC, J0X 2W0', 'JackABradbury@spambob.com', '819-456-6014', TRUE),
    ('Eleanore', 'Sanders', '1145 47th Avenue, Grassland, AB, T0A 1V0', 'EleanoreRSanders@spambob.com', '780-525-6148', TRUE),
    ('Sophia', 'Reynolds', '639 Douglas St, North Bay, ON, P1B 5N9', 'S.Reynolds@proton.me', '705-472-2078', TRUE);


-- Insert data into campaigns
INSERT INTO campaigns (campaign_name, description)
VALUES
	('Keep it Wild', 'Habitat conservation in Canada’s boreal'),
    ('Nerdy about Nature', 'Citizen science training and outreach program'),
    ('Ripples of hope', 'Stream restoration'),
    ('Seeds of change', 'Tree planting ');
    

-- Inser data into payment_information
INSERT INTO payment_information (donor_id, credit_card_type, card_number, expiry_date, cvv)
VALUES
	(1, 'VISA', '4532462633596383', '01/2025', '672'),
    (2, 'MasterCard', '5477635202058042', '03/2024', '622'),
    (3, 'VISA', '4916449184987034', '08/2024', '373'),
    (4, 'VISA', '4916783223488976', '01/2027', '568');

-- Insert data into donation_information
INSERT INTO donation_information (donor_id, date, amount, note, keep_donation_confidential)
VALUES
	(1, '2022-08-14', 1000, 'Please see ensure to apply this donation towards the campaigns as indicated below. Thanks! - Rosa', TRUE),
    (2, '2022-09-15', 50, NULL, FALSE),
    (3, '2022-07-01', 200.20, 'Keep up the good work!!', FALSE),
    (4, '2023-07-07', 153.37, 'Keep up the good work!!', TRUE);



-- Create junction table 
CREATE TABLE donation_campaigns (
	donation_id INT NOT NULL,
    campaign_id INT NOT NULL,
    allocation 	DECIMAL(5,2) NOT NULL,
    allocated_amount DECIMAL(6,2),
	PRIMARY KEY (donation_id, campaign_id)
);

-- Add foreign keys
ALTER TABLE donation_campaigns
ADD FOREIGN KEY (donation_id) REFERENCES donation_information(donation_id),
ADD FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id);

-- Upload the .csv file to populate donation_campaigns with data

-- Calculate the allocated amount based on amount number and allocation percentage
UPDATE donation_campaigns AS a
JOIN donation_information AS d ON d.donation_id = a.donation_id
SET a.allocated_amount = (a.allocation / 100) * d.amount;