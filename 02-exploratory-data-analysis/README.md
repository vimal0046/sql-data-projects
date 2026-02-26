# 📊 Exploratory Data Analysis — Layoffs Dataset

## 📌 Overview
Comprehensive Exploratory Data Analysis (EDA) performed on a cleaned global layoffs dataset using advanced SQL techniques.  
The goal was to uncover business trends, identify the most impacted industries and companies, and generate ranking-based insights.

---

## 🛠️ Tools Used
- **MySQL** — Data Analysis and Querying
- **SQL Concepts** — CTEs, Window Functions, Aggregations, DENSE_RANK, Rolling Totals, Date Functions

---

## 📂 Dataset
- **Source:** Cleaned layoffs dataset (output of Data Cleaning Project)
- **Period:** 2020 – 2023
- **Fields:** Company, Location, Industry, Total Laid Off, Percentage Laid Off, Date, Stage, Country, Funds Raised

---

## 🔍 Analysis Performed

| Analysis | Description |
|----------|-------------|
| Summary Statistics | Max layoffs, max percentage laid off |
| 100% Layoff Companies | Companies that shut down entirely |
| Company-Level Total | Total layoffs per company (all time) |
| Industry Breakdown | Which industries were hit hardest |
| Country Breakdown | Which countries had most layoffs |
| Yearly Trends | Layoffs by year |
| Funding Stage Analysis | Layoffs by company stage (Seed, Series A, IPO, etc.) |
| Monthly Trends | Month-by-month layoff totals |
| Rolling Total | Cumulative layoffs over time |
| Top 5 Per Year | Top 5 companies by layoffs for each year using DENSE_RANK |

---

## 💡 Key SQL Concepts Used

```sql
-- Rolling cumulative total using Window Function
SUM(total_off) OVER(ORDER BY `month`) AS rolling_total

-- Top 5 companies per year using DENSE_RANK
WITH Company_Year AS (...),
Company_Year_Rank AS (
    SELECT *, 
        DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_Laid_Off DESC) AS Ranking
    FROM Company_Year
    WHERE Years IS NOT NULL
)
SELECT * FROM Company_Year_Rank WHERE Ranking <= 5;
```

---

## 📈 Key Findings

- **Consumer** and **Retail** industries recorded the highest total layoffs
- **United States** accounted for the majority of global layoffs
- Layoffs peaked significantly in **2022–2023**
- Several well-funded companies (100M+ raised) still laid off 100% of staff
- Rolling total analysis revealed accelerating layoff trend from mid-2022

---

## 🔗 Related Project
👉 [Data Cleaning Project](../01-data-cleaning-layoffs/) — This EDA was performed on the dataset cleaned in the previous project

---

## 👤 Author
**Vimalraj Ponnuraj**  
📧 vimalraj0046@gmail.com  
🔗 [LinkedIn](https://linkedin.com/in/vimalraj0046)
