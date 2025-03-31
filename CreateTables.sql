-- Jake Lunski

DROP SCHEMA IF EXISTS PizzaDB;
CREATE SCHEMA PizzaDB;
USE PizzaDB;

CREATE TABLE topping (
  topping_TopID INT AUTO_INCREMENT PRIMARY KEY,
  topping_TopName VARCHAR(30) NOT NULL,
  topping_SmallAMT DECIMAL(4,2) NOT NULL,
  topping_MedAMT DECIMAL(4,2) NOT NULL,
  topping_LgAMT DECIMAL(4,2) NOT NULL,
  topping_XLAMT DECIMAL(4,2) NOT NULL,
  topping_CustPrice DECIMAL(5,2) NOT NULL,
  topping_BusPrice DECIMAL(5,2) NOT NULL,
  topping_MinINVT INT NOT NULL,
  topping_CurINVT INT NOT NULL
);

CREATE TABLE discount (
  discount_DiscountID INT AUTO_INCREMENT PRIMARY KEY,
  discount_DiscountName VARCHAR(30) NOT NULL,
  discount_Amount DECIMAL(5,2) NOT NULL,
  discount_IsPercent TINYINT NOT NULL
);

CREATE TABLE baseprice (
  baseprice_Size VARCHAR(30) NOT NULL,
  baseprice_CrustType VARCHAR(30) NOT NULL,
  baseprice_CustPrice DECIMAL(5,2) NOT NULL,
  baseprice_BusPrice DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (baseprice_Size, baseprice_CrustType)
);

CREATE TABLE customer (
  customer_CustID INT AUTO_INCREMENT PRIMARY KEY,
  customer_FName VARCHAR(30) NOT NULL,
  customer_LName VARCHAR(30) NOT NULL,
  customer_PhoneNum VARCHAR(30) NOT NULL
);

CREATE TABLE ordertable (
  customer_CustID INT,
  ordertable_BusPrice DECIMAL(5,2) NOT NULL,
  ordertable_CustPrice DECIMAL(5,2) NOT NULL,
  ordertable_IsComplete TINYINT DEFAULT 0,
  ordertable_OrderDateTime DATETIME NOT NULL,
  ordertable_OrderID INT AUTO_INCREMENT PRIMARY KEY,
  ordertable_OrderType VARCHAR(30) NOT NULL,
  FOREIGN KEY (customer_CustID) REFERENCES customer(customer_CustID)
);

CREATE TABLE dinein (
  ordertable_OrderID INT NOT NULL,
  dinein_TableNum INT NOT NULL,
  PRIMARY KEY (ordertable_OrderID),
  FOREIGN KEY (ordertable_OrderID) REFERENCES ordertable(ordertable_OrderID)
);

CREATE TABLE pickup (
  ordertable_OrderID INT NOT NULL,
  pickup_IsPickedUp TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (ordertable_OrderID),
  FOREIGN KEY (ordertable_OrderID) REFERENCES ordertable(ordertable_OrderID)
);

CREATE TABLE delivery (
  ordertable_OrderID INT NOT NULL,
  delivery_HouseNum INT NOT NULL,
  delivery_Street VARCHAR(30) NOT NULL,
  delivery_City VARCHAR(30) NOT NULL,
  delivery_State VARCHAR(2) NOT NULL,
  delivery_Zip INT NOT NULL,
  delivery_IsDelivered TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (ordertable_OrderID),
  FOREIGN KEY (ordertable_OrderID) REFERENCES ordertable(ordertable_OrderID)
);

CREATE TABLE pizza (
  pizza_PizzaID INT AUTO_INCREMENT PRIMARY KEY,
  ordertable_OrderID INT NOT NULL,
  pizza_Size VARCHAR(30) NOT NULL,
  pizza_CrustType VARCHAR(30) NOT NULL,
  pizza_PizzaState VARCHAR(20) NOT NULL,
  pizza_PizzaDate DATETIME NOT NULL,
  pizza_CustPrice DECIMAL(7,2) NOT NULL,
  pizza_BusPrice DECIMAL(7,2) NOT NULL,
  FOREIGN KEY (ordertable_OrderID) REFERENCES ordertable(ordertable_OrderID),
  FOREIGN KEY (pizza_Size, pizza_CrustType) REFERENCES baseprice(baseprice_Size, baseprice_CrustType)
);

CREATE TABLE pizza_topping (
  pizza_PizzaID INT NOT NULL,
  topping_TopID INT NOT NULL,
  pizza_topping_IsDouble INT NOT NULL,
  PRIMARY KEY (pizza_PizzaID, topping_TopID),
  FOREIGN KEY (pizza_PizzaID) REFERENCES pizza(pizza_PizzaID),
  FOREIGN KEY (topping_TopID) REFERENCES topping(topping_TopID)
);

CREATE TABLE pizza_discount (
  pizza_PizzaID INT NOT NULL,
  discount_DiscountID INT NOT NULL,
  PRIMARY KEY (pizza_PizzaID, discount_DiscountID),
  FOREIGN KEY (pizza_PizzaID) REFERENCES pizza(pizza_PizzaID),
  FOREIGN KEY (discount_DiscountID) REFERENCES discount(discount_DiscountID)
);

CREATE TABLE order_discount (
  ordertable_OrderID INT NOT NULL,
  discount_DiscountID INT NOT NULL,
  PRIMARY KEY (ordertable_OrderID, discount_DiscountID),
  FOREIGN KEY (ordertable_OrderID) REFERENCES ordertable(ordertable_OrderID),
  FOREIGN KEY (discount_DiscountID) REFERENCES discount(discount_DiscountID)
);