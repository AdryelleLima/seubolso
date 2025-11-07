package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

import dao.UsuarioDAO;
// ⚠️ MUDANÇA: jakarta em vez de javax
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Usuario;

@WebServlet("/usuarios")
public class UsuarioServlet extends HttpServlet {
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/seubolso_db", "root", "senha"
            );
            usuarioDAO = new UsuarioDAO(connection);
        } catch (ClassNotFoundException | SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            try {
                usuarioDAO.deletar(id);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.sendRedirect("usuarios");
            return;
        }

        try {
            List<Usuario> lista = usuarioDAO.listarTodos();
            request.setAttribute("usuarios", lista);
            request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String idStr = request.getParameter("id");

        Usuario usuario = new Usuario();
        usuario.setNome(nome);
        usuario.setEmail(email);
        usuario.setSenha(senha);

        try {
            if (idStr == null || idStr.isEmpty()) {
                usuarioDAO.salvar(usuario);
            } else {
                usuario.setId(Long.parseLong(idStr));
                usuarioDAO.atualizar(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("usuarios");
    }
}