import express from 'express';
const port = 5000;
const app = express();
app.get('/', (req, res) => { res.send('Hello, world!'); });
app.listen(port, () => { console.log('Listening to port: ' + port); });

