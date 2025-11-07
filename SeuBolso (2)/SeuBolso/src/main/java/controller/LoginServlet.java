package controller;

import dao.UsuarioDAO;
import models.Usuario;
import util.JDBCUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redireciona para a página de login
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if (email == null || email.isEmpty() || senha == null || senha.isEmpty()) {
            request.setAttribute("erro", "Preencha todos os campos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // ✅ Criar conexão apenas quando necessário (não no init)
        Connection connection = null;
        try {
            connection = JDBCUtil.getConnection();
            UsuarioDAO usuarioDAO = new UsuarioDAO(connection);
            
            Usuario usuario = usuarioDAO.buscarPorEmail(email);
            
            if (usuario != null && usuario.getSenha().equals(senha)) {
                // ✅ Cria a sessão e armazena o usuário logado
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                
                // Redireciona para a página principal
                response.sendRedirect("Home.jsp");
            } else {
                request.setAttribute("erro", "Email ou senha inválidos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Erro ao tentar logar o usuário", e);
        } finally {
            // ✅ IMPORTANTE: Fechar a conexão no finally
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}