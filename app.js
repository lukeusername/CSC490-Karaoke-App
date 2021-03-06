//Declaring Middleware to use
const express = require ('express');
const app = express ();
const morgan = require('morgan');
const bodyParser = require('body-parser');


//Set Request Route
const songRoutes = require('./api/routes/songList');
const userRoutes = require('./api/routes/userList');

//CORS Handling for AWS
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header(
      "Access-Control-Allow-Headers","Origin, X-Requested-With, Content-Type, Accept, Authorization");
    if (req.method === 'OPTIONS') {
        res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET');
        return res.status(200).json({});
    }
    next();
  });

//Intialize Morgan logger and body-parser for json.
app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(express.static('CSC490Website/public_html'));

//Intializes the URIs
app.use('/songList', songRoutes);
app.use('/userList', userRoutes);

//Returns error statuses when routes not reached correctly
app.use((req, res, next) => {
    const error = new Error('Not found!');
    error.status = 404;
    next(error);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    res.json({
        error: {
            message: error.message
        }
    });
});

module.exports = app;
