/* Task 1 */
CREATE VIEW OrdersView AS 
SELECT OrderID, Quantity, TotalCost FROM orders
WHERE Quantity > 2;

SELECT * FROM OrdersView;

/* Task 2 */
SELECT c.CustomerID, c.CustomerName, o.OrderID, 
		o.TotalCost, m.MenuName, mi.CourseName
FROM customer c
INNER JOIN orders o ON o.CustomerId = c.CustomerID
INNER JOIN menu m ON m.MenuID = o.MenuID
INNER JOIN menuitems mi ON mi.MenuItemID = m.MenuItemID
WHERE o.TotalCost > 150
ORDER BY o.TotalCost ASC;

/* Task 3 */
SELECT m.MenuName
FROM menu m
WHERE m.MenuID = ANY (
    SELECT o.MenuID
    FROM orders o
    WHERE o.Quantity > 2
);


/* GetMaxQuantity */
CREATE PROCEDURE GetMaxQuantity()  
SELECT MAX(Quantity) AS "Max Quantity in Order"
FROM orders;

CALL GetMaxQuantity();

/* GetOrderDetail */
PREPARE GetOrderDetail 
FROM 'SELECT OrderID, Quantity, TotalCost FROM orders WHERE OrderID = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;

/* CancelBooking */
DROP procedure CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN CancelID INT)
BEGIN
DELETE FROM bookings WHERE BookingID = CancelID;
SELECT CONCAT("Order ",CancelID, " is cancelled.") AS Confirmation FROM bookings;
END//
DELIMITER ;

CALL CancelBooking(5);

/* UpdateBooking  */
CREATE PROCEDURE UpdateBooking(IN UpdateID INT, IN TableNo INT)
UPDATE Bookings
SET TableNumber = TableNo
WHERE BookingID = UpdateID;

CALL UpdateBooking(6, 1);

SELECT * FROM Bookings;
DROP PROCEDURE AddBooking;

DELIMITER //
CREATE PROCEDURE AddBooking (IN AddBookingID INT, IN AddBookingDate DATE, IN AddTableNo INT, IN AddCustomerID INT, IN AddEmployeeNum INT)
BEGIN
INSERT INTO bookings (BookingID, BookingDate, TableNumber, CustomerID, EmployeeID)
VALUES (AddBookingID, AddBookingDate, AddTableNo, AddCustomerID, AddEmployeeNum);
SELECT CONCAT("New Booking ID ", AddBookingID, " Added.") AS Confirmation;
END//
DELIMITER ;

CALL AddBooking(5, "2022-12-30", 4, 3, 1);

DELIMITER //
CREATE PROCEDURE MakeBooking (booking_id INT, customer_id INT, table_no int, booking_date date)
BEGIN
INSERT INTO bookings (BookingID, BookingDate, TableNumber, CustomerID) 
VALUES (booking_id, booking_date, table_no, customer_id);
SELECT "New booking added" AS "Confirmation";
END//
DELIMITER ;

CALL MakeBooking(5, "2022-12-30", 4, 3, 1);

-- check the bookings table
SELECT * FROM bookings;

-- a procedure to check whether a table in the restaurant is already booked
DROP PROCEDURE IF EXISTS CheckBooking;

-- a stored procedure to check if a table is booked on a given date
DELIMITER //
CREATE PROCEDURE CheckBooking (booking_date DATE, table_number INT)
BEGIN
DECLARE bookedTable INT DEFAULT 0;
 SELECT COUNT(bookedTable)
    INTO bookedTable
    FROM bookings WHERE BookingDate = booking_date and TableNumber = table_number;
    IF bookedTable > 0 THEN
      SELECT CONCAT( "Table ", table_number, " is already booked.") AS "Booking status";
      ELSE 
      SELECT CONCAT( "Table ", table_number, " is not booked.") AS "Booking status";
    END IF;
END//
DELIMITER ;

CALL CheckBooking("2022-12-30", 5);

-- check Bookings table
SELECT * FROM bookings;
