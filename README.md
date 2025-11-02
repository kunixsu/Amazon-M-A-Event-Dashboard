# 📊 Amazon M&A Event Study Dashboard

This project analyzes **Amazon’s Mergers and Acquisitions** data to measure short-term stock market reactions.  
The workflow covers **data extraction (SQL)**, **analysis (Python/Jupyter)**, and **visualization (Excel Dashboard)**.

---

## 🧠 Project Overview

1. **Data Extraction** – SQL scripts join market data (`amz.csv`) with M&A data (`mac.csv`) to calculate pre/post-acquisition changes.
2. **Data Processing** – Python notebooks (`M&A.ipynb`, `M&A report.ipynb`) clean and export the final dataset (`report2.csv` / `finalreport.csv`).
3. **Visualization** – Interactive **Excel dashboard (`dashboard.xlsx`)** shows:
   - Total acquisitions and KPIs
   - Avg % Close Change & Avg % Volume Change by year
   - Country-wise distribution
   - Top 10 stock reactions
   - Combo chart (Acquisition count vs Volume change)

---

## 🧰 Tools Used

- **PostgreSQL / SQL** → Data extraction & joins  
- **Python (Jupyter Notebooks)** → Data cleaning  
- **Microsoft Excel** → Final dashboard with KPIs, slicers & charts  

---

## 📂 Folder Structure

