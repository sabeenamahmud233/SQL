use vishnu;


SELECT * FROM vishnu.address;
SELECT * FROM vishnu.students;
SELECT * FROM vishnu.student_parent;
SELECT * FROM vishnu.parents;

SELECT 
    s.ID, 
    s.FIRST_NAME, 
    s.LAST_NAME, 
    s.DOB,
    p.FIRST_NAME,
    p.LAST_NAME,
    p.ID
FROM
    vishnu.students s
        JOIN
    vishnu.student_parent sp ON s.ID = sp.STUDENT_ID
        JOIN
    vishnu.parents p ON sp.PARENT_ID = p.ID
ORDER BY s.ID;

SELECT 
    *
FROM
    vishnu.students s
        JOIN
    vishnu.student_parent sp ON s.ID = sp.STUDENT_ID
        JOIN
    vishnu.parents p ON sp.PARENT_ID = p.ID
ORDER BY s.ID;
