package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class JDBCUtil {
    
    // URL com allowPublicKeyRetrieval=true adicionado
    private static final String URL = "jdbc:mysql://localhost:3306/seubolso_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "root";
    
    // Carrega o driver uma única vez quando a classe é carregada
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver JDBC do MySQL não encontrado!", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}