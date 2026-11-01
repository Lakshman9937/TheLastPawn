-- ============================================================
-- THE LAST PAWN CHESS ACADEMY — Database Setup Script
-- Database: CSE9937 (Microsoft SQL Server)
-- Run this script in SQL Server Management Studio 20
-- ============================================================

USE CSE9937;
GO

-- ============================================================
-- TABLE: users
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
    CREATE TABLE users (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        full_name NVARCHAR(100) NOT NULL,
        username NVARCHAR(50) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        phone NVARCHAR(20),
        password_hash NVARCHAR(255) NOT NULL,
        experience_level NVARCHAR(20) DEFAULT 'Beginner',
        is_admin BIT DEFAULT 0,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT UQ_users_username UNIQUE (username),
        CONSTRAINT UQ_users_email UNIQUE (email)
    );
    PRINT 'Created table: users';
END
ELSE
    PRINT 'Table users already exists';
GO

-- ============================================================
-- TABLE: courses
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='courses' AND xtype='U')
BEGIN
    CREATE TABLE courses (
        course_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(200) NOT NULL,
        description NVARCHAR(MAX),
        difficulty NVARCHAR(20) DEFAULT 'Beginner',
        image_path NVARCHAR(255),
        lessons_count INT DEFAULT 0,
        is_published BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created table: courses';
END
ELSE
    PRINT 'Table courses already exists';
GO

-- ============================================================
-- TABLE: puzzles
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='puzzles' AND xtype='U')
BEGIN
    CREATE TABLE puzzles (
        puzzle_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(200) NOT NULL,
        description NVARCHAR(MAX),
        image_path NVARCHAR(255),
        difficulty NVARCHAR(20) DEFAULT 'Intermediate',
        solution NVARCHAR(500),
        explanation NVARCHAR(MAX),
        is_published BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created table: puzzles';
END
ELSE
    PRINT 'Table puzzles already exists';
GO

-- ============================================================
-- TABLE: challenges (Chess Challenges / Quizzes)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='challenges' AND xtype='U')
BEGIN
    CREATE TABLE challenges (
        challenge_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(200) NOT NULL,
        question NVARCHAR(MAX) NOT NULL,
        option_a NVARCHAR(500) NOT NULL,
        option_b NVARCHAR(500) NOT NULL,
        option_c NVARCHAR(500) NOT NULL,
        option_d NVARCHAR(500) NOT NULL,
        correct_option CHAR(1) NOT NULL,
        explanation NVARCHAR(MAX),
        difficulty NVARCHAR(20) DEFAULT 'Intermediate',
        points INT DEFAULT 20,
        is_active BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created table: challenges';
END
ELSE
    PRINT 'Table challenges already exists';
GO

-- ============================================================
-- TABLE: challenge_submissions (Leaderboard data)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='challenge_submissions' AND xtype='U')
BEGIN
    CREATE TABLE challenge_submissions (
        submission_id INT IDENTITY(1,1) PRIMARY KEY,
        candidate_name NVARCHAR(100) NOT NULL,
        candidate_id NVARCHAR(50) NOT NULL,
        score INT DEFAULT 0,
        total_questions INT DEFAULT 5,
        accuracy DECIMAL(5,2) DEFAULT 0.00,
        submitted_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created table: challenge_submissions';
END
ELSE
    PRINT 'Table challenge_submissions already exists';
GO

-- Check if submitted_at column exists, add if missing (fixes legacy issue)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'challenge_submissions' AND COLUMN_NAME = 'submitted_at'
)
BEGIN
    ALTER TABLE challenge_submissions ADD submitted_at DATETIME DEFAULT GETDATE();
    PRINT 'Added submitted_at column to challenge_submissions';
END
GO

-- ============================================================
-- TABLE: tournaments
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tournaments' AND xtype='U')
BEGIN
    CREATE TABLE tournaments (
        tournament_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(200) NOT NULL,
        description NVARCHAR(MAX),
        start_date DATE,
        end_date DATE,
        format NVARCHAR(50) DEFAULT 'Rapid',
        status NVARCHAR(20) DEFAULT 'upcoming',
        max_participants INT DEFAULT 32,
        rules NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created table: tournaments';
END
ELSE
    PRINT 'Table tournaments already exists';
GO

-- ============================================================
-- TABLE: tournament_registrations
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tournament_registrations' AND xtype='U')
BEGIN
    CREATE TABLE tournament_registrations (
        reg_id INT IDENTITY(1,1) PRIMARY KEY,
        tournament_id INT NOT NULL,
        user_id INT,
        participant_name NVARCHAR(100),
        registered_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_treg_tournament FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id)
    );
    PRINT 'Created table: tournament_registrations';
END
ELSE
    PRINT 'Table tournament_registrations already exists';
GO

-- ============================================================
-- TABLE: learning_resources
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='learning_resources' AND xtype='U')
BEGIN
    CREATE TABLE learning_resources (
        resource_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(200) NOT NULL,
        description NVARCHAR(MAX),
        resource_type NVARCHAR(20) DEFAULT 'article',
        file_path NVARCHAR(255),
        video_url NVARCHAR(500),
        category NVARCHAR(100),
        is_published BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created table: learning_resources';
END
ELSE
    PRINT 'Table learning_resources already exists';
GO

-- ============================================================
-- TABLE: contact_messages
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='contact_messages' AND xtype='U')
BEGIN
    CREATE TABLE contact_messages (
        message_id INT IDENTITY(1,1) PRIMARY KEY,
        sender_name NVARCHAR(100) NOT NULL,
        sender_email NVARCHAR(100) NOT NULL,
        subject NVARCHAR(200),
        message NVARCHAR(MAX) NOT NULL,
        received_at DATETIME DEFAULT GETDATE(),
        is_read BIT DEFAULT 0
    );
    PRINT 'Created table: contact_messages';
END
ELSE
    PRINT 'Table contact_messages already exists';
GO

-- ============================================================
-- INSERT DEFAULT ADMIN USER
-- Password: admin123 (SHA-256 hashed)
-- SHA-256 of "admin123" = 240be518fabd2724ddb6f04eeb1da5967448d7e831186422d11efaf1673c6006
-- ============================================================
IF NOT EXISTS (SELECT * FROM users WHERE username = 'admin')
BEGIN
    INSERT INTO users (full_name, username, email, phone, password_hash, experience_level, is_admin)
    VALUES (
        'Academy Administrator',
        'admin',
        'admin@lastpawnacademy.com',
        '+91 98765 43210',
        '240be518fabd2724ddb6f04eeb1da5967448d7e831186422d11efaf1673c6006',
        'Expert',
        1
    );
    PRINT 'Created default admin user. Login: admin / admin123';
END
GO

-- ============================================================
-- INSERT SAMPLE COURSES
-- ============================================================
IF NOT EXISTS (SELECT * FROM courses WHERE title = 'Chess Fundamentals')
BEGIN
    INSERT INTO courses (title, description, difficulty, lessons_count, is_published) VALUES
    ('Chess Fundamentals', 'Learn the basic rules, piece movements, and foundational strategies. Perfect for complete beginners.', 'Beginner', 12, 1),
    ('Pawn Structure & Strategy', 'Understand how pawn structure shapes the game and how to use pawns effectively.', 'Beginner', 10, 1),
    ('Chess Tactics Mastery', 'Study essential tactical patterns: forks, pins, skewers, discovered attacks, and combinations.', 'Intermediate', 18, 1),
    ('Chess Openings Mastered', 'Learn key opening principles and study popular openings including e4, d4, and Sicilian Defense.', 'Intermediate', 15, 1),
    ('Endgame Techniques', 'Master king and pawn endgames, rook endgames, and fundamental endgame principles.', 'Intermediate', 14, 1),
    ('Advanced Chess Strategy', 'Deep dive into positional play, piece coordination, and long-term strategic planning.', 'Advanced', 20, 1),
    ('Tournament Preparation', 'Learn time management, opening repertoire building, game analysis, and mental preparation.', 'Advanced', 24, 1);
    PRINT 'Inserted sample courses';
END
GO

-- ============================================================
-- INSERT SAMPLE CHALLENGES
-- ============================================================
IF NOT EXISTS (SELECT * FROM challenges WHERE title = 'Chess Piece Movement')
BEGIN
    INSERT INTO challenges (title, question, option_a, option_b, option_c, option_d, correct_option, explanation, difficulty, points) VALUES
    ('Chess Piece Movement', 
     'Which chess piece can jump over other pieces?',
     'Rook', 'Knight', 'Bishop', 'Queen',
     'B',
     'The Knight is the only chess piece that can jump over other pieces. It moves in an L-shape: two squares in one direction and one square perpendicular.',
     'Beginner', 20),

    ('Rook Movement',
     'How many squares can a rook move at most in a single turn on an empty board?',
     '6', '7', '14', 'Unlimited',
     'C',
     'A rook can move along any rank or file. On an empty board, it can move up to 7 squares in any direction, giving a maximum of 14 squares total coverage.',
     'Beginner', 20),

    ('Special Pawn Move',
     'What special capture allows a pawn to take a pawn that has just moved two squares forward?',
     'Castling', 'Promotion', 'En Passant', 'Fork',
     'C',
     'En Passant is a special pawn capture. If an opponent pawn moves two squares forward from its starting position, your pawn can capture it as if it had only moved one square.',
     'Intermediate', 20),

    ('Opening Principles',
     'Which of the following is a GOOD chess opening principle?',
     'Move the same piece twice early', 'Control the center', 'Move only pawns in the opening', 'Develop the queen immediately',
     'B',
     'Controlling the center (e4, d4, e5, d5 squares) is a fundamental opening principle. Central pieces are more active and control more of the board.',
     'Beginner', 20),

    ('Chess Tactics - Fork',
     'What is a FORK in chess?',
     'A pawn promotion move', 'A draw offer', 'An attack on two pieces simultaneously', 'A defensive maneuver',
     'C',
     'A fork is a tactical move where one piece attacks two or more opponent pieces at the same time. The knight is especially good at creating forks.',
     'Intermediate', 20);
    PRINT 'Inserted sample challenges';
END
GO

-- ============================================================
-- INSERT SAMPLE TOURNAMENTS
-- ============================================================
IF NOT EXISTS (SELECT * FROM tournaments WHERE title = 'Academy Rapid Championship 2026')
BEGIN
    INSERT INTO tournaments (title, description, start_date, end_date, format, status, max_participants) VALUES
    ('Academy Rapid Championship 2026', 
     'Annual rapid chess championship open to all academy members. Time control: 15 minutes + 10 seconds increment.',
     '2026-11-15', '2026-11-15', 'Rapid (15+10)', 'upcoming', 32),
    ('Monthly Blitz Battle - November',
     'Monthly blitz tournament series. Fast-paced and exciting. Time control: 5 minutes + 0 increment.',
     '2026-11-05', '2026-11-05', 'Blitz (5+0)', 'ongoing', 24),
    ('Juniors Chess Championship 2026',
     'Open to players under 18 years. Classical time control. Prizes and certificates for top finishers.',
     '2026-11-20', '2026-11-21', 'Classical (60+30)', 'upcoming', 40),
    ('Academy Open - October',
     'Completed open tournament. Round robin format. Congratulations to all participants!',
     '2026-10-10', '2026-10-10', 'Rapid (10+0)', 'completed', 20);
    PRINT 'Inserted sample tournaments';
END
GO

-- ============================================================
-- VERIFY TABLES
-- ============================================================
SELECT TABLE_NAME, TABLE_TYPE 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_CATALOG = 'CSE9937'
ORDER BY TABLE_NAME;
GO

PRINT '==============================================';
PRINT 'Database setup complete for The Last Pawn Chess Academy!';
PRINT 'Default admin login: username=admin, password=admin123';
PRINT '==============================================';
