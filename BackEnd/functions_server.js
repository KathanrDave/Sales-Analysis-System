const express = require('express');
const { Pool } = require('pg');
const router = express.Router();
const db = require('./db');
const app = express();

async function getMaxSalesDays() {
    const client = await pool.connect();
    try {
      const query = 'SELECT day_of_week, SUM(order_price) AS total_sales FROM (SELECT to_char(order_date, \'Day\') AS day_of_week, order_price FROM "order") AS sales_by_day GROUP BY day_of_week ORDER BY total_sales DESC, day_of_week LIMIT 7;';
      const result = await client.query(query);
      return result.rows;
    } finally {
      client.release();
    }
  }
  
  async function getProductPerformance() {
    const client = await pool.connect();
  
    try {
      const query = 'SELECT product_id, product_name, COUNT(*) as sales FROM order_item INNER JOIN product ON order_item.product_id = product.product_id GROUP BY product_id ORDER BY sales DESC';
      const result = await client.query(query);
      return result.rows;
    } catch (error) {
      console.error(error);
    } finally {
      client.release();
    }
  }
  
  app.get('/quarterly-sales', async (req, res) => {
    try {
      const quarterlySalesQuery = `
        SELECT
          date_trunc('quarter', order_date) AS quarter,
          sum(order_price) AS quarterly_sales
        FROM
          "order"
        GROUP BY
          quarter
        ORDER BY
          quarter;
      `;
      const { rows } = await pool.query(quarterlySalesQuery);
      res.json(rows);
    } catch (error) {
      console.error(error);
      res.status(500).send('Internal Server Error');
    }
  });

  const getTopEmployeesBySales = async () => {
    try {
      const query = `
        SELECT employee_id, SUM(total_sales) AS total_sales
        FROM sales
        GROUP BY employee_id
        ORDER BY total_sales DESC
        LIMIT (SELECT COUNT(*) * 0.05 FROM sales)
      `;
      const { rows } = await pool.query(query);
      return rows;
    } catch (err) {
      console.error(err);
    }
  };
  
  app.get('/top-customers', async (req, res) => {
    try {
      const results = await pool.query(`
        SELECT customers.customer_id, customers.first_name, customers.last_name, COUNT(*) AS total_purchases
        FROM customers
        JOIN orders ON customers.customer_id = orders.customer_id
        GROUP BY customers.customer_id, customers.first_name, customers.last_name
        ORDER BY total_purchases DESC
        LIMIT (SELECT COUNT(*) * 0.05 FROM orders)
      `);
  
      res.render('top-customers', { customers: results.rows });
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server Error');
    }
  });
  
  module.exports = {
  getTopEmployeesBySales :   getTopEmployeesBySales,
  getProductPerformance : getProductPerformance,
  getMaxSalesDays :  getMaxSalesDays
  
};