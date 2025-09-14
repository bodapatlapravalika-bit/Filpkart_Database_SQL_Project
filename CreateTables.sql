-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(35),
    state VARCHAR(25)
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(45),
    price DOUBLE PRECISION,
    cogs DOUBLE PRECISION,
    category VARCHAR(25),
    brand VARCHAR(25)
);

-- Sales Table
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    order_status VARCHAR(25),
    product_id INT,
    quantity INT,
    price_per_unit DOUBLE PRECISION,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Shippings Table
CREATE TABLE shippings (
    shipping_id INT PRIMARY KEY,
    order_id INT,
    shipping_date DATE,
    return_date DATE,
    shipping_providers VARCHAR(55),
    delivery_status VARCHAR(55),
    FOREIGN KEY (order_id) REFERENCES sales(order_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_status VARCHAR(55),
    FOREIGN KEY (order_id) REFERENCES sales(order_id)
);
