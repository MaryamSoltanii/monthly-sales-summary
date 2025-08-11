CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    region_id NUMBER NOT NULL,
    sale_amount NUMBER(10,2) NOT NULL,
    sale_date DATE NOT NULL
);

CREATE TABLE regions (
    region_id NUMBER PRIMARY KEY,
    region_name VARCHAR2(100) NOT NULL
);

CREATE TABLE monthly_sales_summary (
    summary_id NUMBER PRIMARY KEY,
    region_id NUMBER NOT NULL,
    region_name VARCHAR2(100) NOT NULL,
    summary_year NUMBER NOT NULL,
    summary_month NUMBER NOT NULL,
    total_sales NUMBER(12,2) NOT NULL,
    last_updated DATE NOT NULL,
    CONSTRAINT chk_year CHECK (summary_year BETWEEN 1900 AND 9999),
    CONSTRAINT chk_month CHECK (summary_month BETWEEN 1 AND 12)
);
