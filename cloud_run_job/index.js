
const express = require('express');
const app = express();
const port = +process.env['PORT'];

const waitMs = async ms => {
    return new Promise((accept, _) => {
        setTimeout(accept, ms);
    });
};

app.post('/', async (_, res) => {
    console.info('Beginning long running job...');
    await waitMs(10000);
    if (Math.random() >= 0.5) {
        // Success
        res.status(200);
        res.send(`Long running job complete. Result: success`);
    } else {
        // Fail
        res.status(500);
        res.send(`Long running job complete. Result: failure`);
    }    
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
});
