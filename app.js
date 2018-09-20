const express = require ('express');
const app = express ();
const morgan = require('morgan');
const bodyParser = require('body-parser');

const songRoutes = require('./api/routes/songList');
const userRoutes = require('./api/routes/userList');

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Conrol-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    if (req.method === 'OPTIONS') {
        res.header('Access-Control-Allow-Methods', 'POST, GET, PATCH, DELETE')
        return res.status(200).json({});
    };
})

app.use('/songList', songRoutes);
app.use('/userList', userRoutes);

app.use((req, res, next) => {
    const error = new Error('Not found!');
    error.status = 404;
    next(error);
});

app.use((error, req, res, nexr) => {
    res.status(error.status || 500);
    res.json({
        error: {
            message: error.message
        }
    });
});

module.exports = app;
