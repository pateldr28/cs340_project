/*
Group Members: Anvesha Kumar and Dristi Patel
Group Number: 9
Title: Aquamarine Swim Center 
Project Step 2 
*/

/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.27-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_pateldr
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
--
-- Table structure for table `Classes`
--
/*Classes: holds information of the classes available at the facility*/

DROP TABLE IF EXISTS `Classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Classes` (
  `classID` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `level` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `weekDuration` int(11) NOT NULL,
  `instructorID` int(11) NOT NULL,
  PRIMARY KEY (`classID`,`instructorID`),
  UNIQUE KEY `classID_UNIQUE` (`classID`),
  KEY `fk_Classes_Instructors1_idx` (`instructorID`),
  CONSTRAINT `fk_Classes_Instructors1` FOREIGN KEY (`instructorID`) REFERENCES `Instructors` (`instructorID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Classes`
--

LOCK TABLES `Classes` WRITE;
/*!40000 ALTER TABLE `Classes` DISABLE KEYS */;
INSERT INTO `Classes` VALUES (1,'Tadpole Splash',1,105,6,1),(2,'Beginner Freestyle',2,125,8,2),(3,'Intermediate Strokes',3,145,4,2),(4,'Advanced Endurance',4,130,7,3);
/*!40000 ALTER TABLE `Classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmergencyContacts`
--
/*EmergencyContacts: stores the information of the Emergency Contact of the patron*/

DROP TABLE IF EXISTS `EmergencyContacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmergencyContacts` (
  `emergencyContactID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `phoneNumber` varchar(12) NOT NULL,
  PRIMARY KEY (`emergencyContactID`),
  UNIQUE KEY `contactID_UNIQUE` (`emergencyContactID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmergencyContacts`
--

LOCK TABLES `EmergencyContacts` WRITE;
/*!40000 ALTER TABLE `EmergencyContacts` DISABLE KEYS */;
INSERT INTO `EmergencyContacts` VALUES (1,'Jane Park','jane.park@email.com','541-555-2001'),(2,'Tom Green','tom.green@email.com','541-555-2002'),(3,'Linda Bell','linda.bell@email.com','541-555-2003'),(4,'David Kim','david.kim@email.com','541-555-2004'),(5,'Mark Jones','mark.jones@email.com','541-555-2005'),(6,'Sam Ngo','sam.ngo@email.com','541-555-2006'),(7,'Sofia Cruz','sofia.cruz@email.com','541-555-2007');
/*!40000 ALTER TABLE `EmergencyContacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Instructors`
--
/*Instructors: records information of the instructors who work at the facility and optionally hold classes*/

DROP TABLE IF EXISTS `Instructors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Instructors` (
  `instructorID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `phoneNumber` varchar(12) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`instructorID`),
  UNIQUE KEY `instructorID_UNIQUE` (`instructorID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Instructors`
--

LOCK TABLES `Instructors` WRITE;
/*!40000 ALTER TABLE `Instructors` DISABLE KEYS */;
INSERT INTO `Instructors` VALUES (1,'Alex Chen','541-555-1001','alex.chen@swim.com	'),(2,'Ben Davis','541-555-1002','ben.davis@swim.com	'),(3,'Chris Lee','541-555-1003','chris.lee@swim.com	'),(4,'Dana Scott','541-555-1004','dana.scott@swim.com	');
/*!40000 ALTER TABLE `Instructors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PatronHasClasses`
--
/* PatronHasClasses: holds information of what classes patrons are taking*/

DROP TABLE IF EXISTS `PatronHasClasses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PatronHasClasses` (
  `patronID` int(11) NOT NULL,
  `classID` int(11) NOT NULL,
  PRIMARY KEY (`patronID`,`classID`),
  KEY `fk_Patrons_has_Classes_Classes1_idx` (`classID`),
  KEY `fk_Patrons_has_Classes_Patrons1_idx` (`patronID`),
  CONSTRAINT `fk_Patrons_has_Classes_Classes1` FOREIGN KEY (`classID`) REFERENCES `Classes` (`classID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Patrons_has_Classes_Patrons1` FOREIGN KEY (`patronID`) REFERENCES `Patrons` (`patronID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PatronHasClasses`
--

LOCK TABLES `PatronHasClasses` WRITE;
/*!40000 ALTER TABLE `PatronHasClasses` DISABLE KEYS */;
INSERT INTO `PatronHasClasses` VALUES (1,1),(1,2),(1,4),(2,1),(2,3),(3,1),(3,2),(4,1),(4,3),(5,2),(5,3),(6,2),(6,4),(7,3),(7,4),(8,1);
/*!40000 ALTER TABLE `PatronHasClasses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Patrons`
--
/*Patrons: records the details of the patrons who use the facility, including emergency contacts*/

DROP TABLE IF EXISTS `Patrons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Patrons` (
  `patronID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(45) NOT NULL,
  `emergencyContactID` int(11) NOT NULL,
  PRIMARY KEY (`patronID`,`emergencyContactID`),
  UNIQUE KEY `patronID_UNIQUE` (`patronID`),
  KEY `fk_Patrons_EmergencyContacts1_idx` (`emergencyContactID`),
  CONSTRAINT `fk_Patrons_EmergencyContacts1` FOREIGN KEY (`emergencyContactID`) REFERENCES `EmergencyContacts` (`emergencyContactID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Patrons`
--

LOCK TABLES `Patrons` WRITE;
/*!40000 ALTER TABLE `Patrons` DISABLE KEYS */;
INSERT INTO `Patrons` VALUES (1,'Eliza Park',10,'Female',1),(2,'Frank Green',8,'Male',2),(3,'Gia Harris',9,'Female',3),(4,'Henry Kim',12,'Male',4),(5,'Ira Jones',15,'Male',5),(6,'Jasmine Lim',11,'Female',3),(7,'Kelly Ngo',14,'Female',6),(8,'Leo Cruz',16,'Male',7);
/*!40000 ALTER TABLE `Patrons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservations`
--
/*Reservations: stores the information of the reservations made in the system, including durations, dates and the patron who booked the space*/

DROP TABLE IF EXISTS `Reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reservations` (
  `reservationID` int(11) NOT NULL AUTO_INCREMENT,
  `duration` decimal(10,2) NOT NULL,
  `date` datetime NOT NULL,
  `patronID` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `comments` varchar(255) NOT NULL,
  PRIMARY KEY (`reservationID`,`patronID`),
  UNIQUE KEY `reservationID_UNIQUE` (`reservationID`),
  KEY `fk_Reservations_Patrons1_idx` (`patronID`),
  CONSTRAINT `fk_Reservations_Patrons1` FOREIGN KEY (`patronID`) REFERENCES `Patrons` (`patronID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservations`
--

LOCK TABLES `Reservations` WRITE;
/*!40000 ALTER TABLE `Reservations` DISABLE KEYS */;
INSERT INTO `Reservations` VALUES (1,2.5,'2025-11-01 18:00:00',1,350,'Birthday Party '),(2,0.75,'2025-11-03 10:00:00',4,225,'Friend hangout'),(3,4,'2025-11-05 14:30:00',7,399,'Pool party'),(4,1.5,'2025-11-08 19:00:00',5,280,'Swim competition ');
/*!40000 ALTER TABLE `Reservations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-26 20:01:35

SET FOREIGN_KEY_CHECKS=1;
COMMIT;

