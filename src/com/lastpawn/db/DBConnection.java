package com.lastpawn.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Provides JDBC connections to the Microsoft SQL Server database for The Last Pawn Chess Academy.
 * Supports db.properties, environment variables, or system property overrides.
 */
public class DBConnection {

    private static final Properties props = new Properties();

    static {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (Exception ignored) {}
    }

    private static String getEnvOrProp(String envName, String propName, String defaultValue) {
        // 1. Environment variable
        String val = System.getenv(envName);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        // 2. System property
        val = System.getProperty(propName);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        // 3. Properties file
        val = props.getProperty(propName);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        return defaultValue;
    }

    public static String getHost() {
        return getEnvOrProp("DB_HOST", "db.host", "localhost");
    }

    public static String getPort() {
        return getEnvOrProp("DB_PORT", "db.port", "1433");
    }

    public static String getDatabaseName() {
        return getEnvOrProp("DB_NAME", "db.name", "CSE9937");
    }

    public static String getUser() {
        return getEnvOrProp("DB_USER", "db.user", "sa");
    }

    public static String getPassword() {
        return getEnvOrProp("DB_PASSWORD", "db.password", "");
    }

    public static String getJdbcUrl() {
        return String.format(
            "jdbc:sqlserver://%s:%s;databaseName=%s;encrypt=false;trustServerCertificate=true;loginTimeout=8",
            getHost(), getPort(), getDatabaseName()
        );
    }

    /**
     * Returns a new JDBC Connection. Caller is responsible for closing it.
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(getJdbcUrl(), getUser(), getPassword());
    }

    /**
     * Quick test of connection health.
     */
    public static boolean testConnection() {
        try (Connection con = getConnection()) {
            return con != null && !con.isClosed();
        } catch (Exception e) {
            System.err.println("[DBConnection] Connection failed: " + e.getMessage());
            return false;
        }
    }
}
