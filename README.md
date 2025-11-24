# 📊 Modern Data Pipeline Project (Snowflake + dbt + Power BI)

This project demonstrates an **end-to-end data pipeline**:
- Extract data from **external sources** (GitHub) using **Airbyte**  
- Load raw data into **Snowflake Bronze layer**  
- Transform data with **dbt** (Silver & Gold layers)  
- Build dimensional models (Star Schema)  
- Visualize insights using **Power BI dashboards**

---

## 📁 Project Structure

```
project/
├── assets/                     # Store all images here
│   ├── data_flow.png          # Data pipeline flow diagram
│   ├── data_modeling.png      # Star schema / data modeling diagram
│   ├── Dashboard1.png         # Power BI dashboard screenshot
│   ├── Dashboard2.png
│   └── Dashboard3.png
├── PowerBI/
│   └── churn_analysis.pbix    # Power BI dashboard file
├── requirements.txt
├── snowflake/
│   ├── dbt_project.yml
│   └── models/
│       ├── Raw/
│       ├── Silver/
│       └── Gold/
└── README.md
```

> **Note:** All images referenced in this README are stored in the `assets/` folder. The actual Power BI dashboard file is in the `PowerBI/` folder.

---

## 1️⃣ Data Pipeline Flow

### **📌 Overview**

![Data Flow](assets/data_flow.png)

**Steps:**
1. **Data ingestion:** Airbyte extracts data from GitHub and other sources  
2. **Bronze layer:** Raw data is loaded into Snowflake  
3. **Silver layer:** Cleaned and normalized data  
4. **Gold layer:** Final fact & dimension tables for analytics  
5. **Power BI:** Connect to Gold layer for dashboards  

---

## 2️⃣ Data Ingestion with Airbyte

Airbyte is used to move data from **sources** to **destinations**:
- You **choose a source** (e.g., GitHub repository, API, CSV)  
- You **choose a destination** (Snowflake Bronze layer in this project)  
- Airbyte handles extraction, incremental updates, and loading  
- dbt performs transformations and modeling in Silver and Gold layers  

> **Note:** Airbyte configuration files are not included. Replace credentials with environment variables when setting up your own instance.

---

## 3️⃣ Data Modeling

### **📌 Star Schema Diagram**

![Data Modeling](assets/data_modeling.png)

- **Fact table:** `fact_service`  
- **Dimensions:** `dim_customer`, `dim_contract`, `dim_location`, `dim_population`, `dim_time`  
- Designed for analytics and reporting in Power BI  

---

## 4️⃣ dbt Project Structure

```
snowflake/models/
├── Raw/
│   └── sources.yml
├── Silver/
│   ├── demographics.sql
│   ├── location.sql
│   ├── population.sql
│   ├── service.sql
│   └── status.sql
└── Gold/
    ├── dim_customer.sql
    ├── dim_contract.sql
    ├── dim_location.sql
    ├── dim_population.sql
    ├── dim_time.sql
    ├── fact_service.sql
    └── schema.yml            # tests
```

- **Raw:** External source definitions  
- **Silver:** Data cleaning, normalization, and type casting  
- **Gold:** Analytics-ready tables with dbt tests  

---

## 5️⃣ Power BI Dashboards

### 📊 Dashboard 1  
![Dashboard 1](assets/Dashboard1.png)

### 📊 Dashboard 2  
![Dashboard 2](assets/Dashboard2.png)

### 📊 Dashboard 3  
![Dashboard 3](assets/Dashboard3.png)

**Power BI file:**  
The interactive dashboard is available in `PowerBI/churn_analysis.pbix`.

---

## 6️⃣ Requirements

Install Python dependencies:

```bash
pip install -r requirements.txt
```

---

## 7️⃣ How to Run the Project

1. Load raw data into Snowflake Bronze layer (via Airbyte or other ingestion method)

2. Navigate to your dbt project folder:

```bash
dbt deps
dbt seed
dbt run
dbt test
```

3. Open the `.pbix` file in the `PowerBI/` folder to explore dashboards

---

## 8️⃣ Notes

- Airbyte is used for data ingestion, but configuration files are not included
- Replace credentials with environment variables when setting up Snowflake
- Store all images in the `assets/` folder for README references

---


---

## 🛠️ Technologies Used

- **Snowflake** - Cloud data warehouse
- **dbt (Data Build Tool)** - Data transformation
- **Airbyte** - Data ingestion
- **Power BI** - Data visualization
- **SQL** - Query language

---



