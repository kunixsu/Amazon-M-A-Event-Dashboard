



select * from mac
select count(*)from amz

DROP TABLE IF EXISTS amz;

CREATE TABLE amz (
    trade_date DATE PRIMARY KEY,   -- YYYY-MM-DD
    open NUMERIC(12,2),
    high NUMERIC(12,2),
    low  NUMERIC(12,2),
    close NUMERIC(12,2),
    volume BIGINT
);



CREATE OR REPLACE VIEW amazon_mna_event_study AS
SELECT 
    m.company_name,
    m.company_country,
    m.company_acquired_on,
    m.company_acquired_for,

    -- Before acquisition
    b.trade_date AS before_date,
    b.open AS before_open,
    b.close AS before_close,
    b.volume AS before_volume,

    -- After acquisition
    a.trade_date AS after_date,
    a.open AS after_open,
    a.close AS after_close,
    a.volume AS after_volume,

    -- Impact calculations
    -- Impact calculations
ROUND(((a.close - b.close) / b.close) * 100, 2)   AS pct_change_close,
ROUND(((a.open - b.open) / b.open) * 100, 2)      AS pct_change_open,
ROUND(((a.volume::NUMERIC - b.volume::NUMERIC) / NULLIF(b.volume::NUMERIC,0)) * 100, 2) AS pct_change_volume

FROM mac m

-- nearest BEFORE trading day
JOIN LATERAL (
    SELECT trade_date, open, close, volume
    FROM amz
    WHERE trade_date < m.company_acquired_on
    ORDER BY trade_date DESC
    LIMIT 1
) b ON TRUE

-- nearest AFTER trading day
JOIN LATERAL (
    SELECT trade_date, open, close, volume
    FROM amz
    WHERE trade_date > m.company_acquired_on
    ORDER BY trade_date ASC
    LIMIT 1
) a ON TRUE

ORDER BY m.company_acquired_on;







DROP TABLE IF EXISTS report;

CREATE TABLE report AS
SELECT 
    m.company_name,
    m.company_country,
    m.company_acquired_on,
    m.company_acquired_for,

    -- Before acquisition
    b.trade_date AS before_date,
    b.open  AS before_open,
    b.close AS before_close,
    b.volume AS before_volume,

    -- After acquisition
    a.trade_date AS after_date,
    a.open  AS after_open,
    a.close AS after_close,
    a.volume AS after_volume,
    -- Impact calculations
ROUND(((a.close - b.close) / b.close) * 100, 2)   AS pct_change_close,
ROUND(((a.open - b.open) / b.open) * 100, 2)      AS pct_change_open,
ROUND(((a.volume::NUMERIC - b.volume::NUMERIC) / NULLIF(b.volume::NUMERIC,0)) * 100, 2) AS pct_change_volume

FROM mac m

-- nearest BEFORE trading day
JOIN LATERAL (
    SELECT trade_date, open, close, volume
    FROM amz
    WHERE trade_date < m.company_acquired_on
    ORDER BY trade_date DESC
    LIMIT 1
) b ON TRUE

-- nearest AFTER trading day
JOIN LATERAL (
    SELECT trade_date, open, close, volume
    FROM amz
    WHERE trade_date > m.company_acquired_on
    ORDER BY trade_date ASC
    LIMIT 1
) a ON TRUE

ORDER BY m.company_acquired_on;



-- Add new columns
ALTER TABLE report 
ADD COLUMN acquisition_year INT,
ADD COLUMN acquisition_month INT;

-- Update them with values from acquisition date
UPDATE report
SET acquisition_year  = EXTRACT(YEAR FROM company_acquired_on),
    acquisition_month = EXTRACT(MONTH FROM company_acquired_on);

-- ✅ Check a few rows
SELECT company_name, company_acquired_on, acquisition_year, acquisition_month
FROM report
LIMIT 10;

select*from report




COPY report TO 'C:/Users/hp/Desktop/report.csv' DELIMITER ',' CSV HEADER;

select*from amz
