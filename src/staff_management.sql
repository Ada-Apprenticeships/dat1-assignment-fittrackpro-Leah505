-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Staff Management Queries

-- 7.1. List all staff members by role
SELECT 
    staff_id, 
    first_name, 
    last_name, 
    position AS role
FROM staff
ORDER BY position, last_name;

-- 7.2. Find trainers with one or more personal training sessions in the next 30 days
SELECT 
    s.staff_id AS trainer_id, 
    s.first_name || ' ' || s.last_name AS trainer_name, 
    COUNT(pt.session_id) AS session_count
FROM personal_training_sessions pt
JOIN staff s ON pt.staff_id = s.staff_id
WHERE s.position = 'Trainer'
AND pt.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
GROUP BY s.staff_id
HAVING COUNT(pt.session_id) > 0
ORDER BY session_count DESC;