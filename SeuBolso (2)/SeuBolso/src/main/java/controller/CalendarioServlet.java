package controller;

import dao.LancamentoDAO;
import models.Lancamento;
import models.Usuario;
import util.JDBCUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/calendario")
public class CalendarioServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        try (Connection connection = JDBCUtil.getConnection()) {
            LancamentoDAO lancamentoDAO = new LancamentoDAO(connection);
            List<Lancamento> lancamentos = lancamentoDAO.listarPorUsuario(usuario);
            request.setAttribute("lancamentos", lancamentos);
            request.getRequestDispatcher("calendario.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}