const express = require('express');
const { Pool } = require('pg');
const router = express.Router();
const db = require('./db');
const app = express();
const trigger = require('./trigger_server.js');
const functions = require('./functions_server.js');
const procedure = require('./procedure_server.js');

// Create a new connection pool to the PostgreSQL database
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: 'kathan1810',
  port: 5432,
});

// Set the view engine to EJS
app.set('view engine', 'ejs');


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

// Delete a product by ID
app.get('/delete/:id', (req, res) => {
  const id = req.params.id;
  pool.query('DELETE FROM product WHERE product_id = $1', [id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send('Server Error');
    } else {
      res.status(200).send(`Product ${id} deleted successfully`);
    }
  });
});

// routes to run trigger implemented in the database
app.get('/trigger', (req, res) => {
  trigger.RandRcreateTrigger ();
  trigger.EmployeecreateTrigger();
  trigger.PricemonitoringcreateTrigger ();
  res.render('trigger');
});
// routes to run functions implemented in the database
app.get('/functions', (req, res) => {
  functions.getTopEmployeesBySales ();
  functions.getProductPerformance() ;
  functions.getMaxSalesDays ();
  res.render('functions');
});
// routes to run procedure implemented in the database
app.get('/procedure', (req, res) => {
  get_product_sales();
  get_top_customers ();
  get_top_selling_products  ();
  get_store_sales ();
  res.render('procedure');
});


app.listen(3000, () => {
  console.log('Server started on port 3000');
});

