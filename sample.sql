use simplilearn

SELECT 
    s.ID, 
    s.FIRST_NAME, 
    s.LAST_NAME, 
    s.DOB,
    p.FIRST_NAME,
    p.LAST_NAME,
    p.ID
FROM
    simplilearn.students s
        JOIN
    simplilearn.student_parent sp ON s.ID = sp.STUDENT_ID
        JOIN
    simplilearn.parents p ON sp.PARENT_ID = p.ID
ORDER BY s.ID;

SELECT 
    *
FROM
    simplilearn.students s
        JOIN
    simplilearn.student_parent sp ON s.ID = sp.STUDENT_ID
        JOIN
    simplilearn.parents p ON sp.PARENT_ID = p.ID
ORDER BY s.ID;
