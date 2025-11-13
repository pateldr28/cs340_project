/*
Citation for the following JS:
Date: 11/02/2025
Copied from: CS340 start app code 
Source URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-web-application-technology-2?module_item_id=25645131
*/

// ########################################
// ########## SETUP

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
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/bsg-people', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const query1 = `SELECT bsg_people.id, bsg_people.fname, bsg_people.lname, \
            bsg_planets.name AS 'homeworld', bsg_people.age FROM bsg_people \
            LEFT JOIN bsg_planets ON bsg_people.homeworld = bsg_planets.id;`;
        const query2 = 'SELECT * FROM bsg_planets;';
        const [people] = await db.query(query1);
        const [homeworlds] = await db.query(query2);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('bsg-people', { people: people, homeworlds: homeworlds });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

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


app.get('/reservations', async function (req, res) {
    try {
        const query1 = "SELECT Reservations.reservationID, Patrons.name AS patronName, Reservations.date, Reservations.duration, Reservations.price, Reservations.comments\
        FROM Reservations\
        JOIN Patrons ON Reservations.patronID = Patrons.patronID;";
        const [reservations] = await db.query(query1);
        //const [patrons] = await db.query(query2);
        res.render('reservations', {reservations: reservations});
        //res.render('reservations'); // Render the reservations.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});



app.get('/classes', async function (req, res) {
    try {
        const query1 = "SELECT Classes.classID, Classes.name,Classes.level, Classes.price, Classes.weekDuration, Instructors.name AS 'instructorName'\
        FROM Classes\
        JOIN Instructors ON Instructors.instructorID = Classes.instructorID;";
        const [classes] = await db.query(query1);
        //const [patrons] = await db.query(query2);
        res.render('classes', {classes: classes});
        //res.render('classes'); // Render the reservations.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/emergency-contacts', async function (req, res) {
    try {
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

app.get('/instructors', async function (req, res) {
    try {
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

app.get('/class-registration', async function (req, res) {
    try {
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
// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});
