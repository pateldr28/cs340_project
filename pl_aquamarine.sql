/*
Citation for the following PL/SQL:
Date: 11/14/2025
Copied from: CS340 Implementing CUD operations in your app code
Source URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
All code on this page is adapted from this source
*/
-- #############################
-- CREATE patron
-- Creates a patron given input for a name, age, gender, and emergency contact
-- ID. Returns the patron ID of the newly created patron.
-- #############################
DROP PROCEDURE IF EXISTS sp_CreatePatron;

DELIMITER //
CREATE PROCEDURE sp_CreatePatron(
    IN name VARCHAR(255), 
    IN age INT(11), 
    IN gender VARCHAR(45), 
    IN emergencyContactID INT(11), 
    OUT p_id INT)
BEGIN
    INSERT INTO Patrons (name, age, gender, emergencyContactID) 
    VALUES (name, age, gender, emergencyContactID);

    SELECT LAST_INSERT_ID() into p_id;
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- UPDATE patron
-- Updates a patron given the patron ID of the patron whose info needs to be
-- changed, the age and the emergency contact ID info that the patron needs to
-- be changed to.
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdatePatron;

DELIMITER //
CREATE PROCEDURE sp_UpdatePatron(
    IN patronID INT, 
    IN age INT, 
    IN emergencyContactID INT)

BEGIN
    UPDATE Patrons SET Patrons.age = age, Patrons.emergencyContactID = emergencyContactID WHERE Patrons.patronID = patronID; 
END //
DELIMITER ;

-- #############################
-- DELETE patron
-- Deletes the patron given the patron ID as input. 
-- #############################
DROP PROCEDURE IF EXISTS sp_DeletePatron;

DELIMITER //
CREATE PROCEDURE sp_DeletePatron(IN patronID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        DELETE FROM Patrons WHERE Patrons.patronID = patronID;
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', patronID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- UPDATE class registration 
-- Updates the class registration information given the registrationID, patron
-- ID, and class ID as input. 
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateClassRegistration;

DELIMITER //
CREATE PROCEDURE sp_UpdateClassRegistration(
    IN registrationID INT, 
    IN patronID INT, 
    IN classID INT)

BEGIN
    UPDATE PatronHasClasses 
        SET PatronHasClasses.patronID = patronID, PatronHasClasses.classID = classID 
        WHERE PatronHasClasses.patronClassesID = registrationID; 
END //
DELIMITER ;

-- #############################
-- DELETE registration
-- Delets the registration information given the registration ID given as input. 
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteRegistration;

DELIMITER //
CREATE PROCEDURE sp_DeleteRegistration(IN registrationID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        DELETE FROM PatronHasClasses WHERE patronClassesID = registrationID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', registrationID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE registration
-- Creates a registration given input for a patron ID and class ID
-- ID. Returns the registration ID of the newly created registration.
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateRegistration;

DELIMITER //
CREATE PROCEDURE sp_CreateRegistration(
    IN patronID INT, 
    IN classID INT, 
    OUT registrationID INT)
BEGIN
    INSERT INTO PatronHasClasses (patronID, classID)
    VALUES (patronID, classID);

    SELECT LAST_INSERT_ID() into registrationID;
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;
