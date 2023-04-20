const express = require('express');
const { Pool } = require('pg');
const router = express.Router();
const db = require('./db');
const app = express();


// Employee Performance 
const EmployeecreateTrigger = async () => {
    try {
        const request = pool.request();
        await request.query(`
            CREATE TRIGGER trg_UpdateEmployeePerformance
            ON Sales
            AFTER INSERT
            AS
            BEGIN
                DECLARE @EmployeeId INT
    
                SELECT @EmployeeId = EmployeeId FROM inserted
    
                UPDATE EmployeePerformance
                SET TotalSales = TotalSales + (SELECT SUM(Quantity * Price) FROM inserted WHERE EmployeeId = @EmployeeId)
                WHERE EmployeeId = @EmployeeId
            END
        `);
        console.log('EmployeecreateTrigger created successfully');
    } catch (err) {
        console.log(err);
    }
};


// Returns and Refunds 
// create a trigger function
const RandRcreateTrigger = async () => {
    try {
        const request = pool.request();
        await request.query(`
            CREATE TRIGGER trg_ReturnsAndRefunds
            ON Sales
            AFTER DELETE
            AS
            BEGIN
                DECLARE @ProductId INT
                DECLARE @Quantity INT
                DECLARE @StoreId INT
    
                SELECT @ProductId = ProductId, @Quantity = Quantity, @StoreId = StoreId FROM deleted
    
                UPDATE Product
                SET Quantity = Quantity + @Quantity
                WHERE ProductId = @ProductId
    
                UPDATE Inventory
                SET Quantity = Quantity + @Quantity
                WHERE ProductId = @ProductId AND StoreId = @StoreId
            END
        `);
        console.log('RandRcreateTrigger created successfully');
    } catch (err) {
        console.log(err);
    }
};




// Price monitoring 
// create a trigger function
const PricemonitoringcreateTrigger = async () => {
    try {
        const request = pool.request();
        await request.query(`
            CREATE TRIGGER trg_UpdateEmployeePerformance
            ON Sales
            AFTER INSERT
            AS
            BEGIN
                DECLARE @EmployeeId INT
    
                SELECT @EmployeeId = EmployeeId FROM inserted
    
                UPDATE EmployeePerformance
                SET TotalSales = TotalSales + (SELECT SUM(Quantity * Price) FROM inserted WHERE EmployeeId = @EmployeeId)
                WHERE EmployeeId = @EmployeeId
            END
        `);
        console.log('PricemonitoringcreateTrigger created successfully');
    } catch (err) {
        console.log(err);
    }
};



//call the trigger function to server.js
module.exports = {
    RandRcreateTrigger : RandRcreateTrigger ,
    EmployeecreateTrigger: EmployeecreateTrigger,
    PricemonitoringcreateTrigger : PricemonitoringcreateTrigger
};