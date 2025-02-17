-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 6.1. Record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time) 
VALUES (7, 1, DATETIME('now'));

-- 6.2. Retrieve a member's attendance history
SELECT 
    DATE(check_in_time) AS visit_date, 
    check_in_time, 
    check_out_time 
FROM attendance 
WHERE member_id = 5
ORDER BY check_in_time DESC;

-- 6.3. Find the busiest day of the week based on gym visits (with day name)
SELECT 
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4. Calculate the average daily attendance for each location
SELECT 
    l.name AS location_name, 
    ROUND(COUNT(a.attendance_id) * 1.0 / COUNT(DISTINCT DATE(a.check_in_time)), 2) AS avg_daily_attendance
FROM attendance a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.location_id
ORDER BY avg_daily_attendance DESC;