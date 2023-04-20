CREATE TABLE region (
    region_id BIGSERIAL PRIMARY KEY,
    region_name VARCHAR(30),
    sales_actual INT,
    sales_targeted INT
);

INSERT INTO region (
    region_name,
    sales_actual,
    sales_targeted
) VALUES (
    'North India',
    100000,
    120000
), (
    'South India',
    80000,
    100000
), (
    'East India',
    75000,
    90000
), (
    'West India',
    90000,
    110000
);
 
CREATE TYPE customer_pay_method AS ENUM ('online', 'cash');
CREATE TABLE customer (
    customer_id BIGSERIAL PRIMARY KEY,
    customer_name VARCHAR(30),
    customer_phone BIGINT,
    customer_address VARCHAR(50),
    payment_method customer_pay_method
);
INSERT INTO customer (
    customer_name,
    customer_phone,
    customer_address,
    payment_method
) VALUES (
    'John Doe',
    9876543210,
    '123 Main St, Bengaluru',
    'online'
), (
    'Jane Doe',
    9876543211,
    '456 Park Rd, Mumbai',
    'cash'
), (
    'Bob Smith',
    9876543212,
    '789 Orchard Ave, Chennai',
    'online'
);



CREATE TYPE product_category AS ENUM ('food', 'clothes', 'household');

-- -- Product
CREATE TABLE product (
    product_id BIGSERIAL PRIMARY KEY,
    product_name VARCHAR(30),
    product_price INT,
    product_expiry_date DATE,
    product_type  product_category,
    product_supplier_id BIGSERIAL REFERENCES supplier(supplier_id),
    product_weight INT,
    product_cost INT,
    product_performance INT
);
INSERT INTO product (product_name, product_price, product_expiry_date, product_type, product_cost,   product_supplier_id,product_weight,product_cost,  product_performance  )
VALUES 
('t-shirt', 100, NULL, 'clothes',  50,),
('Milk', 20, '2023-05-01', 'food',  15),
('Eggs', 30, '2023-05-05', 'food',  25);


--store
CREATE TABLE store (
    store_id BIGSERIAL PRIMARY KEY,
    store_name VARCHAR(30),
    store_location VARCHAR(30),
    store_expenses INT,
    region_id BIGSERIAL REFERENCES region(region_id)
);
INSERT INTO store (
    store_name,
    store_location,
    store_expenses,
    region_id
) VALUES (
    'DMart Mumbai',
    'Mumbai',
    500000,
    3
), (
    'DMart Delhi',
    'Delhi',
    600000,
    1
), (
    'DMart Bangalore',
    'Bangalore',
    700000,
    2
);
(
    'DMart Bangalore',
    'Assam',
    700000,
    4
);
--employee
CREATE TYPE c_rate AS ENUM ('5','10','20');

CREATE TABLE employee (
    employee_id BIGSERIAL PRIMARY KEY,
    employee_name VARCHAR(30),
    employee_age INT,
    employee_phone INT(10),
    employee_address VARCHAR(50),
    commission_rate ENUM('5', '10', '20'),
    store_id BIGSERIAL REFERENCES store(store_id),
    employee_title VARCHAR(30)
);
INSERT INTO employee (
    employee_name,
    employee_age,
    employee_phone,
    employee_address,
    commission_rate,
    store_id,
    employee_title
) VALUES (
    'John Doe',
    25,
    9876543210,
    '123 Main St',
    '10',
    1,
    'Sales Associate'
), (
    'Jane Doe',
    35,
    9876543211,
    '456 Elm St',
    '5',
    2,
    'Cashier'
), (
    'Bob Smith',
    30,
    9876543212,
    '789 Oak St',
    '20',
    3,
    'Store Manager'
), (
    'Alice Johnson',
    40,
    9876543213,
    '234 Pine St',
    '10',
    4,
    'Assistant Manager'
);

--Supplier
CREATE TABLE supplier (
    supplier_id BIGSERIAL PRIMARY KEY,
    supplier_name VARCHAR(30),
    supplier_phone BIGINT
);
INSERT INTO supplier (
    supplier_name,
    supplier_phone
) VALUES (
    'ABC Suppliers',
    9876543210
), (
    'XYZ Traders',
    9123456780
), (
    'PQR Enterprises',
    9898989898
), (
    'LMN Distributors',
    9999999999
);

--product
CREATE TYPE product_category AS ENUM ('food','clothes','household');

CREATE TABLE product (
    product_id BIGSERIAL PRIMARY KEY,
    product_name VARCHAR(30) UNIQUE NOT NULL,
    product_price INT UNIQUE NOT NULL,
    product_expiry_date DATE,
    product_type product_category  NOT NULL,
    product_supplier_id BIGINT REFERENCES supplier(supplier_id),
    product_weight INT,
    product_cost INT,
    product_performance INT
);

INSERT INTO product (
    product_name,
    product_price,
    product_expiry_date,
    product_type,
    product_supplier_id,
    product_weight,
    product_cost,
    product_performance
) VALUES 
( 'Dove Soap', 40, '2023-06-30', 'household', 1, 100, 20, 4), 
( 'Tata Salt', 20, '2024-12-31', 'household', 2, 500, 15, 5), 
( 'Parle G', 10, '2023-09-30', 'food', 3, 200, 5, 2), 
( 't-shirt', 12, '2023-08-31', 'clothes', 4, 75, 10, 3);

CREATE TABLE inventory (
    inventory_id BIGSERIAL PRIMARY KEY,
    product_id BIGSERIAL REFERENCES product(product_id),
    product_name VARCHAR(30) UNIQUE REFERENCES product(product_name),
    product_type product_category REFERENCES product(product_type),
    store_id BIGSERIAL REFERENCES store(store_id),
    product_quantity_in INT,
    product_price INT UNIQUE REFERENCES product(product_price),
    lastupdated DATE
);

INSERT INTO inventory (
    product_id,
    product_name,
    product_type,
    store_id,
    product_quantity_in,
    product_price,
    lastupdated
) VALUES 

(1, 'Dove Soap', 'household', 1, 50, 40, '2023-04-18'),
(2, 'Tata Salt', 'household', 2, 100, 20, '2023-04-18'),
(3, 'Parle G', 'food', 3, 200, 10, '2023-04-18'),
(4, 't-shirt', 'clothes', 4, 75, 12, '2023-04-18');



CREATE TABLE shipment (
    shipment_id BIGSERIAL PRIMARY KEY,
    supplier_id BIGSERIAL REFERENCES supplier(supplier_id),
    shipment_date DATE,
    product_price INT UNIQUE REFERENCES product(product_price),
    store_id BIGSERIAL REFERENCES store(store_id),
    inventory_id BIGSERIAL REFERENCES inventory(inventory_id)
);
INSERT INTO shipment (
    supplier_id,
    shipment_date,
    product_price,
    store_id,
    inventory_id
) VALUES

( 1,  '2023-04-18',  40,  1,  1),
( 2,   '2023-04-18',   20,   1,   2),
( 3, '2023-04-18', 10, 2, 3),
( 4, '2023-04-18', 50, 2, 4);


CREATE TABLE shipment_item (
    shipment_id BIGSERIAL REFERENCES shipment(shipment_id),
    shipment_cost INT,
    shipment_item SET,
    -- product_cost INT UNIQUE REFERENCES product(product_cost),
    total_quantity INT,
    product_id BIGSERIAL REFERENCES product(product_id),
    individual_quantity INT,
    PRIMARY KEY (shipment_id, product_id)
);
INSERT INTO shipment_item (
    shipment_id,
    shipment_cost,
    shipment_item,
    product_cost,
    total_quantity,
    product_id,
    individual_quantity
) 
VALUES

( 1, 500, '{Dove Soap}',  150, 1, 75),
( 2, 500, '{Tata Salt}',  200, 2, 200),
( 3, 200, '{Parle G}',  300, 3, 250),
( 4, 200, '{t-shirt}',  100, 4, 100);

CREATE TABLE refund_returns (
    return_id BIGSERIAL PRIMARY KEY,
    order_id BIGSERIAL REFERENCES orders(order_id),
    product_id BIGSERIAL REFERENCES product(product_id),
    return_quantity INT,
    refund_amount INT,
    return_date DATE
);
INSERT INTO refund_returns (
    order_id,
    product_id,
    return_quantity,
    refund_amount,
    return_date
) VALUES    
-- data set 1
(1,1,2,180,'2023-04-15'
),

(2,2,1,20,'2023-04-14'
),

( 3, 3, 3, 60, '2023-04-13'
),

( 4, 4, 4, 4, '2023-04-12'
);