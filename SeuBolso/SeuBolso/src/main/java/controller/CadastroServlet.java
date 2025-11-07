package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.JDBCUtil;

@WebServlet("/CadastroServlet")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if (nome == null || email == null || senha == null ||
            nome.isEmpty() || email.isEmpty() || senha.isEmpty()) {
            response.sendRedirect("cadastro.jsp?erro=CamposObrigatorios");
            return;
        }

        try (Connection conn = JDBCUtil.getConnection()) {

            String sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, nome);
                stmt.setString(2, email);
                stmt.setString(3, senha); // ⚠️ Recomendo criptografar depois (ex: BCrypt)

                int linhas = stmt.executeUpdate();

                if (linhas > 0) {
                    response.sendRedirect("login.jsp?sucesso=1");
                } else {
                    response.sendRedirect("cadastro.jsp?erro=FalhaCadastro");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cadastro.jsp?erro=ErroServidor");
        }
    }
}
