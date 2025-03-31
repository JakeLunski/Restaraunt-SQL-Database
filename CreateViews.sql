-- Jake Lunski

USE PizzaDB;

CREATE VIEW ToppingPopularity AS
SELECT 
  t.topping_topName AS Topping,
  CASE 
    WHEN t.topping_topName = 'Regular Cheese'
      THEN COALESCE(SUM(CASE WHEN pt.pizza_topping_IsDouble = 1 THEN 2 ELSE 1 END),0) - 1
    WHEN t.topping_topName = 'Four Cheese Blend'
      THEN COALESCE(SUM(CASE WHEN pt.pizza_topping_IsDouble = 1 THEN 2 ELSE 1 END),0) - 2
    WHEN t.topping_topName = 'Jalapenos'
      THEN COALESCE(SUM(CASE WHEN pt.pizza_topping_IsDouble = 1 THEN 2 ELSE 1 END),0) - 1
    ELSE 
      COALESCE(SUM(CASE WHEN pt.pizza_topping_IsDouble = 1 THEN 2 ELSE 1 END),0)
  END AS ToppingCount
FROM topping t
LEFT JOIN pizza_topping pt ON t.topping_TopID = pt.topping_TopID
GROUP BY t.topping_topName
ORDER BY ToppingCount DESC, t.topping_topName ASC;


CREATE VIEW ProfitByPizza AS
SELECT 
  pizza_Size AS Size,
  pizza_CrustType AS Crust,
  SUM(pizza_CustPrice - pizza_BusPrice) AS Profit,
  DATE_FORMAT(pizza_PizzaDate, '%c/%Y') AS OrderMonth
FROM pizza
GROUP BY pizza_Size, pizza_CrustType, DATE_FORMAT(pizza_PizzaDate, '%c/%Y')
ORDER BY Profit ASC;


CREATE VIEW ProfitByOrderType AS
(
  SELECT 
    ordertable_OrderType AS customerType,
    DATE_FORMAT(ordertable_OrderDateTime, '%c/%Y') AS OrderMonth,
    SUM(ordertable_CustPrice) AS TotalOrderPrice,
    SUM(ordertable_BusPrice) AS TotalOrderCost,
    SUM(ordertable_CustPrice - ordertable_BusPrice) AS Profit
  FROM ordertable
  GROUP BY ordertable_OrderType, DATE_FORMAT(ordertable_OrderDateTime, '%c/%Y')
  ORDER BY 
    FIELD(ordertable_OrderType, 'dinein', 'pickup', 'delivery'),
    DATE_FORMAT(ordertable_OrderDateTime, '%c/%Y')
)
UNION ALL
(
  SELECT
    '' AS customerType,
    'Grand Total' AS OrderMonth,
    SUM(ordertable_CustPrice) AS TotalOrderPrice,
    SUM(ordertable_BusPrice) AS TotalOrderCost,
    SUM(ordertable_CustPrice - ordertable_BusPrice) AS Profit
  FROM ordertable
);


