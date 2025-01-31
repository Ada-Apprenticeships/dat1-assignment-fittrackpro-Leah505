-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Membership Management Queries

-- 5.1. List all active memberships with member details
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    ms.type AS membership_type, 
    m.join_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE ms.status = 'Active'
ORDER BY m.join_date DESC;

-- 5.2. Calculate the average duration of gym visits for each membership type
SELECT 
    ms.type AS membership_type, 
    ROUND(AVG(strftime('%s', a.check_out_time) - strftime('%s', a.check_in_time)) / 60, 2) AS avg_visit_duration_minutes
FROM attendance a
JOIN memberships ms ON a.member_id = ms.member_id
WHERE a.check_out_time IS NOT NULL
GROUP BY ms.type
ORDER BY avg_visit_duration_minutes DESC;

-- 5.3. Identify members with expiring memberships this year
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    m.email, 
    ms.end_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE ms.end_date BETWEEN DATE('now') AND DATE('now', '+1 year')
ORDER BY ms.end_date ASC;