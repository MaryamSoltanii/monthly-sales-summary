# Monthly Sales Summary (Oracle PL/SQL)

This project contains an Oracle PL/SQL procedure to generate a monthly sales summary, aggregating **total sales per region** for a given year and month.  
It includes schema creation scripts, sequence creation scripts, and the main procedure with error handling and logging.


### Sample Run / Test Data

```sql
INSERT INTO regions (region_id, region_name)
VALUES (1, 'North'), (2, 'South');

INSERT INTO sales (sale_id, region_id, sale_amount, sale_date)
VALUES
  (1, 1, 1000, DATE '2025-07-10'),
  (2, 2, 1500, DATE '2025-07-15'),
  (3, 2, 1700, DATE '2025-07-15');

COMMIT;

BEGIN
  generate_monthly_sales_summary(2025, 7);
END;
/

SELECT * FROM monthly_sales_summary;
