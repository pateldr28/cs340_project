-- Select queries for all tables

-- Displays the patronID, name, age, gender, and emergency contact name of patrons from the Patrons Table
SELECT Patrons.patronID, Patrons.name, Patrons.age, Patrons.gender, EmergencyContacts.name
FROM Patrons
JOIN EmergencyContacts ON Patrons.emergencyContactID = EmergencyContacts.emergencyContactID;

-- Displays the classID, name, level, duration of weeks, and instructor name from the Classes table
SELECT Classes.classID, Classes.name,Classes.level, Classes.price, Classes.weekDuration, Instructors.name
FROM Classes
JOIN Instructors ON Instructors.instructorID = Classes.instructorID;

-- Displays the emergencyContactID, name, email, and phone number of the EmergencyContacts Table
SELECT EmergencyContacts.emergencyContactID, EmergencyContacts.name,EmergencyContacts.email, EmergencyContacts.phoneNumber
FROM EmergencyContacts;

-- Displays the reservationsID, price, duration, data, name of patron for the reservation, 
-- and reservation comments from the reservations table
SELECT Reservations.reservationID, Reservations.price,Reservations.duration, Reservations.date, Patrons.name, Reservations.comments
FROM Reservations
JOIN Patrons ON Reservations.patronID = Patrons.patronID;

-- Displays the patronID, name, classID, and the class name from the PatronHasClasses Table
SELECT PatronHasClasses.patronID, Patrons.name,PatronHasClasses.classID, Classes.name
FROM PatronHasClasses
JOIN Patrons ON Patrons.patronID = PatronHasClasses.patronID
JOIN Classes ON Classes.classID = PatronHasClasses.classID;

SELECT Instructors.instructorID, Instructors.name,Instructors.email, Instructors.phoneNumber
FROM Instructors;


-- Insert query for Patrons, where @ represents a user input variable from front-end (Creates patron)
INSERT INTO Patrons (name, age, gender, emergencyContactID)
VALUES (@PatronnameInput, @PatronAgeInput, @PatronGenderInput, @EmergencyContactInput);

-- Delete query for Patrons, where @ represents a user input variable from front-end (Deletes patron)
DELETE FROM Patrons
WHERE Patrons.patronID = @patronIDInput;

-- Update query for Patrons, where @ represents a user input variable from front-end (Updates patron info)
UPDATE Patrons
SET Patrons.age = @PatronAgeInput, Patrons.emergencyContactID= @EmergencyContactInput
WHERE Patrons.patronID = @patronIDInput

-- Update query for PatronHasClasses, where @ represents a user input variable from front-end (Update patron has classes info)
UPDATE PatronHasClasses
SET PatronHasClasses.patronID = @patronIDInput, PatronHasClasses.classID= @ClassIDInput
WHERE PatronHasClasses.patronClassesID = @patronClassIDInput

-- Delete query for Patrons, where @ represents a user input variable from front-end (Delete from PatronHasClasses table )
DELETE FROM PatronHasClasses
WHERE Patrons.patronID = @patronIDInput;