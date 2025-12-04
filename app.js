/*
Citation for the following JS:
Date: 11/02/2025
Copied from: CS340 start app code 
Source URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-web-application-technology-2?module_item_id=25645131
*/

// ########################################
// SETUP
// ########################################

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 1041;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ROUTE HANDLERS
// ########################################


// READ ROUTES

//Route to home page 
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

//Route to patrons table
app.get('/patrons', async function (req, res) {
    try {
        const query1 = "SELECT Patrons.patronID, Patrons.name,Patrons.age, Patrons.gender, \
                        EmergencyContacts.name AS 'emergencyContactName' FROM Patrons JOIN EmergencyContacts ON \
                        Patrons.emergencyContactID = EmergencyContacts.emergencyContactID;";
        const query2 = "SELECT * FROM EmergencyContacts;";
        const [patrons] = await db.query(query1);
        const [contacts] = await db.query(query2);
        res.render('patrons', {patrons: patrons, contacts: contacts}); // Render the reservations.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

// Route to reservations page 
app.get('/reservations', async function (req, res) {
    try {
        // Display Reservations table 
        const query1 = "SELECT Reservations.reservationID, Patrons.name AS patronName, Reservations.date, Reservations.duration, Reservations.price, Reservations.comments\
        FROM Reservations\
        JOIN Patrons ON Reservations.patronID = Patrons.patronID;";
        const [reservations] = await db.query(query1);
        res.render('reservations', {reservations: reservations});
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});


// Route to classes page 
app.get('/classes', async function (req, res) {
    try {
        // Display Classes table 
        const query1 = "SELECT Classes.classID, Classes.name,Classes.level, Classes.price, Classes.weekDuration, Instructors.name AS 'instructorName'\
        FROM Classes\
        JOIN Instructors ON Instructors.instructorID = Classes.instructorID;";
        const [classes] = await db.query(query1);
        res.render('classes', {classes: classes});
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

//Route to emergency contacts page 
app.get('/emergency-contacts', async function (req, res) {
    try {
        // Display EmergencyContacts table 
        const query1 = "SELECT EmergencyContacts.emergencyContactID, EmergencyContacts.name,EmergencyContacts.email, EmergencyContacts.phoneNumber\
        FROM EmergencyContacts;";
        const [contacts] = await db.query(query1);
        res.render('emergency-contacts', {contacts: contacts}); // Render the reservations.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

// Route to instructors page 
app.get('/instructors', async function (req, res) {
    try {
        // Display Instructors table 
        const query1 = "SELECT Instructors.instructorID, Instructors.name,Instructors.email, Instructors.phoneNumber\
        FROM Instructors;";
        const [instructors] = await db.query(query1);
        res.render('instructors', {instructors:instructors}); // Render the reservations.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

// Route to class registration (aka PatronHasClasses) page 
app.get('/class-registration', async function (req, res) {
    try {
        // Display PatronsHasClasses table 
        const query1 = "SELECT PatronHasClasses.patronClassesID AS registrationID, PatronHasClasses.patronID, Patrons.name AS patronName, PatronHasClasses.classID, Classes.name AS className\
                FROM PatronHasClasses JOIN Patrons ON Patrons.patronID = PatronHasClasses.patronID\
                JOIN Classes ON Classes.classID = PatronHasClasses.classID ORDER BY registrationID ASC;";
        const query2 = "SELECT Classes.classID, Classes.name FROM Classes;";
        const query3 = "SELECT Patrons.patronID, Patrons.name FROM Patrons;";
        const [classinfo] = await db.query(query1);
        const [classes] = await  db.query(query2);
        const[patrons] =  await db.query(query3);
        res.render('class-registration', {classinfo: classinfo, classes: classes, patrons: patrons}); // Render the reservations.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});


// CREATE ROUTES

// Creates a patron 
app.post('/patrons/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.
        if (isNaN(parseInt(data.create_patron_age)))
            data.create_patron_age = null;
        if (isNaN(parseInt(data.create_patron_emergencycontact)))
            data.create_patron_emergencycontact = null;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreatePatron(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_patron_name,
            data.create_patron_age,
            data.create_patron_gender,
            data.create_patron_emergencycontact,
        ]);

        console.log(`CREATE Patrons. ID: ${rows.new_id}  +
            Name: ${data.create_patron_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/patrons');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// UPDATE ROUTES

// Update Patron
app.post('/patrons/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.
        if (isNaN(parseInt(data.update_patron_age)))
            data.update_patron_age = null;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_UpdatePatron(?, ?, ?);`;
        const query2 = `SELECT name FROM Patrons WHERE patronID = ?;`;
        await db.query(query1, [
            data.update_patron_id,
            data.update_patron_age,
            data.update_patron_emergencycontact,
        ]);
        // const [rows] = await db.query(query2, [data.update_patron_id]);

        // console.log(`UPDATE Patrons. ID: ${data.update_patron_id} ` +
        //     `Name: ${rows.name}`
        // );

        // Redirect the user to the updated webpage data
        res.redirect('/patrons');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// Updates class registration information 
app.post('/class-registration/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_UpdateClassRegistration(?, ?, ?);`;
        // const query2 = `SELECT name FROM Patrons WHERE patronID = ?;`;
        await db.query(query1, [
            data.update_registration_id,
            data.update_patron_id,
            data.update_class_id,
        ]);
        const [rows] = await db.query(query2, [data.update_patron_id]);

        console.log(`UPDATE Patrons. ID: ${data.update_patron_id} ` +
             `Name: ${rows.name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/class-registration');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Citation for the following function:
// Date: 11/14/2025
// Adapted from Github Copilot:
// Prompt used: "how do we implement a reset sp_pl in app.js and html, assuming our procedure is already written", with a follow up prompt of "how do you generalize the app.js so its not specific to patrons page and resets the whole database and all the other tables on different pages"
// Source URL: https://github.com/copilot/c/1dacc04b-b3b3-41d2-891b-b959387c78dd 

// GLOBAL RESET route (resets the entire database)
app.post('/reset', async function (req, res) {
    try {
        // Call the stored procedure to reset all tables
        const query = `CALL sp_load_aquamarinedb()`;  
        await db.query(query);

        console.log('Entire database reset successfully.');
        res.redirect('/');  
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send('An error occurred while resetting the database.');
    }
});
 

// DELETE ROUTES

// Deletes a patron 
app.post('/patrons/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeletePatron(?);`;
        await db.query(query1, [data.delete_patron_id]);

        console.log(`DELETE patron. ID: ${data.delete_patron_id} ` +
            `Name: ${data.delete_patron_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/patrons');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Deletes a class registration 
app.post('/class-registration/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteRegistration(?);`;
        await db.query(query1, [data.delete_registration_id]);

        console.log(`DELETE registration. ID: ${data.delete_registration_id} `
        );

        // Redirect the user to the updated webpage data
        res.redirect('/class-registration');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ########################################
// LISTENER
// ########################################
app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});