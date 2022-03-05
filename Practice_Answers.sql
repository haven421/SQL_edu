USE classicmodels;

#1 Look at the contents of the Product Table.

SELECT *
FROM products;

#2 Select the product code and product name in products table.

SELECT productCode, productName
FROM products;

#3 List each possible product line without duplicates.

SELECT DISTINCT productLine
FROM productlines;

#4 Count the number of product lines.

SELECT COUNT(DISTINCT productLine)
FROM products;

#5 What is the total quantity of all products?

SELECT SUM(quantityInStock)
FROM products;

#6 Only show products that belong to a certain product line, such as motorocycles.

SELECT *
FROM products
WHERE productLine = 'motorcycles';

#7 What is the total quantity of motorcycles?

SELECT SUM(quantityInStock)
FROM products
WHERE productLine = 'motorcycles';

#8 List the MSRP and name of products whose MSRP is greater than 100.

SELECT MSRP, productName
FROM products
WHERE MSRP > 100;

#9 What is the minimum credit limit of customers? Maximum?

SELECT MIN(creditLimit)
FROM customers;

SELECT MAX(creditLimit)
FROM customers;

#10 List the customer(s) whose name starts with 'gift' or 'Gift' and includes 'gift' or 'Gift'.

SELECT customerName
FROM customers
WHERE customerName LIKE '%Gift%' OR customerName LIKE '%gift%';

#11 List the customer name(s) and credit limit for customers with the minimum credit limit. Hint: Subquery.

SELECT customerName, creditLimit
FROM customers
WHERE creditLimit = (SELECT MIN(creditLimit) FROM customers);

#12 How many total offices are in Boston, Paris, and Sydney? (Altogether).

SELECT COUNT(city)
FROM offices
WHERE city LIKE 'Boston' OR city LIKE 'Paris' OR city LIKE 'Sydney';

#13 How many products does each product line have? Hint: GROUP BY.

SELECT productLine,
	COUNT(productCode) AS TotalProducts
FROM products
GROUP BY productLine;

#14 What is the total amount of payments per date? Hint: GROUP BY.

SELECT paymentDate,
	COUNT(checkNumber) AS PmtPerDate
FROM payments
GROUP BY paymentDate;

#15 Report the sales representative number for each customer name.

SELECT customerName, salesRepEmployeeNumber
FROM customers;

#16 Show the customer's name and credit limit for credit limits less than 50,000.

SELECT customerName, creditLimit
FROM customers
WHERE creditLimit < 50000;

#17 Report customer's name, customer's number, and phone number who live in San Fran.

SELECT customerName, customerNumber, phone
FROM customers
WHERE city = 'San Francisco';

#18 Report the order numbers that have not been shipped. Hint: <>.

SELECT orderNumber
FROM orders
WHERE status <> 'shipped';

#19 What is the total amount paid by all customers?

SELECT SUM(amount) AS Total
FROM payments;

#20 How many orders have been placed by number 124?

SELECT customerNumber, COUNT(*) AS TotalOrders
FROM orders
WHERE customerNumber = 124;

#21 Report those payments greater than $100,000 or less than $2,000, ordered by amount from highest to lowest.

SELECT *
FROM payments
WHERE amount > 100000 OR amount < 2000
ORDER BY amount DESC;

#22 Report those payments greater than $100,000 ordered by customer number.

SELECT *
FROM payments
WHERE amount > 100000
ORDER BY customerNumber;

#23 List all customers containing 'Network' in their name.

SELECT *
FROM customers
WHERE customerName LIKE '%network%';

#24 List all customers whose data of state is missing.

SELECT *
FROM customers
WHERE state IS NULL;

# Start of Lab 6 M:M Queries

#25 List names of products sold by order date, earliest first.

SELECT p.productName, o.orderDate
FROM
	products p,
	orders o,
	orderdetails d
WHERE d.productCode = p.productCode
	AND o.orderNumber = d.orderNumber
ORDER BY o.orderDate ASC;

#26 List all the order dates in descending for orders for the '1940 Ford Pickup Truck'.

SELECT p.productName, o.orderDate
FROM
    products p,
    orders o,
    orderdetails od
WHERE	od.productCode = p.productCode
      AND o.orderNumber = od.orderNumber
      AND productName = '1940 Ford Pickup Truck'
ORDER BY o.orderDate DESC;

#27 Which shipped orders have a value greater than $5,000?

SELECT p.buyPrice, p.MSRP, o.orderNumber, o.status
FROM
	orders o,
	products p
WHERE p.MSRP < 5000
	AND o.status = 'Shipped';

#28 List the names of products sold at less than 85% of the MSRP (MSRP*0.85) for shipped orders.

SELECT DISTINCT p.productName, p.buyPrice, p.MSRP, o.status
FROM
	products p,
	orders o
WHERE buyPrice < (MSRP*.85)
	AND o.status = 'Shipped';

#29 Report products and their buy prices that have been sold with a markup of 100% or more. Meaning, where the priceEach is listed at least twice the buyPrice.

SELECT p.productNAme, p.buyPrice, d.priceEach
FROM
	products p,
	orderdetails d
WHERE p.productCode = d.productCode
	AND d.priceEach >= (p.buyPrice*2);

#30 List products ordered on a Monday. Do not list duplicates.
# unsure if below is correct

SELECT DISTINCT p.productName, o.orderDate, DAYNAME(o.orderDate)
FROM
	products p,
  orders o
WHERE DAYNAME(o.orderDate) = 'Monday'
GROUP BY orderDate;

#31 Show the quantity on hand and the quantity ordered for products listed on 'On Hold' orders.

SELECT DISTINCT p.productName, d.quantityOrdered, p.quantityInStock, o.status
FROM
	products p,
  orderdetails d,
  orders o
WHERE p.productCode = d.productCode
	AND o.status = 'On Hold';

# 32. Report the account rep for each customer. Use JOIN.

SELECT c.customerName, e.employeeNumber, e.firstName, e.lastName
FROM
	employees e,
  customers c
WHERE e.employeeNumber = c.salesRepEmployeeNumber
ORDER BY c.customerName;

# 33. Report total payments for Mini Wheels Co. Use JOIN and WHERE.

SELECT c.customerName, SUM(p.amount) AS TotalPayments
FROM
	customers c,
	payments p
WHERE c.customerNumber = p.customerNumber
	AND c.customerName = 'Mini Wheels Co.';

# 34. Who are the employees in Boston? Use JOIN and WHERE.

SELECT e.firstName, e.lastName, o.city
FROM
	employees e,
	offices o
WHERE e.officeCode = o.officeCode
	AND o.city = 'Boston';

# 35. Reoprt those payments, with customer name, greater than $100,000. Sort the report so the customer who made the highest payment appears first. Use JOIN and WHERE.

SELECT c.customerName, p.paymentDate, p.amount
FROM
	customers c,
  payments p
WHERE c.customerNumber = p.customerNumber
	AND p.amount > 100000
ORDER BY amount DESC;

# 36. Report the products that have not been sold. Use sub-query. (What products do not have order numbers.)

SELECT p.productName
FROM
	products p,
	orders o,
	orderdetails d
WHERE p.productCode = d.productCode
	AND d.orderNumber = o.orderNumber
    AND p.productName;

# 37. Report the total payments by date. Use GROUP BY.

SELECT *
FROM payments
GROUP BY paymentDate;

# 38. How many orders have been placed by Herkku Gifts? Use JOIN and WHERE

SELECT c.customerName, COUNT(DISTINCT d.orderNumber) AS Orders
FROM
	customers c,
	orderdetails d,
	orders o
WHERE c.customerNumber = o.customerNumber
	AND o.orderNumber = d.orderNumber
	AND c.customerName = 'Herkku Gifts';

# 38a. How many orders have been placed by each customer? Use JOIN and GROUP BY.

SELECT c.customerName, COUNT(DISTINCT d.orderNumber) AS Orders
FROM
	customers c,
	orderdetails d,
	orders o
WHERE c.customerNumber = o.customerNumber
	AND o.orderNumber = d.orderNumber
GROUP BY c.customerName;

# 39. List Customer Name, Customer Number and the amount paid by each customer. Sort results from highest to lowest total amount. Use JOIN and GROUP BY.

SELECT c.customerName, c.customerNumber, SUM(p.amount) AS AmtPerCustomer
FROM
	customers c,
	payments p
WHERE c.customerNumber = p.customerNumber
GROUP BY c.customerName
ORDER BY AmtPerCustomer DESC;

# 40. List the total value of each 'On Hold' order. Use JOIN, WHERE and GROUP BY.

SELECT d.orderNumber, o.status, SUM(d.priceEach*d.quantityOrdered) AS pricePerOrder
FROM
	orderdetails d,
  orders o
WHERE d.orderNumber = o.orderNumber
	AND o.status = 'On Hold'
GROUP BY o.orderNumber;

# 41. Report the number of 'Shipped' orders for each customer (with customer name.) Use JOIN, WHERE and GROUP BY.

SELECT o.customerNumber, c.customerName, count(*) as ShippedOrders
FROM
	orders o,
  customers c
WHERE o.customerNumber = c.customerNumber
	AND o.status = 'Shipped'
GROUP BY o.customerNumber, c.customerName;

# 42. Report the number of orders for each customer who has at least 5 orders. Use JOIN, GROUP BY, and HAVING.

SELECT o.customerNumber, c.customerName, COUNT(*)
FROM
	orders o,
  customers c
WHERE o.customerNumber = c.customerNumber
GROUP BY o.customerNumber
	HAVING count(*) >= 5;

SELECT customerNumber, customerName, COUNT(orderNumber) AS TotalOrders
FROM orders NATURAL JOIN customers
GROUP BY customerName
HAVING COUNT(orderNumber) >= 5;

# 43. Report the number of 'Shipped' orders for each customer who has more than 10 'Shipped' orders. Use JOIN, WHERE, GROUP BY and HAVING.

SELECT customerNumber, customerName, COUNT(*) AS ShippedOrders
FROM customers NATURAL JOIN orders
WHERE status = 'shipped'
GROUP BY customerNumber
HAVING COUNT(orderNumber) >= 10;

SELECT o.customerNumber, c.customerName, count(*)
FROM orders o, customers c
WHERE o.customerNumber = c.customerNumber
AND o.status = 'Shipped'
GROUP BY o.customerNumber, c.customerName
HAVING count(*) > 10;
