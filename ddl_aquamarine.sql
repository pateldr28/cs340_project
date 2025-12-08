/*
Group Members: Anvesha Kumar and Dristi Patel
Group Number: 9
Title: Aquamarine Swim Center 
All code on this file is our own
*/

DROP PROCEDURE IF EXISTS sp_load_aquamarinedb;
DELIMITER //
CREATE PROCEDURE sp_load_aquamarinedb()
BEGIN


SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

/*Classes: holds information of the classes available at the facility*/
DROP TABLE IF EXISTS `Classes`;
CREATE TABLE `Classes` (
  `classID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `level` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `weekDuration` int(11) NOT NULL,
  `instructorID` int(11) NOT NULL,
  PRIMARY KEY (`classID`),
  UNIQUE KEY `classID_UNIQUE` (`classID`),
  FOREIGN KEY (`instructorID`) REFERENCES `Instructors` (`instructorID`) ON DELETE CASCADE ON UPDATE NO ACTION
);


-- Sample data for Classes table
INSERT INTO `Classes` VALUES 
  (1,'Tadpole Splash',1,105,6,(SELECT instructorID from Instructors where name = 'Alex Chen')),
  (2,'Beginner Freestyle',2,125,8,(SELECT instructorID from Instructors where name = 'Ben Davis')),
  (3,'Intermediate Strokes',3,145,4,(SELECT instructorID from Instructors where name = 'Ben Davis')),
  (4,'Advanced Endurance',4,130,7,(SELECT instructorID from Instructors where name = 'Chris Lee'));


/*EmergencyContacts: stores the information of the Emergency Contact of the patron*/
DROP TABLE IF EXISTS `EmergencyContacts`;
CREATE TABLE `EmergencyContacts` (
  `emergencyContactID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `phoneNumber` varchar(12) NOT NULL,
  PRIMARY KEY (`emergencyContactID`),
  UNIQUE KEY `contactID_UNIQUE` (`emergencyContactID`)
);


-- Sample data for EmergencyContacts table
INSERT INTO `EmergencyContacts` VALUES 
  (1,'Jane Park','jane.park@email.com','541-555-2001'),
  (2,'Tom Green','tom.green@email.com','541-555-2002'),
  (3,'Linda Bell','linda.bell@email.com','541-555-2003'),
  (4,'David Kim','david.kim@email.com','541-555-2004'),
  (5,'Mark Jones','mark.jones@email.com','541-555-2005'),
  (6,'Sam Ngo','sam.ngo@email.com','541-555-2006'),
  (7,'Sofia Cruz','sofia.cruz@email.com','541-555-2007');

/*Instructors: records information of the instructors who work at the facility and optionally hold classes*/
DROP TABLE IF EXISTS `Instructors`;
CREATE TABLE `Instructors` (
  `instructorID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `phoneNumber` varchar(12) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`instructorID`),
  UNIQUE KEY `instructorID_UNIQUE` (`instructorID`)
);

-- Sample data for Instructors table
INSERT INTO `Instructors` VALUES 
  (1,'Alex Chen','541-555-1001','alex.chen@swim.com'),
  (2,'Ben Davis','541-555-1002','ben.davis@swim.com'),
  (3,'Chris Lee','541-555-1003','chris.lee@swim.com'),
  (4,'Dana Scott','541-555-1004','dana.scott@swim.com');


/*Patrons: records the details of the patrons who use the facility, including emergency contacts*/
DROP TABLE IF EXISTS `Patrons`;
CREATE TABLE `Patrons` (
  `patronID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(45) NOT NULL,
  `emergencyContactID` int(11) NOT NULL,
  PRIMARY KEY (`patronID`),
  UNIQUE KEY `patronID_UNIQUE` (`patronID`),
  KEY `fk_Patrons_EmergencyContacts1_idx` (`emergencyContactID`),
  FOREIGN KEY (`emergencyContactID`) REFERENCES `EmergencyContacts` (`emergencyContactID`) ON DELETE CASCADE ON UPDATE NO ACTION
  
); 

-- Sample data for Patrons table
INSERT INTO `Patrons` VALUES 
  (1,'Eliza Park',10,'Female',(SELECT emergencyContactID from EmergencyContacts where name = 'Jane Park')),
  (2,'Frank Green',8,'Male',(SELECT emergencyContactID from EmergencyContacts where name = 'Tom Green')),
  (3,'Gia Harris',9,'Female',(SELECT emergencyContactID from EmergencyContacts where name = 'Linda Bell')),
  (4,'Henry Kim',12,'Male',(SELECT emergencyContactID from EmergencyContacts where name = 'David Kim')),
  (5,'Ira Jones',15,'Male',(SELECT emergencyContactID from EmergencyContacts where name = 'Mark Jones')),
  (6,'Jasmine Lim',11,'Female',(SELECT emergencyContactID from EmergencyContacts where name = 'Linda Bell')),
  (7,'Kelly Ngo',14,'Female',(SELECT emergencyContactID from EmergencyContacts where name = 'Sam Ngo')),
  (8,'Leo Cruz',16,'Male',(SELECT emergencyContactID from EmergencyContacts where name = 'Sofia Cruz'));



/* PatronHasClasses: holds information of what classes patrons are taking*/
DROP TABLE IF EXISTS `PatronHasClasses`;
CREATE TABLE `PatronHasClasses` (
  `patronClassesID` int(11) NOT NULL AUTO_INCREMENT,
  `patronID` int(11) NOT NULL,
  `classID` int(11) NOT NULL,
  PRIMARY KEY (`patronClassesID`),
  -- PRIMARY KEY (`patronID`,`classID`),
  KEY `fk_Patrons_has_Classes_Classes1_idx` (`classID`),
  KEY `fk_Patrons_has_Classes_Patrons1_idx` (`patronID`),
  FOREIGN KEY (`classID`) REFERENCES `Classes` (`classID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (`patronID`) REFERENCES `Patrons` (`patronID`) ON DELETE CASCADE ON UPDATE NO ACTION 
); 


-- Sample data for PatronHasClasses table
INSERT INTO `PatronHasClasses`(`patronClassesID`,`patronID`, `classID`) VALUES (1,(SELECT patronID from Patrons where name = 'Eliza Park'),(SELECT classID from Classes where name = 'Tadpole Splash')),
(2,(SELECT patronID from Patrons where name = 'Eliza Park'),(SELECT classID from Classes where name = 'Beginner Freestyle')),
(3,(SELECT patronID from Patrons where name = 'Eliza Park'),(SELECT classID from Classes where name = 'Advanced Endurance')),
(4,(SELECT patronID from Patrons where name = 'Frank Green'),(SELECT classID from Classes where name = 'Tadpole Splash')),
(5,(SELECT patronID from Patrons where name = 'Frank Green'),(SELECT classID from Classes where name = 'Intermediate Strokes')),
(6,(SELECT patronID from Patrons where name = 'Gia Harris'),(SELECT classID from Classes where name = 'Tadpole Splash')),
(7,(SELECT patronID from Patrons where name = 'Gia Harris'),(SELECT classID from Classes where name = 'Beginner Freestyle')),
(8,(SELECT patronID from Patrons where name = 'Henry Kim'),(SELECT classID from Classes where name = 'Tadpole Splash')),
(9,(SELECT patronID from Patrons where name = 'Henry Kim'),(SELECT classID from Classes where name = 'Intermediate Strokes')),
(10,(SELECT patronID from Patrons where name = 'Ira Jones'),(SELECT classID from Classes where name = 'Beginner Freestyle')),
(11,(SELECT patronID from Patrons where name = 'Ira Jones'),(SELECT classID from Classes where name = 'Intermediate Strokes')),
(12,(SELECT patronID from Patrons where name = 'Jasmine Lim'),(SELECT classID from Classes where name = 'Beginner Freestyle')),
(13,(SELECT patronID from Patrons where name = 'Jasmine Lim'),(SELECT classID from Classes where name = 'Advanced Endurance')),
(14,(SELECT patronID from Patrons where name = 'Kelly Ngo'),(SELECT classID from Classes where name = 'Intermediate Strokes')),
(15,(SELECT patronID from Patrons where name = 'Kelly Ngo'),(SELECT classID from Classes where name = 'Advanced Endurance')),
(16,(SELECT patronID from Patrons where name = 'Leo Cruz'),(SELECT classID from Classes where name = 'Advanced Endurance'));


/*Reservations: stores the information of the reservations made in the system, including durations, dates and the patron who booked the space*/
DROP TABLE IF EXISTS `Reservations`;
CREATE TABLE `Reservations` (
  `reservationID` int(11) NOT NULL AUTO_INCREMENT,
  `duration` decimal(10,2) NOT NULL,
  `date` datetime NOT NULL,
  `patronID` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `comments` varchar(255) NOT NULL,
  PRIMARY KEY (`reservationID`),
  UNIQUE KEY `reservationID_UNIQUE` (`reservationID`),
  KEY `fk_Reservations_Patrons1_idx` (`patronID`),
  FOREIGN KEY (`patronID`) REFERENCES `Patrons` (`patronID`) ON DELETE CASCADE ON UPDATE NO ACTION
);


-- Sample data for Reservations table
INSERT INTO `Reservations` VALUES 
  (1,2.50,'2025-11-01 18:00:00',(SELECT patronID from Patrons where name = 'Eliza Park'),350,'Birthday Party'),
  (2,0.75,'2025-11-03 10:00:00',(SELECT patronID from Patrons where name = 'Henry Kim'),225,'Friend hangout'),
  (3,4.00,'2025-11-05 14:30:00',(SELECT patronID from Patrons where name = 'Kelly Ngo'),399,'Pool party'),
  (4,1.5,'2025-11-08 19:00:00',(SELECT patronID from Patrons where name = 'Ira Jones'),280,'Swim competition');



SET FOREIGN_KEY_CHECKS=1;
COMMIT;

END //

DELIMITER ;

