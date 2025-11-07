package controller;

import dao.ListaDesejosDAO;
import models.ListaDesejos;
import models.Usuario;
import util.JDBCUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

@WebServlet("/ListaDesejosServlet")
@MultipartConfig(maxFileSize = 5242880) // 5MB
public class ListaDesejosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== DEBUG: doGet chamado ===");
        
        // ✅ Verificar sessão
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            System.out.println("⚠️ Sessão inválida - redirecionando para login");
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        System.out.println("✅ Usuário logado: " + usuario.getNome() + " (ID: " + usuario.getId() + ")");

        Connection connection = null;
        try {
            connection = JDBCUtil.getConnection();
            ListaDesejosDAO listaDesejosDAO = new ListaDesejosDAO(connection);

            List<ListaDesejos> lista = listaDesejosDAO.listarPorUsuario(usuario.getId());
            request.setAttribute("listaDesejos", lista);

            request.getRequestDispatcher("lista-desejos.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erro ao listar itens da lista de desejos", e);
        } finally {
            if (connection != null) {
                try { connection.close(); } catch (SQLException ignored) {}
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        System.out.println("=== DEBUG: doPost chamado ===");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        String acao = request.getParameter("acao");

        Connection connection = null;
        try {
            connection = JDBCUtil.getConnection();
            ListaDesejosDAO listaDesejosDAO = new ListaDesejosDAO(connection);

            if ("editar".equals(acao)) {
                Long id = Long.parseLong(request.getParameter("id"));
                String descricao = request.getParameter("descricao");
                BigDecimal valorObjetivo = new BigDecimal(request.getParameter("valorObjetivo"));
                String link = request.getParameter("link");
                String valorAtualParam = request.getParameter("valorAtual");
                BigDecimal valorAtual = (valorAtualParam != null && !valorAtualParam.isEmpty())
                        ? new BigDecimal(valorAtualParam)
                        : BigDecimal.ZERO;

                ListaDesejos item = listaDesejosDAO.buscarPorId(id);
                if (item != null && item.getUsuarioId() == usuario.getId()) {
                    item.setDescricao(descricao);
                    item.setValorObjetivo(valorObjetivo);
                    item.setValorAtual(valorAtual);
                    item.setLink(link != null && !link.trim().isEmpty() ? link : null);

                    // 📷 Atualizar imagem, se houver upload
                    Part imagemPart = request.getPart("imagem");
                    if (imagemPart != null && imagemPart.getSize() > 0) {
                        String imagemBase64 = convertToBase64(imagemPart);
                        item.setImagemBase64(imagemBase64);
                    }

                    listaDesejosDAO.atualizar(item);
                    System.out.println("✅ Item editado com sucesso");
                }

            } else if ("excluir".equals(acao)) {
                Long id = Long.parseLong(request.getParameter("id"));
                ListaDesejos item = listaDesejosDAO.buscarPorId(id);
                if (item != null && item.getUsuarioId() == usuario.getId()) {
                    listaDesejosDAO.deletar(id);
                    System.out.println("✅ Item excluído com sucesso");
                }

            } else if ("adicionar".equals(acao)) {
                String descricao = request.getParameter("descricao");
                BigDecimal valorObjetivo = new BigDecimal(request.getParameter("valorObjetivo"));
                String link = request.getParameter("link");
                String valorAtualParam = request.getParameter("valorAtual");
                BigDecimal valorAtual = (valorAtualParam != null && !valorAtualParam.isEmpty())
                        ? new BigDecimal(valorAtualParam)
                        : BigDecimal.ZERO;

                ListaDesejos item = new ListaDesejos();
                item.setDescricao(descricao);
                item.setValorObjetivo(valorObjetivo);
                item.setValorAtual(valorAtual);
                item.setLink(link != null && !link.trim().isEmpty() ? link : null);
                item.setUsuarioId(usuario.getId());

                // 📷 Processar imagem
                Part imagemPart = request.getPart("imagem");
                if (imagemPart != null && imagemPart.getSize() > 0) {
                    String imagemBase64 = convertToBase64(imagemPart);
                    item.setImagemBase64(imagemBase64);
                }

                listaDesejosDAO.salvar(item);
                System.out.println("✅ Item adicionado com sucesso");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erro ao processar ação da lista de desejos", e);
        } finally {
            if (connection != null) {
                try { connection.close(); } catch (SQLException ignored) {}
            }
        }

        response.sendRedirect("ListaDesejosServlet");
    }

    private String convertToBase64(Part part) throws IOException {
        try (InputStream inputStream = part.getInputStream()) {
            byte[] bytes = inputStream.readAllBytes();
            String mimeType = part.getContentType();
            String base64 = Base64.getEncoder().encodeToString(bytes);
            return "data:" + mimeType + ";base64," + base64;
        }
    }
}
