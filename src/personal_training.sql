-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Personal Training Queries

-- 8.1. List all personal training sessions for a specific trainer "Ivy Irwin"
SELECT 
    pt.session_id, 
    m.first_name || ' ' || m.last_name AS member_name, 
    pt.session_date, 
    pt.start_time, 
    pt.end_time
FROM personal_training_sessions pt
JOIN staff s ON pt.staff_id = s.staff_id
JOIN members m ON pt.member_id = m.member_id
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin'
ORDER BY pt.session_date, pt.start_time;