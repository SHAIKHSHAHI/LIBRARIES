# Library Management System 
## ![Uploading image.png…]()


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
- **Table Creation:** Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships
CREATE DATABASE library_db;
* **Database Creation:** Created a database named library_db.
* 
 ## 2. CRUD Operations

**1.Create:** Inserted sample records into the books table.

**2.Read:** Retrieved and displayed data from various tables.

**3.Update:** Updated records in the employees table.

**4.Delete:** Removed records from the members table as needed.

**Task 1. Create a New Book Record** -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
```
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2',
'To Kill a Mockingbird',
 'Classic', 6.00, 'yes',
'Harper Lee',
'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**
```
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```
**Task 3: Delete a Record from the Issued Status Table**-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
```
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```
**Task 4: Retrieve All Books Issued by a Specific Employee**-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```
**Task 5: List Members Who Have Issued More Than One Book**--
 Objective: Use GROUP BY to find members who have issued more than one book.
 ```
SELECT issued_emp_id
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1;
```
## 3. CTAS (Create Table As Select)
**Task 6: Create Summary Tables:** Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
```
CREATE TABLE book_issued_cnt AS
SELECT a.isbn, a.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as a
ON ist.issued_book_isbn = a.isbn
GROUP BY a.isbn, a.book_title;
```
## 4. Data Analysis & Findings
The following SQL queries were used to address specific questions:

**Task 7. Retrieve All Books in a Specific Category:**
```
select book_title from books
where category ='children';
```
**Task 8: Find Total Rental Income by Category:**
```
select *from books;
select * from issued_status;
select a.category,sum(rental_price)
from books as a
join issued_status as b
on a.isbn=b.issued_book_isbn
group by category;
```
**task 9 ----List Members Who Registered in the Last 180 Days:**
```
SELECT member_name from members
where DATE_SUB("2024-05-01", INTERVAL -180 day);
```
**task 10 List Employees with Their Branch Manager's Name and their branch details:**
```
select 
 e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;
```
**task 11 Create a Table of Books with Rental Price Above a Certain Threshold:**
```
create table expensive_book as 
select book_title from books
where rental_price>7.00;
```

## Advanced SQL Operations

**Task 12: Identify Members with Overdue Books**
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.#----

 ```
select issued_member_id,issued_book_name,issued_date,member_name,
current_date()-issued_date as overdue_date
from issued_status as a
join members as b
on a.issued_member_id = b.member_id
left join 
return_status as c
ON a.issued_id = c.return_issued_id
where c.return_date is null
and
(current_date()-issued_date)>100;
```
**Task 13: Branch Performance Report**
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.

```
CREATE TABLE branch_reports
AS
select br.branch_id,br.manager_id,
sum(rental_price)as total_revenue,
count(return_id)as number_of_books_returned,
count(issued_id)as number_of_books_issued
from issued_status as iss
join return_status as rs
on rs.return_issued_id= iss.issued_id
left join employees as emp
on emp.emp_id= iss.issued_emp_id
join branch as br
on br.branch_id = emp.branch_id
join books as bks
on bks.isbn=iss.issued_book_isbn
group by 1,2;
```
SELECT * FROM branch_reports;

**Task 14: CTAS: Create a Table of Active Members**
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have issued at least one book in the last 6 months.

```
  CREATE TABLE active_members 
  AS
select *from issued_status
where issued_member_id in(
                          select distinct (issued_member_id)
	             from issued_status
		where issued_date <=current_date()+interval 2 month) ;
```                          
SELECT *FROM ACTIVE_MEMBERS;


**Task 15: Find Employees with the Most Book Issues Processed**
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.

```
CREATE TABLE TOP_3_EMPLOYEES 
AS(
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2
ORDER BY COUNT(ist.issued_id) DESC
LIMIT 3);
```
SELECT * FROM TOP_3_EMPLOYEES ;

## Reports
 
 *  **Database Schema:** Detailed table structures and relationships.
* **Data Analysis:**  Insights into book categories, employee salaries, member registration trends, and issued books.
*  **Summary Reports:** Aggregated data on high-demand books and employee performance.

## Conclusion
This project demonstrates the application of SQL skills in creating and managing a library management system.
It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.
