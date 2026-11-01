# ♟ The Last Pawn — Chess Academy

> **"Think Better. Play Smarter."**

A modern, full-stack chess academy and tournament training platform built with **Java JSP/Servlets**, **Microsoft SQL Server**, and modern responsive web technologies.

---

## 🌟 Overview

**The Last Pawn Chess Academy** is a comprehensive chess learning and competitive platform featuring:
* **Interactive Crystal Chess Library**: Deep-dive dynamic movement rules, values, and tactical motifs for all six chess elements (Pawn, Rook, Knight, Bishop, Queen, King).
* **Grandmaster Course Catalog**: Beginner to Master curriculum with interactive enrollment.
* **Chess Challenge Arena**: Tactical puzzle quizzes and real-time candidate leaderboards.
* **Live Tournaments Portal**: Swiss and Round-Robin events with upcoming tournament schedules.
* **Play & Analytics Dashboard**: Chess.com player profile lookup, live blitz/rapid ratings, and tactical insights.
* **Full Administrative Suite**: Secure admin dashboard for managing puzzles, courses, video lectures, tournaments, candidate submissions, and contact messages.

---

## 🛠 Tech Stack

* **Frontend**: HTML5, CSS3, Modern JavaScript (ES6+), KaTeX, Responsive Grid & Flexbox
* **Backend**: Java 11 / Java 25, Java Servlets (JSP/Servlet architecture)
* **Application Server**: Apache Tomcat 9.0
* **Database**: Microsoft SQL Server (SQL Server Management Studio 20)
* **Connectivity**: Microsoft JDBC Driver for SQL Server (`mssql-jdbc`)
* **Branding**: Official golden chess pawn and metallic crest motif

---

## 📁 Project Structure

```text
Chess Academy/
├── src/                                  # Java source files
│   ├── com/lastpawn/db/                  # Database connectivity (DBConnection.java)
│   ├── com/lastpawn/servlet/             # Authentication & public servlets
│   └── com/lastpawn/servlet/admin/       # Admin management servlets
├── WebContent/                           # Web application root
│   ├── admin/                            # Admin dashboard & management JSPs
│   ├── css/                              # Stylesheets (style.css)
│   ├── js/                               # Client scripts (main.js)
│   ├── images/                           # Official logo, backgrounds, and piece assets
│   ├── uploads/                          # Material downloads, puzzles, video assets
│   ├── WEB-INF/                          # Configuration and libraries
│   │   ├── lib/                          # JDBC Driver (mssql-jdbc)
│   │   └── web.xml                       # Servlet mappings & deployment descriptor
│   └── *.jsp                             # Public presentation pages
├── database-setup.sql                    # Complete SQL Server schema & sample data
├── db.properties.example                 # Template for database configuration
└── .gitignore                            # Git exclusion rules
```

---

## 🚀 Getting Started

### 1. Database Configuration
1. Open **Microsoft SQL Server Management Studio (SSMS)**.
2. Execute the `database-setup.sql` script to create database `CSE9937` and all required tables.
3. Copy `db.properties.example` to `src/db.properties` (or set environment variables):
   ```properties
   db.host=localhost
   db.port=1433
   db.name=CSE9937
   db.user=sa
   db.password=YourStrongPassword
   ```

### 2. Build & Deploy on Apache Tomcat 9
1. Compile Java source files into `WebContent/WEB-INF/classes`.
2. Deploy the `WebContent` directory or package into `TheLastPawn.war` in `$CATALINA_HOME/webapps`.
3. Start Apache Tomcat:
   ```powershell
   catalina.bat run
   ```
4. Access the web application at:
   ```text
   http://localhost:8080/TheLastPawn/
   ```

---

## 🛡 Security & Privacy
* Database passwords and server IPs are excluded from version control via `db.properties` in `.gitignore`.
* Passwords are encrypted using SHA-256 hashing.
* Admin sections are protected by role-based session authentication guards.

---

## 📄 License
© 2026 The Last Pawn Chess Academy. All rights reserved.
