-- Jake Lunski
USE PizzaDB;

-- Lines 6-21 are for testing purposes bacuse I kept getting duplicate errors

SET @disable_inventory_trigger = 1;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE pizza_discount;
TRUNCATE TABLE order_discount;
TRUNCATE TABLE pizza_topping;
TRUNCATE TABLE pizza;
TRUNCATE TABLE dinein;
TRUNCATE TABLE pickup;
TRUNCATE TABLE delivery;
TRUNCATE TABLE ordertable;
TRUNCATE TABLE customer;
TRUNCATE TABLE baseprice;
TRUNCATE TABLE discount;
TRUNCATE TABLE topping;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO topping (topping_topName, topping_SmallAMT, topping_MedAMT, topping_LgAMT, topping_XLAMT, topping_CustPrice, topping_BusPrice, topping_MinINVT, topping_CurINVT) VALUES
('Pepperoni', 2, 2.75, 3.5, 4.5, 1.25, 0.20, 50, 100),
('Sausage', 2.5, 3.00, 3.5, 4.25, 1.25, 0.15, 50, 100),
('Ham', 2, 2.50, 3.25, 4.00, 1.50, 0.15, 25, 78),
('Chicken', 1.5, 2.00, 2.25, 3.00, 1.75, 0.25, 25, 56),
('Green Pepper', 1, 1.50, 2.00, 2.50, 0.50, 0.02, 25, 79),
('Onion', 1, 1.50, 2.00, 2.75, 0.50, 0.02, 25, 85),
('Roma Tomato', 2, 3.00, 3.50, 4.50, 0.75, 0.03, 10, 86),
('Mushrooms', 1.5, 2.00, 2.50, 3.00, 0.75, 0.10, 50, 52),
('Black Olives', 0.75, 1.00, 1.50, 2.00, 0.60, 0.10, 25, 39),
('Pineapple', 1, 1.25, 1.75, 2.00, 1.00, 0.25, 0, 15),
('Jalapenos', 0.5, 0.75, 1.25, 1.75, 0.50, 0.05, 0, 64),
('Banana Peppers', 0.6, 1.00, 1.30, 1.75, 0.50, 0.05, 0, 36),
('Regular Cheese', 2, 3.50, 5.00, 7.00, 0.50, 0.12, 50, 250),
('Four Cheese Blend', 2, 3.50, 5.00, 7.00, 1.00, 0.15, 25, 150),
('Feta Cheese', 1.75, 3.00, 4.00, 5.50, 1.50, 0.18, 0, 75),
('Goat Cheese', 1.6, 2.75, 4.00, 5.50, 1.50, 0.20, 0, 54),
('Bacon', 1, 1.50, 2.00, 3.00, 1.50, 0.25, 0, 89);

INSERT INTO discount (discount_DiscountName, discount_Amount, discount_IsPercent) VALUES
('Employee', 15, 1),
('Lunch Special Medium', 1, 0),
('Lunch Special Large', 2, 0),
('Specialty Pizza', 1.5, 0),
('Happy Hour', 10, 1),
('Gameday Special', 20, 1);

INSERT INTO baseprice (baseprice_Size, baseprice_CrustType, baseprice_CustPrice, baseprice_BusPrice) VALUES
('Small','Thin',3,0.5),
('Small','Original',3,0.75),
('Small','Pan',3.5,1),
('Small','Gluten-Free',4,2),
('Medium','Thin',5,1),
('Medium','Original',5,1.5),
('Medium','Pan',6,2.25),
('Medium','Gluten-Free',6.25,3),
('Large','Thin',8,1.25),
('Large','Original',8,2),
('Large','Pan',9,3),
('Large','Gluten-Free',9.5,4),
('XLarge','Thin',10,2),
('XLarge','Original',10,3),
('XLarge','Pan',11.5,4.5),
('XLarge','Gluten-Free',12.5,6);

-- Order 1- Dine in Table 21
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES ((SELECT customer_CustID FROM customer LIMIT 1),'dinein','2025-03-05 12:03:00',19.75,3.68,1);
SET @order1 = LAST_INSERT_ID();
INSERT INTO dinein (ordertable_OrderID, dinein_TableNum) VALUES (@order1,21);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order1,'Large','Thin','completed','2025-03-05 12:03:00',19.75,3.68);
SET @pizza1 = LAST_INSERT_ID();
SELECT topping_TopID INTO @rcID FROM topping WHERE topping_TopName='Regular Cheese';
SELECT topping_TopID INTO @pepID FROM topping WHERE topping_TopName='Pepperoni';
SELECT topping_TopID INTO @sausID FROM topping WHERE topping_TopName='Sausage';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza1, @rcID, 1);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza1, @pepID, 0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza1, @sausID, 0);
INSERT INTO pizza_discount (pizza_PizzaID, discount_DiscountID) 
  VALUES (@pizza1,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Lunch Special Large'));

-- Order 2: Dine in for Table 4
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES ((SELECT customer_CustID FROM customer LIMIT 1),'dinein','2025-04-03 12:05:00',19.78,4.63,1);
SET @order2 = LAST_INSERT_ID();
INSERT INTO dinein (ordertable_OrderID, dinein_TableNum) VALUES (@order2,4);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order2,'Medium','Pan','completed','2025-04-03 12:05:00',12.85,3.23);
SET @pizza2a = LAST_INSERT_ID();
SELECT topping_TopID INTO @fetaID FROM topping WHERE topping_TopName='Feta Cheese';
SELECT topping_TopID INTO @boID FROM topping WHERE topping_TopName='Black Olives';
SELECT topping_TopID INTO @rtID FROM topping WHERE topping_TopName='Roma Tomato';
SELECT topping_TopID INTO @mushID FROM topping WHERE topping_TopName='Mushrooms';
SELECT topping_TopID INTO @bpID FROM topping WHERE topping_TopName='Banana Peppers';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2a, @fetaID, 0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2a, @boID, 0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2a, @rtID, 0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2a, @mushID, 0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2a, @bpID, 0);
INSERT INTO pizza_discount (pizza_PizzaID, discount_DiscountID)
  VALUES (@pizza2a,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Lunch Special Medium')),
         (@pizza2a,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Specialty Pizza'));
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order2,'Small','Original','completed','2025-04-03 12:05:00',6.93,1.40);
SET @pizza2b = LAST_INSERT_ID();
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2b, @rcID, 0);
SELECT topping_TopID INTO @chickenID FROM topping WHERE topping_TopName='Chicken';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2b, @chickenID, 0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza2b, @bpID, 0);

-- Order 3 : Pickup by Andrew Wilkes-Krier Phone number : 8642545861 6 pizzas
INSERT INTO customer (customer_FName, customer_LName, customer_PhoneNum)
VALUES ('Andrew','Wilkes-Krier','8642545861');
SET @custAW = LAST_INSERT_ID();
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES (@custAW, 'pickup','2025-03-03 21:30:00',6*14.88,6*3.30,1);
SET @order3 = LAST_INSERT_ID();
INSERT INTO pickup (ordertable_OrderID, pickup_IsPickedUp) VALUES (@order3,1);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order3,'Large','Original','completed','2025-03-03 21:30:00',14.88,3.30);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order3,'Large','Original','completed','2025-03-03 21:30:00',14.88,3.30);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order3,'Large','Original','completed','2025-03-03 21:30:00',14.88,3.30);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order3,'Large','Original','completed','2025-03-03 21:30:00',14.88,3.30);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order3,'Large','Original','completed','2025-03-03 21:30:00',14.88,3.30);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order3,'Large','Original','completed','2025-03-03 21:30:00',14.88,3.30);
-- For every pizza in this order regular cheese and pepperoni
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID) FROM pizza WHERE ordertable_OrderID=@order3), @rcID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID) FROM pizza WHERE ordertable_OrderID=@order3), @pepID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+1 FROM pizza WHERE ordertable_OrderID=@order3), @rcID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+1 FROM pizza WHERE ordertable_OrderID=@order3), @pepID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+2 FROM pizza WHERE ordertable_OrderID=@order3), @rcID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+2 FROM pizza WHERE ordertable_OrderID=@order3), @pepID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+3 FROM pizza WHERE ordertable_OrderID=@order3), @rcID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+3 FROM pizza WHERE ordertable_OrderID=@order3), @pepID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+4 FROM pizza WHERE ordertable_OrderID=@order3), @rcID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+4 FROM pizza WHERE ordertable_OrderID=@order3), @pepID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+5 FROM pizza WHERE ordertable_OrderID=@order3), @rcID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES ((SELECT MIN(pizza_PizzaID)+5 FROM pizza WHERE ordertable_OrderID=@order3), @pepID,0);

-- Order 4 deliv Andrew Wilkes-Krier address- 115 Party Blvd, Anderson, SC 29621
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES ((SELECT customer_CustID FROM customer WHERE customer_FName='Andrew' AND customer_LName='Wilkes-Krier'),'delivery','2025-04-20 19:11:00',68.95,20.99,1);
SET @order4 = LAST_INSERT_ID();
INSERT INTO delivery (ordertable_OrderID, delivery_HouseNum, delivery_Street, delivery_City, delivery_State, delivery_Zip, delivery_IsDelivered)
VALUES (@order4,115,'Party Blvd','Anderson','SC',29621,1);
-- Pizza 1 XLarge, original, 27.94,9.19
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order4,'XLarge','Original','completed','2025-04-20 19:11:00',27.94,9.19);
SET @pizza4a = LAST_INSERT_ID();
SELECT topping_TopID INTO @fcbID FROM topping WHERE topping_TopName='Four Cheese Blend';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4a, @pepID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4a, @sausID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4a, @fcbID,1);
-- Pizza 2 XLarge, original, 31.50,6.25
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order4,'XLarge','Original','completed','2025-04-20 19:11:00',31.50,6.25);
SET @pizza4b = LAST_INSERT_ID();
SELECT topping_TopID INTO @hamID FROM topping WHERE topping_TopName='Ham';
SELECT topping_TopID INTO @pineID FROM topping WHERE topping_TopName='Pineapple';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4b, @hamID,1);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4b, @pineID,1);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4b, @fcbID,0);
INSERT INTO pizza_discount (pizza_PizzaID, discount_DiscountID)
  VALUES (@pizza4b,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Specialty Pizza'));
-- Pizza 3 -  XLarge, original, 26.75,5.55
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order4,'XLarge','Original','completed','2025-04-20 19:11:00',26.75,5.55);
SET @pizza4c = LAST_INSERT_ID();
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4c, @chickenID,0);
SELECT topping_TopID INTO @baconID FROM topping WHERE topping_TopName='Bacon';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4c, @baconID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza4c, @fcbID,1);
INSERT INTO order_discount (ordertable_OrderID, discount_DiscountID)
  VALUES (@order4,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Gameday Special'));

-- Order 5: pickup, Matt Engers Phone: 8644749953
INSERT INTO customer (customer_FName, customer_LName, customer_PhoneNum)
VALUES ('Matt','Engers','8644749953');
SET @custME = LAST_INSERT_ID();
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES (@custME, 'pickup','2025-03-02 17:30:00',28.70,7.84,1);
SET @order5 = LAST_INSERT_ID();
INSERT INTO pickup (ordertable_OrderID, pickup_IsPickedUp) VALUES (@order5,1);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order5,'XLarge','Gluten-Free','completed','2025-03-02 17:30:00',28.70,7.84);
SET @pizza5 = LAST_INSERT_ID();
SELECT topping_TopID INTO @gpID FROM topping WHERE topping_TopName='Green Pepper';
SELECT topping_TopID INTO @onionID FROM topping WHERE topping_TopName='Onion';
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza5, @gpID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza5, @onionID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza5, @rtID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza5, @mushID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza5, @boID,0);
INSERT INTO pizza_discount (pizza_PizzaID, discount_DiscountID)
  VALUES (@pizza5,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Specialty Pizza'));

-- Order 6 Delivery Frank Turner Phone: 8642328944 address: 6745 Wessex St, Anderson, SC 29621
INSERT INTO customer (customer_FName, customer_LName, customer_PhoneNum)
VALUES ('Frank','Turner','8642328944');
SET @custFT = LAST_INSERT_ID();
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES (@custFT, 'delivery','2025-03-02 18:17:00',25.81,3.64,1);
SET @order6 = LAST_INSERT_ID();
INSERT INTO delivery (ordertable_OrderID, delivery_HouseNum, delivery_Street, delivery_City, delivery_State, delivery_Zip, delivery_IsDelivered)
VALUES (@order6,6745,'Wessex St','Anderson','SC',29621,1);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order6,'Large','Thin','completed','2025-03-02 18:17:00',25.81,3.64);
SET @pizza6 = LAST_INSERT_ID();
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza6, @chickenID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza6, @gpID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza6, @onionID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza6, @mushID,0);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza6, @fcbID,1);

-- Order 7, Delivery Milo Auckerman, Phone: 8648785679 address: 8879 Suburban, Anderson, SC 29621
INSERT INTO customer (customer_FName, customer_LName, customer_PhoneNum)
VALUES ('Milo','Auckerman','8648785679');
SET @custMA = LAST_INSERT_ID();
INSERT INTO ordertable (customer_CustID, ordertable_OrderType, ordertable_OrderDateTime, ordertable_CustPrice, ordertable_BusPrice, ordertable_IsComplete)
VALUES (@custMA, 'delivery','2025-04-13 20:32:00',31.66,6,1);
SET @order7 = LAST_INSERT_ID();
INSERT INTO delivery (ordertable_OrderID, delivery_HouseNum, delivery_Street, delivery_City, delivery_State, delivery_Zip, delivery_IsDelivered)
VALUES (@order7,8879,'Suburban','Anderson','SC',29621,1);
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order7,'Large','Thin','completed','2025-04-13 20:32:00',18.00,2.75);
SET @pizza7a = LAST_INSERT_ID();
INSERT INTO pizza (ordertable_OrderID, pizza_Size, pizza_CrustType, pizza_PizzaState, pizza_PizzaDate, pizza_CustPrice, pizza_BusPrice)
VALUES (@order7,'Large','Thin','completed','2025-04-13 20:32:00',19.25,3.25);
SET @pizza7b = LAST_INSERT_ID();
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza7a, @fcbID,1);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza7b, @rcID,1);
INSERT INTO pizza_topping (pizza_PizzaID, topping_TopID, pizza_topping_IsDouble) VALUES (@pizza7b, @pepID,1);
INSERT INTO order_discount (ordertable_OrderID, discount_DiscountID)
  VALUES (@order7,(SELECT discount_DiscountID FROM discount WHERE discount_DiscountName='Employee'));

SET @disable_inventory_trigger = 0;
