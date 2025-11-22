/*
Citation for the following PL/SQL:
Date: 11/14/2025
Copied from: CS340 Implementing CUD operations in your app code
Source URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
*/
-- #############################
-- CREATE patron
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

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_id';

    -- Example of how to get the ID of the newly created person:
        -- CALL sp_CreatePerson('Theresa', 'Evans', 2, 48, @new_id);
        -- SELECT @new_id AS 'New Person ID';
END //
DELIMITER ;

-- #############################
-- UPDATE patron
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
-- #############################
DROP PROCEDURE IF EXISTS sp_DeletePerson;

DELIMITER //
CREATE PROCEDURE sp_DeletePatron(IN p_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both bsg_people table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM Patrons WHERE patronID = p_id;
        -- DELETE FROM bsg_people WHERE id = p_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', p_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;