package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dao.LancamentoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Lancamento;
import models.Usuario;
import util.JDBCUtil;

@WebServlet("/NotificacaoServlet")
public class NotificacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configuração de response com UTF-8
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();
        JsonArray notificacoesArray = new JsonArray();
        
        try {
            HttpSession session = request.getSession(false);
            
            // Se não há sessão ou usuário não está logado
            if (session == null || session.getAttribute("usuarioLogado") == null) {
                System.out.println("NotificacaoServlet: Usuário não logado");
                json.add("notificacoes", notificacoesArray);
                out.print(json.toString());
                out.flush();
                return;
            }
            
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
            System.out.println("NotificacaoServlet: Buscando notificações para usuário: " + usuario.getId());
            
            try (Connection con = JDBCUtil.getConnection()) {
                LancamentoDAO dao = new LancamentoDAO(con);
                List<Lancamento> lancamentos = dao.listarPorUsuario(usuario);
                
                System.out.println("NotificacaoServlet: Encontrados " + lancamentos.size() + " lançamentos");
                
                LocalDate hoje = LocalDate.now();
                LocalDate limiteNotificacao = hoje.plusDays(7);
                
                int notifCount = 0;
                
                for (Lancamento lanc : lancamentos) {
                    // Verificar apenas despesas com vencimento
                    if ("despesa".equalsIgnoreCase(lanc.getTipo()) && lanc.getVencimento() != null) {
                        LocalDate vencimento = lanc.getVencimento();
                        long diasRestantes = ChronoUnit.DAYS.between(hoje, vencimento);
                        
                        // Só notifica se for dentro do período de 7 dias ou atrasado
                        if (diasRestantes <= 7) {
                            JsonObject notif = new JsonObject();
                            
                            // Gera ID único para a notificação
                            String notifId = "lanc_" + lanc.getId() + "_" + vencimento.toString();
                            notif.addProperty("id", notifId);
                            notif.addProperty("lancamentoId", lanc.getId());
                            
                            // Vencimento atrasado
                            if (vencimento.isBefore(hoje)) {
                                long diasAtrasados = ChronoUnit.DAYS.between(vencimento, hoje);
                                
                                notif.addProperty("tipo", "atrasado");
                                notif.addProperty("icone", "🚨");
                                notif.addProperty("titulo", "Atrasado!");
                                notif.addProperty("mensagem", lanc.getTitulo() + " está " + diasAtrasados + 
                                    " dia(s) atrasado" + (diasAtrasados > 1 ? "s" : ""));
                                notif.addProperty("valor", String.format("R$ %.2f", lanc.getValor()));
                                notif.addProperty("prioridade", 1);
                                
                                notificacoesArray.add(notif);
                                notifCount++;
                            }
                            // Vence hoje
                            else if (diasRestantes == 0) {
                                notif.addProperty("tipo", "hoje");
                                notif.addProperty("icone", "⚠️");
                                notif.addProperty("titulo", "Vence Hoje!");
                                notif.addProperty("mensagem", lanc.getTitulo());
                                notif.addProperty("valor", String.format("R$ %.2f", lanc.getValor()));
                                notif.addProperty("prioridade", 2);
                                
                                notificacoesArray.add(notif);
                                notifCount++;
                            }
                            // Vence amanhã
                            else if (diasRestantes == 1) {
                                notif.addProperty("tipo", "amanha");
                                notif.addProperty("icone", "📅");
                                notif.addProperty("titulo", "Vence Amanhã");
                                notif.addProperty("mensagem", lanc.getTitulo());
                                notif.addProperty("valor", String.format("R$ %.2f", lanc.getValor()));
                                notif.addProperty("prioridade", 3);
                                
                                notificacoesArray.add(notif);
                                notifCount++;
                            }
                            // Vence nos próximos 7 dias
                            else if (diasRestantes > 1 && diasRestantes <= 7) {
                                notif.addProperty("tipo", "proximo");
                                notif.addProperty("icone", "📆");
                                notif.addProperty("titulo", "Vence em " + diasRestantes + " dias");
                                notif.addProperty("mensagem", lanc.getTitulo());
                                notif.addProperty("valor", String.format("R$ %.2f", lanc.getValor()));
                                notif.addProperty("prioridade", 4);
                                
                                notificacoesArray.add(notif);
                                notifCount++;
                            }
                        }
                    }
                }
                
                System.out.println("NotificacaoServlet: Geradas " + notifCount + " notificações");
                
            } catch (Exception e) {
                System.err.println("NotificacaoServlet: Erro ao buscar lançamentos");
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                json.addProperty("erro", "Erro ao buscar notificações");
            }
            
            json.add("notificacoes", notificacoesArray);
            String jsonString = json.toString();
            System.out.println("NotificacaoServlet: Retornando JSON: " + jsonString);
            
            out.print(jsonString);
            out.flush();
            
        } catch (Exception e) {
            System.err.println("NotificacaoServlet: Erro geral");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            json.addProperty("erro", "Erro interno do servidor");
            json.add("notificacoes", notificacoesArray);
            out.print(json.toString());
            out.flush();
        }
    }
}