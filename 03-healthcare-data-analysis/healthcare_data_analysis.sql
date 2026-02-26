-- ============================================================
-- Project    : OCD Patient Healthcare Data Analysis
-- Author     : Vimalraj Ponnuraj
-- Tool       : MySQL
-- Description: SQL-based analysis of OCD patient dataset to
--              calculate KPIs, patient distribution, monthly
--              trends, and obsession/compulsion type insights
-- ============================================================


-- ============================================================
-- STEP 0: View Raw Dataset
-- ============================================================

SELECT * 
FROM ocd_patient;


-- ============================================================
-- QUERY 1: Patient Count by Gender + Average Obsession Score
-- ============================================================

SELECT 
    Gender,
    COUNT(`Patient ID`)                          AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2)   AS avg_obs_score
FROM ocd_patient
GROUP BY Gender;


-- ============================================================
-- QUERY 2: Gender Distribution with Percentage Breakdown
-- ============================================================
-- Calculates what % of total patients each gender represents

WITH gender_count AS (
    SELECT 
        Gender,
        COUNT(`Patient ID`)                         AS patient_count,
        ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2)  AS avg_obs_score
    FROM ocd_patient
    GROUP BY Gender
),
total AS (
    SELECT SUM(patient_count) AS total_count
    FROM gender_count
)
SELECT
    g.Gender,
    g.patient_count,
    g.avg_obs_score,
    ROUND((g.patient_count / t.total_count) * 100, 2) AS percentage
FROM gender_count g
JOIN total t;


-- ============================================================
-- QUERY 3: Monthly Patient Diagnosis Trend (MOM Analysis)
-- ============================================================
-- Tracks how many patients were diagnosed each month

SET sql_safe_updates = 0;

ALTER TABLE ocd_patient
MODIFY COLUMN `OCD Diagnosis Date` DATE;

SELECT
    DATE_FORMAT(`OCD Diagnosis Date`, '%Y-%m-01') AS month,
    COUNT(*)                                       AS patient_count
FROM ocd_patient
GROUP BY month
ORDER BY month ASC;


-- ============================================================
-- QUERY 4: Most Common Obsession Type + Avg Obsession Score
-- ============================================================

SELECT 
    `Obsession Type`,
    COUNT(`Patient ID`)                         AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2)  AS avg_obs_score
FROM ocd_patient
GROUP BY `Obsession Type`
ORDER BY patient_count DESC
LIMIT 1;


-- ============================================================
-- QUERY 5: Most Common Compulsion Type + Avg Compulsion Score
-- ============================================================

SELECT 
    `Compulsion Type`,
    COUNT(`Patient ID`)                          AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Compulsions)`), 2)  AS avg_comp_score
FROM ocd_patient
GROUP BY `Compulsion Type`
ORDER BY patient_count DESC
LIMIT 1;
