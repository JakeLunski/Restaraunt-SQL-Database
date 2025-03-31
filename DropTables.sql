-- Jake Lunski

USE PizzaDB;

-- Drop views
DROP VIEW IF EXISTS ProfitByOrderType;
DROP VIEW IF EXISTS ProfitByPizza;
DROP VIEW IF EXISTS ToppingPopularity;

-- Drop table
DROP TABLE IF EXISTS order_discount;
DROP TABLE IF EXISTS pizza_discount;
DROP TABLE IF EXISTS pizza_topping;
DROP TABLE IF EXISTS pizza;
DROP TABLE IF EXISTS dinein;
DROP TABLE IF EXISTS pickup;
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS ordertable;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS baseprice;
DROP TABLE IF EXISTS discount;
DROP TABLE IF EXISTS topping;

-- Reset the database
DROP SCHEMA IF EXISTS PizzaDB;
