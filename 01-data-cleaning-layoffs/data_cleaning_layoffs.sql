-- ============================================================
-- Project    : Layoffs Data Cleaning
-- Author     : Vimalraj Ponnuraj
-- Tool       : MySQL
-- Description: End-to-end data cleaning of a global layoffs 
--              dataset using SQL best practices
-- ============================================================


-- ============================================================
-- STEP 0: View Raw Data
-- ============================================================

SELECT * 
FROM layoffs;


-- ============================================================
-- STEP 1: Create a Working Copy (Never modify raw data)
-- ============================================================

CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT INTO layoffs_copy
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_copy;


-- ============================================================
-- STEP 2: Remove Duplicates
-- ============================================================

-- Identify duplicates using ROW_NUMBER()
WITH check_duplicate_cte AS (
    SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY company, location, industry, 
                         total_laid_off, percentage_laid_off, 
                         `date`, stage, country, funds_raised_millions
        ) AS Row_num
    FROM layoffs_copy
)
SELECT *
FROM check_duplicate_cte
WHERE Row_num > 1;

-- Verify specific duplicate example
SELECT *
FROM layoffs_copy
WHERE company = 'cazoo';

-- Create second staging table to safely delete duplicates
CREATE TABLE `layoffs_copy2` (
  `company`               TEXT,
  `location`              TEXT,
  `industry`              TEXT,
  `total_laid_off`        INT DEFAULT NULL,
  `percentage_laid_off`   TEXT,
  `date`                  TEXT,
  `stage`                 TEXT,
  `country`               TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num`               INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data with row numbers
INSERT INTO layoffs_copy2
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, 
                     total_laid_off, percentage_laid_off, 
                     `date`, stage, country, funds_raised_millions
    ) AS Row_num
FROM layoffs_copy;

-- Delete duplicates (row_num > 1)
DELETE FROM layoffs_copy2
WHERE row_num > 1;

-- Confirm duplicates removed
SELECT * FROM layoffs_copy2 WHERE row_num > 1;


-- ============================================================
-- STEP 3: Standardize Data
-- ============================================================

-- 3a. Trim whitespace from company names
SELECT company, TRIM(company)
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET company = TRIM(company);

-- 3b. Standardize industry names (fix Crypto variations)
SELECT DISTINCT industry
FROM layoffs_copy2
ORDER BY industry ASC;

UPDATE layoffs_copy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 3c. Standardize country names (remove trailing period)
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_copy2
ORDER BY 1 ASC;

UPDATE layoffs_copy2
SET country = TRIM(TRAILING '.' FROM country);

-- 3d. Convert date column from TEXT to DATE format
UPDATE layoffs_copy2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE;


-- ============================================================
-- STEP 4: Handle NULL and Blank Values
-- ============================================================

-- Convert blank industry to NULL for consistent handling
UPDATE layoffs_copy2
SET industry = NULL
WHERE industry = '';

-- Populate NULL industry using self-join (same company/location)
SELECT t1.company, t1.industry AS null_industry, t2.industry AS fill_value
FROM layoffs_copy2 t1
JOIN layoffs_copy2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

UPDATE layoffs_copy2 t1
JOIN layoffs_copy2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Verify remaining NULLs (e.g., Bally's has no match)
SELECT * FROM layoffs_copy2 WHERE industry IS NULL;


-- ============================================================
-- STEP 5: Remove Unusable Rows
-- ============================================================

-- Rows with both layoff columns NULL are not useful for analysis
SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

DELETE FROM layoffs_copy2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;


-- ============================================================
-- STEP 6: Final Cleanup — Drop Helper Column
-- ============================================================

ALTER TABLE layoffs_copy2
DROP COLUMN row_num;

-- Final clean dataset
SELECT * FROM layoffs_copy2;
