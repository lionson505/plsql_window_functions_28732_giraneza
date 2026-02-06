-- Q4 Part A — SQL JOINs Implementation

-- List all students with their courses
SELECT s.first_name, s.last_name, c.course_name, sc.enrollment_status
FROM student_courses sc
INNER JOIN students s ON sc.student_id = s.id
INNER JOIN courses c ON sc.course_id = c.id;

-- Students who never enrolled in any course
SELECT s.first_name, s.last_name, sc.course_id
FROM students s
LEFT JOIN student_courses sc ON s.id = sc.student_id
WHERE sc.course_id IS NULL;

-- Courses without any students
SELECT c.course_name, s.first_name, s.last_name
FROM courses c
LEFT JOIN student_courses sc ON c.id = sc.course_id
LEFT JOIN students s ON sc.student_id = s.id
WHERE sc.student_id IS NULL;

-- All students and all courses, even if no enrollment
SELECT s.first_name, s.last_name, c.course_name
FROM students s
FULL OUTER JOIN student_courses sc ON s.id = sc.student_id
FULL OUTER JOIN courses c ON sc.course_id = c.id;

-- Students in the same course
SELECT s1.first_name AS student1, s2.first_name AS student2, c.course_name
FROM student_courses sc1
JOIN student_courses sc2 ON sc1.course_id = sc2.course_id AND sc1.student_id <> sc2.student_id
JOIN students s1 ON sc1.student_id = s1.id
JOIN students s2 ON sc2.student_id = s2.id
JOIN courses c ON sc1.course_id = c.id;

-- Q4 Part B — SQL Aggregations Implementation

-- Rank students by number of courses enrolled
SELECT s.first_name, s.last_name, COUNT(sc.course_id) AS total_courses,
       RANK() OVER (ORDER BY COUNT(sc.course_id) DESC) AS course_rank
FROM students s
LEFT JOIN student_courses sc ON s.id = sc.student_id
GROUP BY s.id
ORDER BY course_rank;

-- Running total of students enrolled per course
SELECT c.course_name, s.first_name, s.last_name,
       COUNT(sc.student_id) OVER (PARTITION BY c.id ORDER BY s.id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM courses c
LEFT JOIN student_courses sc ON c.id = sc.course_id
LEFT JOIN students s ON sc.student_id = s.id
ORDER BY c.course_name, s.id;

-- Divide students into quartiles based on total courses enrolled
SELECT s.first_name, s.last_name, COUNT(sc.course_id) AS total_courses,
       NTILE(4) OVER (ORDER BY COUNT(sc.course_id) DESC) AS quartile
FROM students s
LEFT JOIN student_courses sc ON s.id = sc.student_id
GROUP BY s.id
ORDER BY quartile;
