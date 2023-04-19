const express = require('express');
const { Pool } = require('pg');
const router = express.Router();
const db = require('./db');

// Create a new connection pool to the PostgreSQL database
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: 'kathan1810',
  port: 5432,
});

const app = express();

// Set the view engine to EJS
app.set('view engine', 'ejs');

// Define a route to fetch and display the "product" data
// app.get('/', async (req, res) => {
//    res.render('homepage')
// });
// app.get('/database', (req, res) => {
//     db.query('SELECT * FROM product,customer,employee,inventory, region, shipment,shipment_item,store,supplier', (err, result) => {
//       if (err) {
//         console.error(err);
//         res.status(500).send('Error fetching products');
//       } else {
//         res.render('database', { database: result.rows });
//       }
//     });
// });




app.get('/database', async (req, res) => {
  try {
    const productQuery = 'SELECT * FROM product';
    const inventoryQuery = 'SELECT * FROM inventory';
    const orderQuery = 'SELECT * FROM order_table';
    const orderItemQuery = 'SELECT * FROM order_item';
    const supplierQuery = 'SELECT * FROM supplier';
    const storeQuery = 'SELECT * FROM store';
    const shipmentItemQuery = 'SELECT * FROM shipment_item';
    const shipmentQuery = 'SELECT * FROM shipment';
    const employeeQuery = 'SELECT * FROM employee';
    const regionQuery = 'SELECT * FROM region';
    const customerQuery = 'SELECT * FROM customer';
    const refundQuery = 'SELECT * FROM refund_returns';

    const productResult = await pool.query(productQuery);
    const inventoryResult = await pool.query(inventoryQuery);
    const orderResult = await pool.query(orderQuery);
    const orderItemResult = await pool.query(orderItemQuery);
    const supplierResult = await pool.query(supplierQuery);
    const storeResult = await pool.query(storeQuery);
    const shipmentItemResult = await pool.query(shipmentItemQuery);
    const shipmentResult = await pool.query(shipmentQuery);
    const employeeResult = await pool.query(employeeQuery);
    const regionResult = await pool.query(regionQuery);
    const customerResult = await pool.query(customerQuery);
    const refundResult = await pool.query(refundQuery);

    res.render('database', {
      products: productResult.rows,
      inventory: inventoryResult.rows,
      orders: orderResult.rows,
      orderItems: orderItemResult.rows,
      suppliers: supplierResult.rows,
      stores: storeResult.rows,
      shipmentItems: shipmentItemResult.rows,
      shipments: shipmentResult.rows,
      employees: employeeResult.rows,
      regions: regionResult.rows,
      customers: customerResult.rows,
      refunds: refundResult.rows,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});



// const pool = new Pool({
//   user: 'postgres',
//   host: 'localhost',
//   database: 'postgres',
//   password: 'kathan1810',
//   port: 5432,
// });