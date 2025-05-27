# University Enrollment Database Using SQL

This repository contains a full-featured **Student Enrollment Management System** implemented using SQL, designed to simulate a university-level database that manages students, courses, enrollments, academic tracks, and prerequisites.

This project was completed as part of the **Data Repository Systems** course and demonstrates relational schema design, normalization, integrity constraints, and SQL-based academic analytics.

## ER Diagram

![ER Diagram](ER%20Diagram.png)

The ER diagram illustrates the complete structure of the database, including tables, primary and foreign keys, and relationships between entities.

## Project Features

- Fully normalized schema (3NF)
- Referential integrity using primary and foreign keys
- SQL scripts to define schema and populate test data
- Advanced queries to check graduation eligibility and prerequisites
- Course demand analytics and student performance summaries
- Views for academic advisor dashboards

## Schema Overview

- `student`: Contains student ID, name, and track information
- `course`: Lists course metadata (ID, credits, classroom, etc.)
- `enroll`: Connects students to their course enrollments
- `tracks`: Represents academic majors and subtracks
- `trackReq`: Specifies required courses per track
- `prereq`: Defines course prerequisite relationships

## File Descriptions

| File | Description |
|------|-------------|
| `Student_Enrollment_Management_SQL_Project.sql` | All SQL code: schema creation, inserts, and queries |
| `ER Diagram.png` | Entity Relationship Diagram |
| `projectDB.zip` | Zipped version of the full database project |
| `README.md` | Project documentation for GitHub |

## SQL Concepts Used

- Relational schema design
- Data normalization (up to 3NF)
- Table creation and integrity constraints
- Inner/outer joins, group by, subqueries, views
- Conditional logic using SQL functions

## Skills Demonstrated

- SQL development and optimization
- Database modeling from real-world use cases
- Translating academic policies into data logic
- Educational data analytics
- ER diagram interpretation

## Getting Started

1. Clone or download this repository.
2. Open the `.sql` file in your preferred SQL database (PostgreSQL, MySQL, SQLite).
3. Run the schema definitions and data insertions.
4. Execute the sample queries or design your own based on the structure.

## Real-World Applications

This system models common components found in:

- University Student Information Systems (SIS)
- Course registration platforms
- LMS or EdTech platforms
- HR training & compliance systems

