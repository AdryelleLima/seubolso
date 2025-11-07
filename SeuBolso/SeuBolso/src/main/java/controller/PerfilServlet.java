package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.LancamentoDAO;
import dao.ListaDesejosDAO;
import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.ListaDesejos;
import models.Usuario;
import util.JDBCUtil;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Gson gson = new Gson();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

		if (usuario == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		Connection connection = null;
		try {
			connection = JDBCUtil.getConnection();

			// Criar os DAOs com a conexão
			UsuarioDAO usuarioDAO = new UsuarioDAO(connection);
			LancamentoDAO lancamentoDAO = new LancamentoDAO(connection);
			ListaDesejosDAO listaDesejosDAO = new ListaDesejosDAO(connection);

			// Buscar dados atualizados do usuário
			usuario = usuarioDAO.buscarPorId(usuario.getId());
			session.setAttribute("usuarioLogado", usuario);

			// Calcular totais GERAIS (para o gráfico geral se necessário)
			Double totalReceitas = lancamentoDAO.calcularTotalReceitas(usuario.getId());
			Double totalDespesas = lancamentoDAO.calcularTotalDespesas(usuario.getId());

			// Calcular totais do MÊS ATUAL
			Double totalReceitasMesAtual = lancamentoDAO.calcularTotalReceitasMesAtual(usuario.getId());
			Double totalDespesasMesAtual = lancamentoDAO.calcularTotalDespesasMesAtual(usuario.getId());

			request.setAttribute("usuario", usuario);
			request.setAttribute("totalReceitas", totalReceitas != null ? totalReceitas : 0.0);
			request.setAttribute("totalDespesas", totalDespesas != null ? totalDespesas : 0.0);
			request.setAttribute("totalReceitasMesAtual", totalReceitasMesAtual != null ? totalReceitasMesAtual : 0.0);
			request.setAttribute("totalDespesasMesAtual", totalDespesasMesAtual != null ? totalDespesasMesAtual : 0.0);

			// Buscar os 2 desejos mais próximos de serem realizados
			List<ListaDesejos> topDesejos = listaDesejosDAO.buscarTopDesejosPorProgresso(usuario.getId(), 2);
			request.setAttribute("topDesejos", topDesejos);

			request.getRequestDispatcher("perfil.jsp").forward(request, response);

		} catch (SQLException e) {
			e.printStackTrace();
			response.sendRedirect("erro.jsp");
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession();
		Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

		if (usuario == null) {
			enviarResposta(response, false, "Usuário não autenticado");
			return;
		}

		String acao = request.getParameter("acao");

		Connection connection = null;
		try {
			connection = JDBCUtil.getConnection();

			switch (acao) {
			case "atualizarFoto":
				atualizarFotoPerfil(request, response, usuario, connection);
				break;
			case "atualizarNome":
				atualizarNome(request, response, usuario, connection);
				break;
			case "atualizarObjetivo":
				atualizarObjetivo(request, response, usuario, connection);
				break;
			case "atualizarGuardado":
				atualizarGuardado(request, response, usuario, connection);
				break;
			default:
				enviarResposta(response, false, "Ação inválida");
			}
		} catch (Exception e) {
			e.printStackTrace();
			enviarResposta(response, false, "Erro ao processar requisição: " + e.getMessage());
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private void atualizarFotoPerfil(HttpServletRequest request, HttpServletResponse response, Usuario usuario,
			Connection connection) throws IOException, SQLException {
		String fotoPerfil = request.getParameter("fotoPerfil");

		if (fotoPerfil == null || fotoPerfil.trim().isEmpty()) {
			enviarResposta(response, false, "Imagem inválida");
			return;
		}

		try {
			UsuarioDAO usuarioDAO = new UsuarioDAO(connection);
			usuarioDAO.atualizarFotoPerfil(usuario.getId(), fotoPerfil);
			usuario.setFotoPerfil(fotoPerfil);
			request.getSession().setAttribute("usuarioLogado", usuario);
			enviarResposta(response, true, "Foto atualizada com sucesso");
		} catch (Exception e) {
			e.printStackTrace();
			enviarResposta(response, false, "Erro ao atualizar foto: " + e.getMessage());
		}
	}

	private void atualizarNome(HttpServletRequest request, HttpServletResponse response, Usuario usuario,
			Connection connection) throws IOException, SQLException {
		String novoNome = request.getParameter("nome");

		if (novoNome == null || novoNome.trim().isEmpty()) {
			enviarResposta(response, false, "Nome inválido");
			return;
		}

		try {
			UsuarioDAO usuarioDAO = new UsuarioDAO(connection);
			usuarioDAO.atualizarNome(usuario.getId(), novoNome);
			usuario.setNome(novoNome);
			request.getSession().setAttribute("usuarioLogado", usuario);
			enviarResposta(response, true, "Nome atualizado com sucesso");
		} catch (Exception e) {
			e.printStackTrace();
			enviarResposta(response, false, "Erro ao atualizar nome: " + e.getMessage());
		}
	}

	private void atualizarObjetivo(HttpServletRequest request, HttpServletResponse response, Usuario usuario,
			Connection connection) throws IOException, SQLException {
		String objetivoStr = request.getParameter("objetivoFinanceiro");

		try {
			Double objetivoFinanceiro = Double.parseDouble(objetivoStr);
			if (objetivoFinanceiro < 0) {
				enviarResposta(response, false, "Valor inválido");
				return;
			}

			UsuarioDAO usuarioDAO = new UsuarioDAO(connection);
			usuarioDAO.atualizarObjetivoFinanceiro(usuario.getId(), objetivoFinanceiro);
			usuario.setObjetivoFinanceiro(objetivoFinanceiro);
			request.getSession().setAttribute("usuarioLogado", usuario);
			enviarResposta(response, true, "Objetivo atualizado com sucesso");
		} catch (NumberFormatException e) {
			enviarResposta(response, false, "Valor inválido");
		} catch (Exception e) {
			e.printStackTrace();
			enviarResposta(response, false, "Erro ao atualizar objetivo: " + e.getMessage());
		}
	}

	private void atualizarGuardado(HttpServletRequest request, HttpServletResponse response, Usuario usuario,
			Connection connection) throws IOException, SQLException {
		String guardadoStr = request.getParameter("valorGuardado");

		try {
			Double valorGuardado = Double.parseDouble(guardadoStr);
			if (valorGuardado < 0) {
				enviarResposta(response, false, "Valor inválido");
				return;
			}

			UsuarioDAO usuarioDAO = new UsuarioDAO(connection);
			usuarioDAO.atualizarValorGuardado(usuario.getId(), valorGuardado);
			usuario.setValorGuardado(valorGuardado);
			request.getSession().setAttribute("usuarioLogado", usuario);
			enviarResposta(response, true, "Valor guardado atualizado com sucesso");
		} catch (NumberFormatException e) {
			enviarResposta(response, false, "Valor inválido");
		} catch (Exception e) {
			e.printStackTrace();
			enviarResposta(response, false, "Erro ao atualizar valor guardado: " + e.getMessage());
		}
	}

	private void enviarResposta(HttpServletResponse response, boolean success, String message) throws IOException {
		JsonObject json = new JsonObject();
		json.addProperty("success", success);
		json.addProperty("message", message);

		PrintWriter out = response.getWriter();
		out.print(gson.toJson(json));
		out.flush();
	}
}