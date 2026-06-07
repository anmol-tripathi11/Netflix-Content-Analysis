# 🎬 Netflix Content Analysis Using SQL

An end-to-end **SQL data analysis project** analyzing **8,800+ Netflix titles** across Movies and TV Shows — uncovering content trends, top countries, genre distributions, actor appearances, ratings, and content categorization using **15 real-world business queries**.

---

### 🧰 Tools & Technologies

| Tool | Purpose |
|---|---|
| **SQL** | Core language for all queries and analysis |
| **PostgreSQL** | Database engine for storing and querying data |
| **pgAdmin** | GUI interface for database management |
| **Kaggle Dataset** | Source — 8,800+ rows, 12 columns of Netflix data |

---

### 📁 File Structure

```
Netflix-Content-Analysis/
│
├── Netflix-Content-Analysis-Dataset.zip              → Raw dataset (8,800+ Netflix titles)
└── Netflix-Content-Analysis.sql   → Full SQL script (exploration + cleaning + 15 business queries)
```

---

### 🗄️ Database Schema

```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(10) PRIMARY KEY,
    type         VARCHAR(15),
    title        VARCHAR(110),
    director     VARCHAR(210),
    casts        VARCHAR(1000),
    country      VARCHAR(130),
    date_added   DATE,
    release_year INT,
    rating       VARCHAR(30),
    duration     VARCHAR(150),
    listed_in    VARCHAR(100),
    description  VARCHAR(250)
);
```

---

### 🔍 Project Workflow

#### 1. Data Exploration
- Counted total rows — **8,800+ titles**
- Identified **2 content types** — Movies & TV Shows
- Detected NULL values across all 12 columns

#### 2. Data Cleaning
- Replaced NULL values in `director`, `casts`, and `country` columns with `'Not Given'`
- Deleted rows with NULL values in `rating`, `duration`, and `date_added` columns
- Ensured clean, analysis-ready data before running business queries

#### 3. Business Problem Solving — 15 SQL Queries

---

### 📊 Business Problems & Solutions

**1. Content Type Distribution — Movies vs TV Shows**

Objective: Measure how Netflix splits its library between Movies and TV Shows.
```sql
SELECT type, COUNT(*) AS count_by_type
FROM netflix
GROUP BY type;
```

---

**2. Most Frequent Rating for Each Content Type**

Objective: Identify the rating that appears most often for Movies and TV Shows separately using window functions.
```sql
SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;
```

---

**3. All Movies Released in a Specific Year**

Objective: Filter Movies by release year to track content volume for any given year (e.g., 2020).
```sql
SELECT * FROM netflix
WHERE type = 'Movie' AND release_year = 2020;
```

---

**4. Top 5 Countries Producing the Most Netflix Content**

Objective: Split multi-valued country column and rank countries by total content contribution.
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) AS countries_with_most_content,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

---

**5. Longest Movie on Netflix**

Objective: Identify the movie with the maximum duration using a subquery comparison.
```sql
SELECT * FROM netflix
WHERE type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix);
```

---

**6. Content Added in the Last 5 Years**

Objective: Use date arithmetic to retrieve recently added titles using INTERVAL.
```sql
SELECT * FROM netflix
WHERE date_added >= CURRENT_DATE - INTERVAL '5 Years';
```

---

**7. All Content Directed by 'Rajiv Chilaka'**

Objective: Use case-insensitive pattern matching to filter by a specific director across multi-director entries.
```sql
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

---

**8. TV Shows Running Longer Than 5 Seasons**

Objective: Extract the numeric season count from a text column and apply a numeric filter.
```sql
SELECT * FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;
```

---

**9. Total Content Count Per Genre**

Objective: Expand comma-separated genre values into individual rows and count content per genre.
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS Genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;
```

---

**10. Year-wise Average Content Released by India — Top 5 Years**

Objective: Calculate the percentage share of yearly Indian content releases relative to India's total, and return the top 5 peak years.
```sql
SELECT 
    EXTRACT(YEAR FROM date_added) AS Year,
    COUNT(*) AS yearly_content,
    ROUND(
        COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100, 2
    ) AS avg_content_produced_in_percent
FROM netflix
WHERE country = 'India'
GROUP BY 1;
```

---

**11. All Documentary Movies**

Objective: Filter the genre column using pattern matching to list all Documentaries.
```sql
SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';
```

---

**12. Content With No Director Information**

Objective: Surface all records where director data was missing (replaced with 'Not Given' during cleaning).
```sql
SELECT * FROM netflix
WHERE director ILIKE '%Not Given%';
```

---

**13. Salman Khan's Netflix Appearances in the Last 10 Years**

Objective: Combine date extraction and cast pattern matching to track a specific actor's recent content.
```sql
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

---

**14. Top 10 Most Appearing Actors in Indian Productions**

Objective: Expand comma-separated cast values, filter for Indian content, and rank actors by total appearances.
```sql
SELECT
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
    COUNT(*) AS films_performed
FROM netflix
WHERE country ILIKE '%India%'
AND casts != 'Not Given'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

---

**15. Content Categorization — 'Good' vs 'Bad' Based on Keywords**

Objective: Use a CTE with CASE WHEN logic to label content containing 'kill' or 'violence' in its description as 'Bad' and everything else as 'Good', then count each category.
```sql
WITH new_table AS (
    SELECT *,
        CASE
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY 1;
```

---

### 💡 Key Insights

- 📽️ **Movies dominate** Netflix's library, significantly outnumbering TV Shows in total content count
- 🏆 **TV-MA** is the most common rating for TV Shows and **TV-14** for Movies, indicating Netflix's primary focus on mature audiences
- 🌍 **United States, India, and United Kingdom** are the top 3 countries producing the most Netflix content
- 🇮🇳 India's Netflix content peaked in specific years — revealing strategic expansion timelines in the Indian market
- 🎭 **International Movies** and **Dramas** are the most dominant genres across the platform
- 🕵️ A significant portion of content has **no director listed**, highlighting data quality issues in Netflix's metadata
- 🎬 Bollywood actor **Salman Khan** appeared in multiple Netflix titles within the last 10 years, reflecting growing Bollywood presence
- ⚠️ Content categorized as **'Bad'** (containing keywords like 'kill' or 'violence' in description) vs **'Good'** reveals how much of Netflix's library leans toward intense or mature storytelling

---

### ▶️ How to Run

1. Install **PostgreSQL** and **pgAdmin**
2. Create a new database in pgAdmin
3. Open and run `Netflix-Content-Analysis.sql`
4. When importing `netflix_titles.csv` use pgAdmin's import tool with **comma delimiter** and **header row enabled**
5. Run queries section by section — Exploration → Cleaning → Business Problems

---

### 📂 Dataset

- **Source:** [Kaggle — Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)
- **Rows:** 8,800+
- **Columns:** 12
- **Key Fields:** Show ID, Type, Title, Director, Cast, Country, Date Added, Release Year, Rating, Duration, Genre, Description

---

### 👤 Author

**Anmol Tripathi**
📧 anmoltripathi8329@gmail.com
