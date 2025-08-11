CREATE OR REPLACE PROCEDURE generate_monthly_sales_summary (
    p_year  IN NUMBER,
    p_month IN NUMBER
)
AS
    v_date_from DATE := TO_DATE(p_year || '-' || LPAD(p_month,2,'0') || '-01','YYYY-MM-DD');
    v_date_to   DATE := ADD_MONTHS(v_date_from, 1);

    CURSOR sales_cursor IS
        SELECT r.region_id, r.region_name, SUM(s.sale_amount) AS total_sales
        FROM   sales s
        JOIN   regions r ON s.region_id = r.region_id
        WHERE  s.sale_date >= v_date_from
           AND s.sale_date <  v_date_to
        GROUP BY r.region_id, r.region_name;

    v_region_id     regions.region_id%TYPE;
    v_region_name   regions.region_name%TYPE;
    v_total_sales   NUMBER;

    v_error_code    NUMBER;
    v_error_msg     VARCHAR2(4000);

    v_rows_processed NUMBER := 0;

    PROCEDURE log_error(p_err_code NUMBER, p_err_msg VARCHAR2, p_proc_name VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO error_log (error_id, error_code, error_message, procedure_name, error_timestamp)
        VALUES (error_log_seq.NEXTVAL, p_err_code, p_err_msg, p_proc_name, SYSDATE);
        COMMIT;
    END;
BEGIN
    SAVEPOINT start_summary;

    DELETE FROM monthly_sales_summary 
     WHERE summary_year  = p_year 
       AND summary_month = p_month;

    OPEN sales_cursor;
    LOOP
        FETCH sales_cursor INTO v_region_id, v_region_name, v_total_sales;
        EXIT WHEN sales_cursor%NOTFOUND;

        INSERT INTO monthly_sales_summary (
            summary_id, region_id, region_name, summary_year, summary_month, total_sales, last_updated
        )
        VALUES (
            monthly_sales_summary_seq.NEXTVAL, v_region_id, v_region_name, p_year, p_month, v_total_sales, SYSDATE
        );

        v_rows_processed := v_rows_processed + 1;
    END LOOP;
    CLOSE sales_cursor;


    DBMS_OUTPUT.PUT_LINE('Monthly summary generated for ' ||
        TO_CHAR(v_date_from, 'YYYY-MM') || '. Rows processed: ' || v_rows_processed);

EXCEPTION
    WHEN VALUE_ERROR THEN
        v_error_code := SQLCODE; v_error_msg := SQLERRM;
        ROLLBACK TO start_summary;
        log_error(v_error_code, v_error_msg, 'GENERATE_MONTHLY_SALES_SUMMARY');
        RAISE;
    WHEN OTHERS THEN
        v_error_code := SQLCODE; v_error_msg := SQLERRM;
        ROLLBACK TO start_summary;
        log_error(v_error_code, v_error_msg, 'GENERATE_MONTHLY_SALES_SUMMARY');
        RAISE;
END generate_monthly_sales_summary;
/
