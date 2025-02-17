-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- Create locations table
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone_number TEXT NOT NULL CHECK (phone_number GLOB '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    email TEXT UNIQUE NOT NULL CHECK(email LIKE '%@%.%'),
    opening_hours TEXT NOT NULL
);

-- Create members table
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL CHECK(email LIKE '%@%.%'),
    phone_number TEXT NOT NULL CHECK (phone_number GLOB '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    date_of_birth TEXT NOT NULL CHECK(date_of_birth GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'), -- No actual date or datetime type in sqlite3
    join_date TEXT NOT NULL DEFAULT (DATE('now')) CHECK(join_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    emergency_contact_name TEXT NOT NULL,
    emergency_contact_phone TEXT NOT NULL CHECK (emergency_contact_phone GLOB '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);

-- Create staff table
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL CHECK(email LIKE '%@%.%'),
    phone_number TEXT NOT NULL CHECK (phone_number GLOB '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    position TEXT CHECK(position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')) NOT NULL,
    hire_date TEXT NOT NULL DEFAULT (DATE('now')) CHECK(hire_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL
);

-- Create equipment table
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT CHECK(type IN ('Cardio', 'Strength')) NOT NULL,
    purchase_date TEXT NOT NULL CHECK(purchase_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    last_maintenance_date TEXT CHECK(last_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    next_maintenance_date TEXT CHECK(next_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL
);

-- Create classes table
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    capacity INTEGER NOT NULL CHECK(capacity > 0),
    duration INTEGER NOT NULL CHECK(duration > 0),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL
);

-- Create class schedule table
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    staff_id INTEGER,
    start_time TEXT NOT NULL CHECK(start_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    end_time TEXT NOT NULL CHECK(end_time_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- Create memberships table
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    type TEXT NOT NULL CHECK(type IN ('Premium', 'Basic')),
    start_date TEXT NOT NULL DEFAULT (DATE('now')) CHECK(start_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    end_date TEXT NOT NULL CHECK(end_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    status TEXT CHECK(status IN ('Active', 'Inactive')) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Create attendance table
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    check_in_time TEXT NOT NULL CHECK(check_in_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    check_out_time TEXT CHECK(check_out_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

-- Create class attendance table
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status TEXT CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')) NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Create payments table
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount REAL NOT NULL CHECK(amount > 0),
    payment_date TEXT NOT NULL DEFAULT (DATETIME('now')) CHECK(payment_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    payment_method TEXT CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')) NOT NULL,
    payment_type TEXT CHECK(payment_type IN ('Monthly membership fee', 'Day pass')) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Create personal training sessions table
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    staff_id INTEGER,
    session_date TEXT NOT NULL CHECK(session_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    start_time TEXT NOT NULL CHECK(start_time GLOB '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    end_time TEXT NOT NULL CHECK(end_time GLOB '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- Create member health metrics table
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    measurement_date TEXT NOT NULL CHECK(measurement_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    weight REAL NOT NULL CHECK(weight > 0),
    body_fat_percentage REAL CHECK(body_fat_percentage >= 0 AND body_fat_percentage <= 100),
    muscle_mass REAL CHECK(muscle_mass >= 0),
    bmi REAL CHECK(bmi > 0),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Create equipment maintenance log table
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    maintenance_date TEXT NOT NULL CHECK(maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    description TEXT NOT NULL,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal