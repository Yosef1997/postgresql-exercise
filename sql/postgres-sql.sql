-- Drop tables if they exist
DROP TABLE IF EXISTS "order" CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS shipment CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS coupon CASCADE;
DROP TABLE IF EXISTS orderCoupons CASCADE;
DROP TABLE IF EXISTS orderpayments CASCADE;
DROP TABLE IF EXISTS orderproducts CASCADE;

--Create merchant table
create table merchant (
	id SERIAL primary key,
	name VARCHAR(255) not null,
	address text not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP
);

--Create user table
create table "user" (
	id SERIAL primary key,
	name VARCHAR(255) not null,
	address text not null,
	phone VARCHAR(15) not null,
	credit DECIMAL(10, 2) not null,
	coins DECIMAL(10, 2) not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP
);

--Create shipment table
create table shipment (
	id SERIAL primary key,
	name VARCHAR(255) not null,
	fee DECIMAL(10, 2) not null,
	insuranceFee DECIMAL(10,2) not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP
);

--Create payment table
create table payment (
	id SERIAL primary key,
	name VARCHAR(255) not null,
	fee DECIMAL(10, 2) not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP
);

--Create coupon table
create table coupon (
	id SERIAL primary key,
	name VARCHAR(255) not null,
	type VARCHAR(50) not null,
	amount DECIMAL(10, 2) not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP
);

--Create product table
create table product (
	id SERIAL primary key,
	name VARCHAR(255) not null,
	price DECIMAL(10, 2) not null,
	weight DECIMAL(10, 2) not null,
	merchantId INT not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP,
	constraint fk_merchant foreign key (merchantId) references merchant(id)
);

--Create order table
create table "order" (
	id SERIAL primary key,
	invoice VARCHAR(50) not null,
	userId INT not null,
	merchantId INT not null,
	shipmentId INT not null,
	orderAmount DECIMAL(10, 2) not null,
	isInsurance BOOLEAN not null,
	insuranceFee DECIMAL(10, 2) not null,
	shippingFee DECIMAL(10, 2) not null,
	appFee DECIMAL(10, 2) not null,
	serviceFee DECIMAL(10, 2) not null,
	updatedAt TIMESTAMP default CURRENT_TIMESTAMP,
	createdAt TIMESTAMP default CURRENT_TIMESTAMP,
	constraint fk_user foreign key (userId) references "user"(id),
	constraint fk_merchant foreign key (merchantId) references merchant(id),
	constraint fk_shipment foreign key (shipmentId) references shipment(id)
);

--Create order products table 
create table orderProducts (
	orderId INT not null,
	productId INT not null,
	primary key (orderId, productId),
	constraint fk_order foreign key (orderId) references "order"(id),
	constraint fk_product foreign key (productId) references product(id)
);

--Create order payment table
create table orderPayments (
	orderId INT not null,
	paymentId INT not null,
	primary key (orderId, paymentId),
	constraint fk_order foreign key (orderId) references "order"(id),
	constraint fk_payment foreign key (paymentId) references payment(id)
);

--Create order coupon table
create table orderCoupons (
	orderId INT not null,
	couponId INT not null,
	primary key (orderId, couponId),
	constraint fk_order foreign key (orderId) references "order"(id),
	constraint fk_coupon foreign key (couponId) references coupon(id)
);

--Insert data into merchant table
insert into merchant (name, address)
values ('COC Komputer', 'Jakarta');

--Insert data into user table
insert into "user" (name, address, phone, credit, coins)
values ('Sum Ting Wong', 'Digital Park, Sambau, Kecamatan Nongsa, Kota Batam, Kepulauan Riau 29466', '6281312341234', 100000.00, 1000.00);

-- Insert data into the shipment table
INSERT INTO shipment (name, fee, insuranceFee)
VALUES
('J&T - Ekonomi', 10.00, 2.00),
('J&T - Reguler', 20.00, 5.00);

-- Insert data into the payment table
INSERT INTO payment (name, fee)
VALUES
('BCA Virtual Account', 3.00),
('Gopay', 2.50);


-- Insert data into the coupon table
INSERT INTO coupon (name, type, amount)
VALUES
('Cashback DDDT845', 'Percentage', 10.00),
('Discount 5$', 'Flat', 5.00);

-- Insert data into the product table
INSERT INTO product (name, price, weight, merchantId)
VALUES
('SAPPHIRE NITRO+ Radeon RX 7900 XTX 24GB', 25000000.00, 5.00, 1);

-- Insert data into the order table
INSERT INTO "order" (invoice, userId, merchantId, shipmentId, orderAmount, isInsurance, insuranceFee, shippingFee, appFee, serviceFee)
VALUES
('INV0001', 1, 1, 1, 25000000.00, true, 2.00, 10.00, 1.00, 1.00);

-- Insert data into the orderProducts table
INSERT INTO orderProducts (orderId, productId)
VALUES
(1, 1);

-- Insert data into the orderPayments table
INSERT INTO orderPayments (orderId, paymentId)
VALUES
(1, 1);

-- Insert data into the orderCoupons table
INSERT INTO orderCoupons (orderId, couponId)
VALUES
(1, 1);

-- Select All order table
SELECT
    o.id AS order_id,
    o.invoice,
    u.name AS user_name,
    m.name AS merchant_name,
    s.name AS shipment_name,
    o.orderAmount,
    o.isInsurance,
    o.insuranceFee,
    o.shippingFee,
    o.appFee,
    o.serviceFee,
    o.updatedAt,
    o.createdAt,
    p.name AS product_name,
    pay.name AS payment_name,
    c.name AS coupon_name
FROM
    "order" o
JOIN
    "user" u ON o.userId = u.id
JOIN
    merchant m ON o.merchantId = m.id
JOIN
    shipment s ON o.shipmentId = s.id
LEFT JOIN
    orderProducts op ON o.id = op.orderId
LEFT JOIN
    product p ON op.productId = p.id
LEFT JOIN
    orderPayments opay ON o.id = opay.orderId
LEFT JOIN
    payment pay ON opay.paymentId = pay.id
LEFT JOIN
    orderCoupons oc ON o.id = oc.orderId
LEFT JOIN
    coupon c ON oc.couponId = c.id
WHERE
    o.userId = 1;