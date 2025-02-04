CREATE TABLE students(
student_id int primary key,
full_name varchar(30),
email varchar(100),
phone_number varchar(11),
date_of_birth date,
registration_date date,
course_id int,
payment_status varchar(10),
total_fees varchar(50)
)

Create table Courses_Table(
course_id int primary key,
course_name varchar(100),
category varchar(100),
duration_weeks int,
fees varchar(100)
)

create table Instructors_Table(
instructor_id int primary key,
full_name varchar(50),
email varchar(100),
phone_number varchar(11),
expertise varchar(100),
salary varchar(100)
)

create table Payments_table (
payment_id int primary key,
student_id int ,
amount_paid varchar(100),
payment_date date,
payment_method varchar(30)
) 

create table feedback_table (
feedback_id int primary key,
student_id int ,
course int ,
rating int,
commentss varchar(100)
) 
create table Enrollments_table(
enrollment_id int primary key,
student_id  int,
course_id  int ,
enrollment_date date,
status varchar(100)
)

create table Attendance_table(
attendance_id int primary key,
student_id int,
course_id int,
datee date,
status  varchar(100)
)

select * from students
select * from courses_table
select * from feedback_table
select * from instructors_table
select * from payments_table
select * from attendance_table
select * from enrollments_table


-- SQL Questions to Solve
-- Basic Queries
-- 1.Retrieve a list of all students along with the courses they are enrolled in.
		select s.full_name , c.course_name
		from students s
		join courses_table c
		on c.course_id = s.course_id
-- Find the total number of students enrolled in each course.
		select c.course_name, count(s.student_id) 
		from students s
		join courses_table c
		on c.course_id = s.course_id
		group by c.course_name
-- Get details of instructors and the courses they are teaching.
		select * from instructors_table

					
		select i.full_name, c.course_name from
		instructors_table i
		join courses_table c
		on c.category = i.expertise
-- Retrieve a list of students who have not paid their fees.
		select full_name
		from students 
		where payment_status ='Pending'
-- Get a list of students who have attended less than 75% of their classes.
		with attendancesummary as(
			select 	student_id,
			count(*) as total_classes,
			sum(case when status ='Present' then 1 else 0 end) as attended_classes,
			(sum(case when status ='Present' then 1 else 0 end)*100)/count(*) as attendance_percentage
			from attendance_table
			group by student_id
		)
		SELECT s.student_id, s.full_name, a.attended_classes, a.total_classes, a.attendance_percentage
		FROM AttendanceSummary a
		JOIN students s ON a.student_id = s.student_id
		WHERE a.attendance_percentage < 75;



-- Intermediate Queries
-- Find the total revenue generated from course enrollments.
		select SUM(c.fees::NUMERIC) as total_Revenu
		from courses_table c
		join enrollments_table e
		on e.course_id = c.course_id
		where status ='Completed'

-- Identify the most popular course based on enrollments.
		select c.course_name , count(e.student_id)
		from enrollments_table e
		join courses_table c
		on c.course_id =e.course_id
		group by c.course_name
		order by count(student_id) desc
-- Find students who have completed their courses but have not given feedback.
		SELECT s.student_id, s.full_name, e.course_id, c.course_name
		FROM Enrollments_table e
		JOIN Students s ON e.student_id = s.student_id
		JOIN Courses_table c ON e.course_id = c.course_id
		LEFT JOIN Feedback_table f ON e.student_id = f.student_id AND e.course_id = f.course
		WHERE e.status = 'Completed' AND f.feedback_id IS NULL;

-- Retrieve the total number of absent days for each student.
		SELECT student_id, COUNT(*) AS total_absent_days
		FROM Attendance_table
		WHERE status = 'Absent'
		GROUP BY student_id;

-- Find students whose birthday is in the current month.
		SELECT * 
		FROM Students 
		WHERE EXTRACT(MONTH FROM date_of_birth) = EXTRACT(MONTH FROM CURRENT_DATE);












