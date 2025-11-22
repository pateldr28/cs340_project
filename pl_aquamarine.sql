/*
Citation for the following PL/SQL:
Date: 11/14/2025
Copied from: CS340 Implementing CUD operations in your app code
Source URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
*/
-- #############################
-- CREATE aquamarine
-- #############################
DROP PROCEDURE IF EXISTS sp_CreatePerson;

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