PRAGMA foreign_keys = ON;

-- Task 1: User Management Tests
-- ========================================

-- 1.1 Test: Insert valid member
INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES ('John', 'Doe', 'john.doe@email.com', '555-1234', '1990-01-01', '2024-01-01', 'Jane Doe', '555-5678');

-- 1.2 Test: Insert member with NULL value in `first_name` (NOT NULL constraint violation)
INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES (NULL, 'Smith', 'smith@email.com', '555-9876', '1985-06-15', '2024-02-01', 'Alice Smith', '555-1122');

-- 1.3 Test: Insert member with invalid `date_of_birth` (CHECK constraint violation)
INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES ('Jane', 'Doe', 'jane.doe@email.com', '555-3333', '2025-00-01', '2024-01-01', 'Bob Doe', '555-4433');

-- 1.4 Test: Insert member with missing `emergency_contact_name` (NOT NULL constraint violation)
INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES ('Alice', 'Green', 'alice.green@email.com', '555-5555', '1994-12-20', '2024-03-01', NULL, '555-9876');

-- 1.5 Test: Insert member with duplicate `email` (UNIQUE constraint violation)
INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES ('Michael', 'Brown', 'john.doe@email.com', '555-6666', '1988-11-15', '2024-04-01', 'Eve Brown', '555-4433');


-- Task 2: Payment Management Tests
-- ========================================

-- 2.1 Test: Insert payment for a member
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (1, 50.00, '2025-02-17 11:00:00', 'Credit Card', 'Monthly membership fee');

-- 2.2 Test: Insert payment with invalid `member_id` (FOREIGN KEY constraint violation)
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (1000, 30.00, '2025-02-17 12:00:00', 'Credit Card', 'Monthly membership fee');

-- 2.3 Test: Insert payment with invalid `payment_type` (CHECK constraint violation)
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (1, 100.00, '2025-02-17 15:00:00', 'Credit Card', 'Invalid type');

-- 2.4 Test: Insert payment with NULL `amount` (NOT NULL constraint violation)
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (1, NULL, '2025-02-17 10:00:00', 'Credit Card', 'Monthly membership fee');


-- Task 3: Equipment Management Tests
-- ========================================

-- 3.0 Test: Ensure we have valid locations for equipment
-- Insert test data into the `locations` table
INSERT INTO locations (name, address, phone_number, email, opening_hours)
VALUES 
('Downtown Fitness', '123 Main St, Cityville', '555-1234', 'downtown@fittrack.com', '6:00-21:00'),
('Uptown Fitness', '456 Oak St, Cityville', '555-5678', 'uptown@fittrack.com', '7:00-22:00');

-- 3.1 Test: Insert equipment with NULL `name` (NOT NULL constraint violation)
INSERT INTO equipment (name, type, purchase_date, last_maintenance_date, next_maintenance_date, location_id)
VALUES (NULL, 'Cardio', '2020-01-01', '2024-01-01', '2025-02-20', 1);

-- 3.2 Test: Insert equipment with invalid `location_id` (FOREIGN KEY constraint violation)
INSERT INTO equipment (name, type, purchase_date, last_maintenance_date, next_maintenance_date, location_id)
VALUES ('Treadmill', 'Cardio', '2020-01-01', '2024-01-01', '2025-02-20', 100);

-- 3.3 Test: Insert equipment with invalid `next_maintenance_date` (CHECK constraint violation)
INSERT INTO equipment (name, type, purchase_date, last_maintenance_date, next_maintenance_date, location_id)
VALUES ('Treadmill', 'Cardio', '2020-01-01', '2024-01-01', '2025-02-177', 1);


-- Task 4: Class Scheduling Tests
-- ========================================

-- 4.1 Test: Insert class schedule with NULL `start_time` (NOT NULL constraint violation)
INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES (1, 1, NULL, '2025-02-01 10:00');

-- 4.2 Test: Insert class schedule with invalid `staff_id` (FOREIGN KEY constraint violation)
INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES (1, 1000, '2025-02-01 09:00:00', '2025-02-01 10:00:00');

-- 4.3 Test: Insert class schedule with invalid `end_time` (CHECK constraint violation)
INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES (1, 1, '2025-02-01 10:00:00', '2025-02-01 09:00');


-- Task 5: Membership Management Tests
-- ========================================

-- 5.1 Test: Insert membership with NULL `status` (NOT NULL constraint violation)
INSERT INTO memberships (member_id, type, start_date, end_date, status)
VALUES (1, 'Premium', '2024-01-01', '2025-01-01', NULL);

-- 5.2 Test: Insert membership with invalid `type` (CHECK constraint violation)
INSERT INTO memberships (member_id, type, start_date, end_date, status)
VALUES (1, 'InvalidType', '2024-01-01', '2025-01-01', 'Active');


-- Task 6: Attendance Tracking Tests
-- ========================================

-- 6.1 Test: Insert attendance with invalid `location_id` (FOREIGN KEY constraint violation)
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (1, 1000, '2025-02-17 09:00:00', '2025-02-17 10:00:00');

-- 6.2 Test: Insert attendance with NULL `check_in_time` (NOT NULL constraint violation)
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (1, 1, NULL, '2025-02-17 10:00:00');

-- 6.3 Test: Insert attendance with invalid `check_out_time` (CHECK constraint violation)
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (1, 1, '2025-02-17 09:00:00', '2025-02-16 10:00');


-- Task 7: Staff Management Tests
-- ========================================

-- 7.1 Test: Insert staff with NULL `email` (NOT NULL constraint violation)
INSERT INTO staff (first_name, last_name, email, phone_number, position, hire_date, location_id)
VALUES ('Ivy', 'Irwin', NULL, '555-1234', 'Trainer', '2020-01-01', 1);

-- 7.2 Test: Insert staff with invalid `location_id` (FOREIGN KEY constraint violation)
INSERT INTO staff (first_name, last_name, email, phone_number, position, hire_date, location_id)
VALUES ('Alex', 'Smith', 'alex.smith@email.com', '555-5678', 'Manager', '2021-06-01', 100);


-- Task 8: Personal Training Tests
-- ========================================

-- 8.1 Test: Insert personal training session with NULL `session_date` (NOT NULL constraint violation)
INSERT INTO personal_training_sessions (member_id, staff_id, session_date, start_time, end_time)
VALUES (1, 2, NULL, '09:00:00', '10:00:00');

-- 8.2 Test: Insert personal training session with invalid `member_id` (FOREIGN KEY constraint violation)
INSERT INTO personal_training_sessions (member_id, staff_id, session_date, start_time, end_time)
VALUES (101, 1, '2025-02-17', '09:00:00', '10:00:00');