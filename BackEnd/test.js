const express = require('express');
const app = express();
const cors  = require("cors");
const port_back = 5432;

app.get('/', (req, res) => {
  res.send('Hello!');
});

//midddleware
app.use(cors());
app.use(express.json());

app.listen(port_back, () => {
  console.log(`Example app listening at http://localhost:${port_back}`);
});
