-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 4.1. List all classes with their instructors
SELECT 
    c.class_id, 
    c.name AS class_name, 
    s.first_name || ' ' || s.last_name AS instructor_name
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN staff s ON cs.staff_id = s.staff_id
ORDER BY c.class_id;

-- 4.2. Find available classes for a specific date
SELECT 
    c.class_id, 
    c.name, 
    cs.start_time, 
    cs.end_time, 
    (c.capacity - COUNT(ca.member_id)) AS available_spots
FROM class_schedule cs
JOIN classes c ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE DATE(cs.start_time) = '2025-02-01'
GROUP BY c.class_id, c.name, cs.start_time, cs.end_time, c.capacity
HAVING available_spots > 0
ORDER BY cs.start_time;

-- 4.3. Register member 11 for Spin Class (class_id 3) on 2025-02-01
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT 
    cs.schedule_id, 
    11, 
    'Registered'
FROM class_schedule cs
WHERE cs.class_id = 3 
AND DATE(cs.start_time) = '2025-02-01'
LIMIT 1;

-- 4.4. Cancel registration for member 2 from Yoga Basics (schedule_id 7)
DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;

-- 4.5. List top 3 most popular classes by registration count
SELECT 
    c.class_id, 
    c.name AS class_name, 
    COUNT(ca.member_id) AS registration_count
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
WHERE ca.attendance_status IN ('Registered', 'Attended')
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC
LIMIT 3;

-- 4.6. Calculate average number of classes per member
SELECT 
    ROUND(AVG(class_count), 2) AS avg_classes_per_member
FROM (
    SELECT member_id, COUNT(*) AS class_count
    FROM class_attendance
    WHERE attendance_status IN ('Registered', 'Attended')
    GROUP BY member_id
);