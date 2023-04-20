


-- Employee Performance 

 CREATE TRIGGER trg_UpdateEmployeePerformance
 ON Sales
 AFTER INSERT
 AS
 BEGIN
     DECLARE @EmployeeId INT

     SELECT @EmployeeId = EmployeeId FROM inserted

     UPDATE EmployeePerformance
     SET TotalSales = TotalSales + (SELECT SUM(Quantity * Price) FROM inserted WHERE EmployeeId = @EmployeeId)
     WHERE EmployeeId = @EmployeeId
 END
  

-- ReturnsAndRefunds

CREATE TRIGGER trg_ReturnsAndRefunds
ON Sales
AFTER DELETE
AS
BEGIN
    DECLARE @ProductId INT
    DECLARE @Quantity INT
    DECLARE @StoreId IN
    SELECT @ProductId = ProductId, @Quantity = Quantity, @StoreId = StoreId FROM delete
    UPDATE Product
    SET Quantity = Quantity + @Quantity
    WHERE ProductId = @ProductI
    UPDATE Inventory
    SET Quantity = Quantity + @Quantity
    WHERE ProductId = @ProductId AND StoreId = @StoreId
END



-- UpdateEmployeePerformance

  CREATE TRIGGER trg_UpdateEmployeePerformance
  ON Sales
  AFTER INSERT
  AS
  BEGIN
      DECLARE employee_performance INT

      SELECT employee_performance =employee_performance FROM inserted

      UPDATE employe_performance
      SET TotalSales = TotalSales + (SELECT SUM(Quantity * Price) FROM inserted WHEREemployee_performance = employee_performance)
      WHEREemployee_performance = employee_performance
  END