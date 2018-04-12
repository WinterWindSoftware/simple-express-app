const express = require('express');
const { version } = require('./package.json');

const PORT = 8080;

const app = express();
app.get('/', (req, res) => {
    res.send(`Hello world!\n App version ${version}`);
});
app.get('/health', (req, res) => {
    res.json({ healthy: true });
});

app.listen(PORT);
console.log(`Running on port: ${PORT}`);
