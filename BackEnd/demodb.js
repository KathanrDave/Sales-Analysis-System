const { Pool } = require('pg')
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'dbms_project_sas',
  password: 'kathan1810',
  port: 3000,
})
pool.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});
pool.query('Select * from demo', (err, res) => {
    if (!err) {
        console.log(res.rows);
    }
    else {
        console.log(err.message);
    }
    pool.end;
})
