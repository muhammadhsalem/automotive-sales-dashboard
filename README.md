# Sales Performance Dashboard
### Tools: MySQL · Power BI · DAX

A 2-page interactive sales dashboard built on the Classic Models automotive database — tracking revenue, profit, and performance across product lines and countries, with dynamic metric switching and MoM/YTD trend analysis.

---

## Dashboard Preview

> Add screenshots after exporting from Power BI Desktop

| Page | Description |
|---|---|
| <img width="1538" height="921" alt="Screenshot 2026-05-13 200854" src="https://github.com/user-attachments/assets/0cd77ce7-f907-4617-bf8e-a612fc173256" />
 | KPI cards, trend lines, bar/scatter/donut/column charts |
| <img width="1538" height="925" alt="Screenshot 2026-05-13 200933" src="https://github.com/user-attachments/assets/6c1130b8-59f2-4d8c-bb52-0a340181ec92" />
 | Decomposition tree + MoM% & YTD sales table |

---

## Data Source

- **Database:** Classic Models MySQL relational database (`classicmodels`)
- **Main table used in Power BI:** `classicmodels sales_data_pb` (pre-aggregated view/table built from SQL queries)
- **Key columns:** `orderNumber`, `productLine`, `customerCountry`, `officeCountry`, `customerName`, `sales`, `cost_of_sales`

---

## Dashboard Pages

### Page 1 — Sales Overview

**KPI Cards (with sparkline trend lines)**
| Metric | Value shown |
|---|---|
| Total Sales | SUM of sales |
| Total Orders | COUNT of orderNumber |
| Average Sale Value | [Average Sale Value] measure |

**Charts**
| Visual | Type | Fields |
|---|---|---|
| Sales by Product Line | Bar chart | productLine, [selected metric] |
| Cost vs Revenue scatter | Scatter chart | [selected metric], cost_of_sales, orderNumber |
| Sales by Office Country | Donut chart | officeCountry, [selected metric] |
| Sales by Customer Country | Column chart | customerCountry, [selected metric] |

**Dynamic metric switcher** — an action button slicer switches all visuals between Total Sales, Total Orders, and Average Sale Value simultaneously using the `[selected metric]` measure.

### Page 2 — Profit Decomposition

| Visual | Type | Description |
|---|---|---|
| Decomposition tree | Tree visual | [Net Profit] broken down by customerCountry → productLine → customerName |
| Sales trend table | Table | Sales, [Sum of sales MoM%], [Sum of sales YTD] over time |

---

## DAX Measures

| Measure | Purpose |
|---|---|
| `[Average Sale Value]` | Total sales ÷ total orders |
| `[Net Profit]` | Sales minus cost_of_sales |
| `[Sum of sales MoM%]` | Month-over-month % change in sales |
| `[Sum of sales YTD]` | Year-to-date cumulative sales |
| `[selected metric]` | Dynamic switcher — returns chosen KPI based on slicer selection |

---

## SQL Queries

The `classicmodels sales_data_pb` table was built by querying the Classic Models relational database. Sample queries used:

```sql
-- Total sales, orders, and profit by product line
SELECT
  productLine,
  COUNT(DISTINCT od.orderNumber)          AS total_orders,
  SUM(od.quantityOrdered * od.priceEach)  AS total_sales,
  SUM(od.quantityOrdered * od.priceEach)
    - SUM(od.quantityOrdered * p.buyPrice) AS net_profit
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY productLine
ORDER BY total_sales DESC;
```

```sql
-- Sales by customer country with office mapping
SELECT
  c.country        AS customerCountry,
  o.country        AS officeCountry,
  ord.orderNumber,
  SUM(od.quantityOrdered * od.priceEach)  AS sales,
  SUM(od.quantityOrdered * p.buyPrice)    AS cost_of_sales
FROM orders ord
JOIN customers c  ON ord.customerNumber = c.customerNumber
JOIN employees e  ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o    ON e.officeCode = o.officeCode
JOIN orderdetails od ON ord.orderNumber = od.orderNumber
JOIN products p   ON od.productCode = p.productCode
GROUP BY c.country, o.country, ord.orderNumber;
```

> See `/sql` folder for all query files.

---

## Key Insights

- **Classic Cars and Vintage Cars** are the top-performing product lines, accounting for 55%+ of total revenue
- The **decomposition tree** allows drill-down from country → product line → individual customer to pinpoint revenue drivers
- **MoM% and YTD measures** reveal seasonal sales patterns — strong Q4 performance across most years
- Several customer countries contribute less than 5% of total sales — flagged as underperforming markets

---

| File | Description |
|---|---|
| `screenshots/page1_overview.png` | KPI cards, product line bar, country charts |
| `screenshots/page2_decomposition.png` | Net profit decomposition tree + MoM/YTD table |
| `sql/01_product_line_summary.sql` | Revenue, profit, orders by product line |
| `sql/02_country_sales.sql` | Sales by customer country and office |

**[▶ View live dashboard on Power BI](https://app.powerbi.com/view?r=eyJrIjoiNGI3YTk0NzgtNjYxMC00ZDlkLWExMWQtMTZhNjQzOGEwZTljIiwidCI6ImVhZjYyNGM4LWEwYzQtNDE5NS04N2QyLTQ0M2U1ZDc1MTZjZCIsImMiOjh9)**
