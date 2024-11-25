# Library Management System 
## ![Uploading image.png…](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

# Objectives
**1.Table Creation:** Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

**2. CRUD Operations:** Perform Create, Read, Update, and Delete operations on the data.

**3. CTAS (Create Table As Select):** Utilize CTAS to create new tables based on query results.

**4.Advanced SQL Queries:** Develop complex queries to analyze and retrieve specific data.


#  Project Structure
## 1. Database Setup
```

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);
```
- George Washington
* John Adams
+ Thomas Jefferson

**Table Creation:** Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships
CREATE DATABASE library_db;

**Database Creation:** Created a database named library_db.
