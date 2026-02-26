-- ============================================================
-- Project    : Exploratory Data Analysis — Layoffs Dataset
-- Author     : Vimalraj Ponnuraj
-- Tool       : MySQL
-- Description: Comprehensive EDA on cleaned layoffs data to 
--              uncover trends, rankings, and business insights
-- ============================================================


-- ============================================================
-- STEP 0: View Clean Dataset
-- ============================================================

SELECT * 
FROM layoffs_copy2;


-- ============================================================
-- STEP 1: High-Level Summary Statistics
-- ============================================================

-- Maximum single-event layoffs and highest percentage laid off
SELECT 
    MAX(total_laid_off)      AS max_laid_off,
    MAX(percentage_laid_off) AS max_percentage
FROM layoffs_copy2;

-- Companies that laid off 100% of workforce, ordered by size
SELECT *
FROM layoffs_copy2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies that laid off 100% of workforce, ordered by funding
SELECT *
FROM layoffs_copy2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- ============================================================
-- STEP 2: Company-Level Analysis
-- ============================================================

-- Total layoffs per company (all time)
SELECT 
    company, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY company
ORDER BY 2 DESC;

-- Date range of dataset
SELECT 
    MIN(`date`) AS earliest_date, 
    MAX(`date`) AS latest_date
FROM layoffs_copy2;


-- ============================================================
-- STEP 3: Industry and Country Analysis
-- ============================================================

-- Total layoffs by industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs by country
SELECT 
    country, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY country
ORDER BY 2 DESC;


-- ============================================================
-- STEP 4: Time-Based Analysis
-- ============================================================

-- Total layoffs by year
SELECT 
    YEAR(`date`)            AS year, 
    SUM(total_laid_off)     AS total_laid_off
FROM layoffs_copy2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total layoffs by funding stage
SELECT 
    stage, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY stage
ORDER BY 2 DESC;

-- Monthly layoff totals
SELECT 
    SUBSTRING(`date`, 1, 7)  AS `month`, 
    SUM(total_laid_off)       AS monthly_total
FROM layoffs_copy2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;


-- ============================================================
-- STEP 5: Rolling Total — Cumulative Layoffs Over Time
-- ============================================================

WITH Rolling_Total AS (
    SELECT 
        SUBSTRING(`date`, 1, 7)  AS `month`, 
        SUM(total_laid_off)       AS total_off
    FROM layoffs_copy2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `month`
    ORDER BY 1 ASC
)
SELECT 
    `month`,
    total_off,
    SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;


-- ============================================================
-- STEP 6: Company Yearly Layoffs + Top 5 Ranking Per Year
-- ============================================================

-- Total layoffs per company per year
SELECT 
    company, 
    YEAR(`date`)        AS year, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 companies with most layoffs per year using DENSE_RANK
WITH Company_Year (Company, Years, Total_Laid_Off) AS (
    SELECT 
        company, 
        YEAR(`date`), 
        SUM(total_laid_off)
    FROM layoffs_copy2
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
    SELECT *, 
        DENSE_RANK() OVER(
            PARTITION BY Years 
            ORDER BY Total_Laid_Off DESC
        ) AS Ranking
    FROM Company_Year
    WHERE Years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
