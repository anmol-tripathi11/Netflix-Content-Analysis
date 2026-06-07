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
├── netflix_titles.csv              → Raw dataset (8,800+ Netflix titles)
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

### 📊 Business Problems & SQL Concepts Used

| # | Business Problem | SQL Concepts |
|---|---|---|
| 1 | Count of Movies vs TV Shows | `GROUP BY`, `COUNT` |
| 2 | Most common rating per content type | `RANK()`, `PARTITION BY`, Subquery |
| 3 | All movies released in a specific year | `WHERE`, Filtering |
| 4 | Top 5 countries with most content | `UNNEST`, `STRING_TO_ARRAY`, `ORDER BY` |
| 5 | Identify the longest movie | `MAX()`, Subquery |
| 6 | Content added in the last 5 years | `CURRENT_DATE`, `INTERVAL` |
| 7 | Movies/TV Shows by director 'Rajiv Chilaka' | `ILIKE`, Pattern Matching |
| 8 | TV Shows with more than 5 seasons | `SPLIT_PART`, Type Casting |
| 9 | Content count per genre | `UNNEST`, `STRING_TO_ARRAY`, `COUNT` |
| 10 | Avg yearly content release from India (Top 5 years) | `EXTRACT`, `ROUND`, Subquery |
| 11 | All movies listed as Documentaries | `ILIKE`, Pattern Matching |
| 12 | Content with no director | `ILIKE` |
| 13 | Salman Khan movies in the last 10 years | `EXTRACT`, `ILIKE`, Date Functions |
| 14 | Top 10 actors in Indian-produced movies | `UNNEST`, `STRING_TO_ARRAY`, `ORDER BY` |
| 15 | Categorize content as 'Good' vs 'Bad' based on keywords | `CTE`, `CASE WHEN`, `ILIKE` |

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
