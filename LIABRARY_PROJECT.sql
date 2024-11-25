

SELECT * FROM return_status;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM branch;



#task one Task 1. Create a New Book Record -- "978-1-60129-456-2', 
#'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee',
 #'J.B. Lippincott & Co.')"----------------------------

insert into books
(isbn,book_title,category,rental_price, status, author,publisher)
values
('978-1-60129-456-2',
 'To Kill a Mockingbird', 
 'Classic',
  6.00,
  'yes', 
 'Harper Lee', 
 'J.B.Lippincott & Co.');
 
 
 select count(*) from books;
 # Task 2: Update an Existing Member's Address
select * from members;
update members
set member_address="567 saim main street" 
where member_id = 'C101';

# task 3-------Task 3: Delete a Record from the Issued Status Table
 -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.


SET sql_safe_updates=0;
DELETE FROM issued_status
WHERE   issued_id =   'IS107';


#task 4------------Task 4: Retrieve All Books Issued by a Specific Employee -- 
#-----Objective: Select all books issued by the employee with emp_id = 'E101'.

select issued_book_name
from issued_status
where issued_emp_id = 'E104';

#Task 5: List Members Who Have Issued More Than One Book --
 #Objective: Use GROUP BY to find members who have issued more than one book.
 
SELECT issued_emp_id
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1;
 
#task 6   CTAS (Create Table As Select)
#Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
#each book and total book_issued_cn

CREATE TABLE book_issued_cnt AS
SELECT a.isbn, a.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as a
ON ist.issued_book_isbn = a.isbn
GROUP BY a.isbn, a.book_title;

select * from book_issued_cnt;

#Task 7. Retrieve All Books in a Specific Category:

select book_title from books
where category ='children';

#Task 8: Find Total Rental Income by Category:

select *from books;
select * from issued_status;
select a.category,sum(rental_price)
from books as a
join issued_status as b
on a.isbn=b.issued_book_isbn
group by category;

# task 9 ----List Members Who Registered in the Last 180 Days:

SELECT member_name from members
where DATE_SUB("2024-05-01", INTERVAL -180 day);

# task 10 List Employees with Their Branch Manager's Name and their branch details:

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

#task 11 Create a Table of Books with Rental Price Above a Certain Threshold:

create table expensive_book as 
select book_title from books
where rental_price>7.00;


#Advanced queries 
------#Task 12: Identify Members with Overdue Books
#-----Write a query to identify members who have overdue books (assume a 30-day return period).
 #---Display the member's_id, member's name, book title, issue date, and days overdue.#----

 
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

#Task 13: Branch Performance Report
#Create a query that generates a performance report for each branch, 
#showing the number of books issued, the number of books returned, 
#and the total revenue generated from book rentals.


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

SELECT * FROM branch_reports;

#----Task 14: CTAS: Create a Table of Active Members
#Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
#containing members who have issued at least one book in the last 6 months.


  CREATE TABLE active_members 
  AS
select *from issued_status
where issued_member_id in(
                          select distinct (issued_member_id)
						  from issued_status
						  where issued_date <=current_date()+interval 2 month) ;
                          
SELECT *FROM ACTIVE_MEMBERS;


#Task 15: Find Employees with the Most Book Issues Processed
#Write a query to find the top 3 employees who have processed the most book issues. 
#Display the employee name, number of books processed, and their branch.


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

SELECT * FROM TOP_3_EMPLOYEES ;



