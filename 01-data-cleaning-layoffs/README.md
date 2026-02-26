# 🧹 Layoffs Data Cleaning Project

## 📌 Overview
End-to-end SQL data cleaning project on a real-world global layoffs dataset.  
The goal was to transform raw, inconsistent data into a clean, analysis-ready dataset using MySQL best practices.

---

## 🛠️ Tools Used
- **MySQL** — Data cleaning and transformation
- **SQL Concepts** — CTEs, Window Functions, Self Joins, String Functions, Date Functions

---

## 📂 Dataset
- **Source:** Global tech layoffs dataset (2020–2023)
- **Records:** 2,000+ company-level layoff entries
- **Fields:** Company, Location, Industry, Total Laid Off, Percentage Laid Off, Date, Stage, Country, Funds Raised

---

## 🔄 Cleaning Steps Performed

| Step | Action |
|------|--------|
| 1 | Created staging copy — never modified raw data |
| 2 | Identified and removed duplicate records using `ROW_NUMBER()` |
| 3 | Trimmed whitespace from company names |
| 4 | Standardized industry names (e.g., Crypto variants → Crypto) |
| 5 | Removed trailing punctuation from country names |
| 6 | Converted date column from TEXT to DATE format using `STR_TO_DATE()` |
| 7 | Converted blank strings to NULL for consistent handling |
| 8 | Populated NULL industry values using self-join on company + location |
| 9 | Removed rows where both layoff columns were NULL (unusable records) |
| 10 | Dropped helper `row_num` column after cleaning |

---

## 💡 Key SQL Concepts Used

```sql
-- Duplicate detection using ROW_NUMBER()
ROW_NUMBER() OVER(PARTITION BY company, location, industry, ...)

-- Self-join to fill NULL industry values
UPDATE layoffs_copy2 t1
JOIN layoffs_copy2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Date format conversion
STR_TO_DATE(`date`, '%m/%d/%Y')
```

---

## 📊 Outcome
- Removed all duplicate records
- Standardized all categorical fields
- Fixed date column data type for time-series analysis
- Dataset ready for Exploratory Data Analysis (EDA)

---

## 👤 Author
**Vimalraj Ponnuraj**  
📧 vimalraj0046@gmail.com  
🔗 [LinkedIn](https://linkedin.com/in/vimalraj0046)
