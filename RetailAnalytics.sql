create database EcommerceCustomerAnalytics;

use EcommerceCustomerAnalytics;

-- count of rows in each table after importing 
select count(*) as RowCount2009_2010 from dbo.[Year 2009-2010];
select count(*) as RowCount2010_2011 from dbo.[Year 2010-2011];

-- joining both the tables and converting the data types
select Invoice, StockCode, Description, Quantity,
coalesce(
try_convert(datetime2, InvoiceDate, 120),
try_convert(datetime2, InvoiceDate, 105)
)as InvoiceDate,
try_convert(decimal(10,2),Price) as Price,
Customer_id, Country, '2009-2010' as SourceSheet
into dbo.RetailCombined
from dbo.[Year 2009-2010]

union all

select Invoice, StockCode, Description, Quantity,
coalesce(
try_convert(datetime2, InvoiceDate, 120),
try_convert(datetime2, InvoiceDate, 105)
)as InvoiceDate,
try_convert(decimal(10,2),Price) as Price,
Customer_id, Country, '2010-2011' as SourceSheet
from dbo.[Year 2010-2011];


--validate the number of rows after joining
SELECT
    CASE
        WHEN (SELECT COUNT(*) FROM dbo.RetailCombined) =
             (SELECT COUNT(*) FROM dbo.[Year 2009-2010]) +
             (SELECT COUNT(*) FROM dbo.[Year 2010-2011])
        THEN 'Match'
        ELSE 'Mismatch'
    END AS Validation_Result;
------------------------------------------
SELECT
    (SELECT COUNT(*) FROM dbo.RetailCombined) AS Combined_Rows,
    (SELECT COUNT(*) FROM dbo.[Year 2009-2010]) AS Rows_2009_2010,
    (SELECT COUNT(*) FROM dbo.[Year 2010-2011]) AS Rows_2010_2011,
    (
        (SELECT COUNT(*) FROM dbo.[Year 2009-2010]) +
        (SELECT COUNT(*) FROM dbo.[Year 2010-2011])
    ) AS Expected_Total_Rows;


--confirm the join worked
select count(*)as total_rows from dbo.RetailCombined
select count(*)as FailedDates from dbo.RetailCombined where InvoiceDate is null;
select count(*)as FailerPrice from dbo.RetailCombined where Price is null;

--check 1: missing cust ID
select count(*)as MissingCustomerID from dbo.RetailCombined where Customer_id is null;

-- check 2 : negative or zero quantity
select count(*)as negativeQty from dbo.RetailCombined where Quantity <= 0;

--check 3 : missing description
select count(*)as Missingdescription from dbo.RetailCombined where Description is null;

--check 4: number of duplicate
select Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_id, Country, count(*) as ExactDupeCount
from dbo.RetailCombined
group by Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_id, Country 
having count(*) >1
order by count(*) Desc;

--Deduplication and final clean dataset
with Deduped as (
select *,
  ROW_NUMBER() over (
partition by Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_id, Country
order by (select null)
) as RowNum
from dbo.RetailCombined)
select Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_id, Country,SourceSheet
into dbo.CleanedRetailData
from Deduped
where RowNum =1;

select Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_id, Country, count(*) as ExactDupeCount
from dbo.CleanedRetailData
group by Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_id, Country 
having count(*) >1

select * from dbo.CleanedRetailData;

SELECT *
INTO dbo.CleanedRetailDataSpare
FROM dbo.CleanedRetailData;