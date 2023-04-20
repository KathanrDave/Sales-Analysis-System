CREATE OR REPLACE PROCEDURE get_store_sales(
    IN store_id BIGINT,
    IN start_date DATE,
    IN end_date DATE,
    OUT total_sales INT,
    OUT total_revenue INT
)
AS 
BEGIN
    SELECT SUM(quantity_total), SUM(order_price)
    INTO total_sales, total_revenue
    FROM order_item oi
    JOIN "order" o ON oi.order_id = o.order_id
    WHERE o.store_id = store_id AND o.order_date BETWEEN start_date AND end_date;
END;


CREATE OR REPLACE PROCEDURE get_product_sales(
    IN product_id VARCHAR(30),
    IN start_date DATE,
    IN end_date DATE,
    OUT total_sales INT,
    OUT total_revenue INT
)
AS 
BEGIN
    SELECT SUM(quantity_total), SUM(order_price)
    INTO total_sales, total_revenue
    FROM order_item oi
    JOIN "order" o ON oi.order_id = o.order_id
    JOIN inventory i ON oi.product_id = i.product_id AND o.store_id = i.store_id
    WHERE i.product_id = product_id AND o.order_date BETWEEN start_date AND end_date;
END;


CREATE OR REPLACE PROCEDURE get_top_selling_products(
    IN store_id BIGINT,
    IN start_date DATE,
    IN end_date DATE,
    IN limit_count INT,
    OUT products_sold TEXT[],
    OUT total_sales INT
)
AS 
BEGIN
    SELECT ARRAY_AGG(i.product_name), SUM(quantity_total)
    INTO products_sold, total_sales
    FROM order_item oi
    JOIN "order" o ON oi.order_id = o.order_id
    JOIN inventory i ON oi.product_id = i.product_id AND o.store_id = i.store_id
    WHERE o.store_id = store_id AND o.order_date BETWEEN start_date AND end_date
    GROUP BY i.product_name
    ORDER BY SUM(quantity_total) DESC
    LIMIT limit_count;
END;

CREATE OR REPLACE PROCEDURE get_product_profit(
    IN product_id VARCHAR(30),
    IN start_date DATE,
    IN end_date DATE,
    OUT total_revenue INT,
    OUT total_cost INT,
    OUT total_profit INT
)
AS 
BEGIN
    SELECT SUM(order_price), SUM(order_cost), SUM(order_price - order_cost)
    INTO total_revenue, total_cost, total_profit
    FROM order_item oi
    JOIN "order" o ON oi.order_id = o.order_id
    JOIN inventory i ON oi.product_id = i.product_id AND o.store_id = i.store_id
    WHERE i.product_id = product_id AND o.order_date BETWEEN start_date AND end_date;
END;


CREATE OR REPLACE PROCEDURE get_top_customers(
    IN store_id BIGINT,
    IN start_date DATE,
    IN end_date DATE,
    IN limit_count INT,
    OUT customer_names TEXT[],
    OUT total_purchases INT
)
AS 
BEGIN
    SELECT ARRAY_AGG(c.customer_name), SUM(oi.quantity_total)
    INTO customer_names, total_purchases
    FROM "order" o
    JOIN customer c ON o.customer_id = c.customer_id
    JOIN order_item oi ON o.order_id = oi.order_id
    WHERE o.store_id = store_id AND o.order_date BETWEEN start_date AND end_date
    GROUP BY c.customer_name
    ORDER BY SUM(oi.quantity_total) DESC
    LIMIT limit_count;
END;

