-- Select queries for all tables

SELECT Patrons.patronID, Patrons.name,Patrons.age, Patrons.gender, EmergencyContacts.name
FROM Patrons
JOIN EmergencyContacts ON Patrons.emergencyContactID = EmergencyContacts.emergencyContactID;

SELECT Classes.classID, Classes.name,Classes.level, Classes.price, Classes.weekDuration, Instructors.name
FROM Classes
JOIN Instructors ON Instructors.instructorID = Classes.instructorID;

SELECT EmergencyContacts.emergencyContactID, EmergencyContacts.name,EmergencyContacts.email, EmergencyContacts.phoneNumber
FROM EmergencyContacts;

SELECT Reservations.reservationID, Reservations.price,Reservations.duration, Reservations.date, Patrons.name, Reservations.comments
FROM Reservations
JOIN Patrons ON Reservations.patronID = Patrons.patronID;

SELECT PatronHasClasses.patronID, Patrons.name,PatronHasClasses.classID, Classes.name
FROM PatronHasClasses
JOIN Patrons ON Patrons.patronID = PatronHasClasses.patronID
JOIN Classes ON Classes.classID = PatronHasClasses.classID;

SELECT Instructors.instructorID, Instructors.name,Instructors.email, Instructors.phoneNumber
FROM Instructors;


-- Insert query for Patrons, where @ represents a user input variable from front-end

INSERT INTO Patrons (name, age, gender, emergencyContactID)
VALUES (@nameInput, @ageInput, @genderInput, @emergencyContactDropDownOpt);

-- Delete query for Patrons, where @ represents a user input variable from front-end

DELETE FROM Patrons
WHERE Patrons.patronID = @patronIDInput;

-- Update query for Patrons, where @ represents a user input variable from front-end

UPDATE Patrons
SET Patrons.@PatronattributeInput = @PatronAttributeValueInput
WHERE Patrons.patronID = @patronIDInput

-- Update query for PatronHasClasses, where @ represents a user input variable from front-end

UPDATE PatronHasClasses
SET PatronHasClasses.@attributeInput = @AttributeValueDropdownInput
WHERE PatronHasClasses.patronClassesID = @patronClassIDInput