const express = require('express');
const moment = require('moment');
const { version } = require('./package.json');

const PORT = 8080;

const STARTUP_TIME = moment();

const app = express();
app.get('/', (req, res) => {
    res.send(`<!DOCTYPE html>\n
        <html>\n
        <head><title>SimpleExpressApp</title></head>\n
        <body>\n
        <p>Hello world!</p>
        <p>App version ${version}</p>
        <p>App started ${STARTUP_TIME.fromNow()}.</p>
        </body>\n
        </html>
    `);
});
app.get('/health', (req, res) => {
    res.json({ healthy: true });
});

app.listen(PORT);
console.log(`Running on port: ${PORT}`);
