# 🏥 OCD Patient Healthcare Data Analysis

## 📌 Overview
SQL-based analysis of an OCD (Obsessive-Compulsive Disorder) patient dataset to uncover patient distribution patterns, monthly diagnosis trends, and clinical KPIs including obsession and compulsion type insights.

---

## 🛠️ Tools Used
- **MySQL** — Data Analysis and Querying
- **SQL Concepts** — CTEs, Aggregations, DATE_FORMAT, GROUP BY, Window Calculations, Percentage Analysis

---

## 📂 Dataset
- **Source:** OCD Patient clinical dataset
- **Fields:** Patient ID, Gender, OCD Diagnosis Date, Y-BOCS Score (Obsessions), Y-BOCS Score (Compulsions), Obsession Type, Compulsion Type

---

## 🔍 Analysis Performed

| Query | Description |
|-------|-------------|
| 1 | Patient count by gender with average Y-BOCS obsession score |
| 2 | Gender distribution with percentage breakdown using CTEs |
| 3 | Month-over-month (MOM) patient diagnosis trend |
| 4 | Most common obsession type and its average obsession score |
| 5 | Most common compulsion type and its average compulsion score |

---

## 💡 Key SQL Concepts Used

```sql
-- Percentage calculation using CTE + JOIN
WITH gender_count AS (
    SELECT Gender, COUNT(`Patient ID`) AS patient_count,
           ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) AS avg_obs_score
    FROM ocd_patient GROUP BY Gender
),
total AS (SELECT SUM(patient_count) AS total_count FROM gender_count)

SELECT g.Gender, g.patient_count,
       ROUND((g.patient_count / t.total_count) * 100, 2) AS percentage
FROM gender_count g JOIN total t;

-- Monthly trend using DATE_FORMAT
DATE_FORMAT(`OCD Diagnosis Date`, '%Y-%m-01') AS month
```

---

## 📈 Key Business Insights

- Calculated **patient distribution by gender** with Y-BOCS severity scores
- Identified **monthly diagnosis trends** to track patient intake over time
- Determined the **most prevalent obsession and compulsion types** for clinical focus
- Used **percentage analysis** to compare gender representation across patient population

---

## 🔗 Related Projects
👉 [Data Cleaning Project](../01-data-cleaning-layoffs/)
👉 [Exploratory Data Analysis](../02-exploratory-data-analysis/)

---

## 👤 Author
**Vimalraj Ponnuraj**  
📧 vimalraj0046@gmail.com  
🔗 [LinkedIn](https://linkedin.com/in/vimalraj0046)
