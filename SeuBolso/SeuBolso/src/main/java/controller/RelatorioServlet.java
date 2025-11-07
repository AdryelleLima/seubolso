package controller;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

import dao.LancamentoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Lancamento;
import models.Usuario;
import util.JDBCUtil;

@WebServlet("/RelatorioServlet")
public class RelatorioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class,
                    (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> new JsonPrimitive(src.toString()))
            .registerTypeAdapter(LocalDate.class,
                    (JsonDeserializer<LocalDate>) (json, typeOfT, context) -> LocalDate.parse(json.getAsString()))
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String ajax = request.getParameter("ajax");

        try (Connection conn = JDBCUtil.getConnection()) {
            LancamentoDAO dao = new LancamentoDAO(conn);
            
            List<Lancamento> lancamentos = dao.listarPorUsuario(usuarioLogado);
            
            String dataInicioStr = request.getParameter("dataInicio");
            String dataFimStr = request.getParameter("dataFim");
            String categoria = request.getParameter("categoria");
            String tipo = request.getParameter("tipo");
            
            if (dataInicioStr != null && !dataInicioStr.isEmpty() && 
                dataFimStr != null && !dataFimStr.isEmpty()) {
                
                LocalDate dataInicio = LocalDate.parse(dataInicioStr);
                LocalDate dataFim = LocalDate.parse(dataFimStr);
                
                lancamentos = lancamentos.stream()
                    .filter(l -> {
                        LocalDate dataLanc = l.getData();
                        return !dataLanc.isBefore(dataInicio) && !dataLanc.isAfter(dataFim);
                    })
                    .collect(Collectors.toList());
            }
            
            if (categoria != null && !categoria.isEmpty()) {
                lancamentos = lancamentos.stream()
                    .filter(l -> categoria.equalsIgnoreCase(l.getCategoria()))
                    .collect(Collectors.toList());
            }
            
            if (tipo != null && !tipo.isEmpty()) {
                lancamentos = lancamentos.stream()
                    .filter(l -> tipo.equalsIgnoreCase(l.getTipo()))
                    .collect(Collectors.toList());
            }
            
            double totalReceitas = 0;
            double totalDespesas = 0;
            
            for (Lancamento l : lancamentos) {
                if ("receita".equalsIgnoreCase(l.getTipo())) {
                    totalReceitas += l.getValor();
                } else if ("despesa".equalsIgnoreCase(l.getTipo())) {
                    totalDespesas += l.getValor();
                }
            }
            
            double saldo = totalReceitas - totalDespesas;
            
            if ("true".equals(ajax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                Map<String, Object> resultado = new HashMap<>();
                resultado.put("totalReceitas", totalReceitas);
                resultado.put("totalDespesas", totalDespesas);
                resultado.put("saldo", saldo);
                resultado.put("lancamentos", lancamentos);
                
                String jsonResponse = gson.toJson(resultado);
                response.getWriter().write(jsonResponse);
            } else {
                request.setAttribute("lancamentos", lancamentos);
                request.getRequestDispatcher("relatorio.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            if ("true".equals(ajax)) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"erro\":\"Erro ao processar relatório: " + e.getMessage() + "\"}");
            } else {
                throw new ServletException("Erro ao processar relatório", e);
            }
        }
    }
}
