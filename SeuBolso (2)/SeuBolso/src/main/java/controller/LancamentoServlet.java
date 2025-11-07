package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

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

@WebServlet("/lancamentos")
public class LancamentoServlet extends HttpServlet {
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

		String action = request.getParameter("action");
		if (action == null)
			action = "listar";

		try (Connection conn = JDBCUtil.getConnection()) {
			LancamentoDAO dao = new LancamentoDAO(conn);

			switch (action) {
			case "buscar":
				buscarLancamento(request, response, dao);
				break;
			case "listar":
				listarLancamentos(response, dao);
				break;
			default:
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro no servidor: " + e.getMessage() + "\"}");
		}
	}

	private void buscarLancamento(HttpServletRequest request, HttpServletResponse response, LancamentoDAO dao)
			throws IOException {
		try {
			String idParam = request.getParameter("id");
			
			if (idParam == null || idParam.isEmpty() || "undefined".equals(idParam)) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write("{\"erro\":\"ID do lançamento não foi fornecido\"}");
				return;
			}
			
			long id = Long.parseLong(idParam);
			Lancamento lanc = dao.buscarPorId(id);

			if (lanc == null) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"erro\":\"Lançamento não encontrado\"}");
				return;
			}

			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(gson.toJson(lanc));

		} catch (NumberFormatException e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write("{\"erro\":\"ID inválido: " + request.getParameter("id") + "\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro ao buscar lançamento: " + e.getMessage() + "\"}");
		}
	}

	private void listarLancamentos(HttpServletResponse response, LancamentoDAO dao) throws IOException {
		try {
			List<Lancamento> lancamentos = dao.listarTodos();
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(gson.toJson(lancamentos));

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro ao listar lançamentos: " + e.getMessage() + "\"}");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try (Connection conn = JDBCUtil.getConnection()) {
			LancamentoDAO dao = new LancamentoDAO(conn);

			// Lê o corpo JSON da requisição
			StringBuilder sb = new StringBuilder();
			BufferedReader reader = request.getReader();
			String line;
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}

			String jsonBody = sb.toString();
			
			// Parse do JSON para um Map
			@SuppressWarnings("unchecked")
			Map<String, Object> jsonMap = gson.fromJson(jsonBody, Map.class);
			
			String action = (String) jsonMap.get("action");
			if (action == null) action = "salvar";

			switch (action) {
			case "salvar":
				salvarLancamento(request, response, dao, jsonMap);
				break;
			case "atualizar":
				atualizarLancamento(request, response, dao, jsonMap);
				break;
			case "deletar":
				deletarLancamento(request, response, dao, jsonMap);
				break;
			default:
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\":\"Ação inválida\"}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro no servidor: " + e.getMessage() + "\"}");
		}
	}

	private void salvarLancamento(HttpServletRequest request, HttpServletResponse response, 
			LancamentoDAO dao, Map<String, Object> jsonMap) throws IOException {
		try {
			// Pega o usuário logado
			Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
			if (usuarioLogado == null) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("{\"erro\":\"Usuário não autenticado.\"}");
				return;
			}

			Lancamento lanc = new Lancamento();
			lanc.setTitulo((String) jsonMap.get("titulo"));
			
			// Converte valor para double
			Object valorObj = jsonMap.get("valor");
			double valor = valorObj instanceof Number ? ((Number) valorObj).doubleValue() : 0.0;
			lanc.setValor(valor);
			
			lanc.setCategoria((String) jsonMap.get("categoria"));
			lanc.setTipo((String) jsonMap.get("tipo"));
			lanc.setData(LocalDate.parse((String) jsonMap.get("data")));
			lanc.setFormaPagamento((String) jsonMap.get("formaPagamento"));
			lanc.setDescricao((String) jsonMap.get("descricao"));

			String vencimento = (String) jsonMap.get("vencimento");
			if (vencimento != null && !vencimento.isEmpty()) {
				lanc.setVencimento(LocalDate.parse(vencimento));
			}

			Boolean fixa = (Boolean) jsonMap.get("despesaFixa");
			lanc.setDespesaFixa(fixa != null && fixa);

			// Seta o usuário logado
			lanc.setUsuario(usuarioLogado);

			dao.salvar(lanc);

			response.setStatus(HttpServletResponse.SC_OK);
			response.getWriter().write("{\"status\":\"sucesso\",\"mensagem\":\"Lançamento salvo com sucesso!\"}");

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro ao salvar lançamento: " + e.getMessage() + "\"}");
		}
	}

	private void atualizarLancamento(HttpServletRequest request, HttpServletResponse response, 
			LancamentoDAO dao, Map<String, Object> jsonMap) throws IOException {
		try {
			// Pega o usuário logado
			Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
			if (usuarioLogado == null) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter().write("{\"erro\":\"Usuário não autenticado.\"}");
				return;
			}

			Lancamento lanc = new Lancamento();
			
			// Converte id para long
			Object idObj = jsonMap.get("id");
			long id = idObj instanceof Number ? ((Number) idObj).longValue() : 0L;
			lanc.setId(id);
			
			lanc.setTitulo((String) jsonMap.get("titulo"));
			
			// Converte valor para double
			Object valorObj = jsonMap.get("valor");
			double valor = valorObj instanceof Number ? ((Number) valorObj).doubleValue() : 0.0;
			lanc.setValor(valor);
			
			lanc.setCategoria((String) jsonMap.get("categoria"));
			lanc.setTipo((String) jsonMap.get("tipo"));
			lanc.setData(LocalDate.parse((String) jsonMap.get("data")));
			lanc.setFormaPagamento((String) jsonMap.get("formaPagamento"));
			lanc.setDescricao((String) jsonMap.get("descricao"));

			String vencimento = (String) jsonMap.get("vencimento");
			if (vencimento != null && !vencimento.isEmpty()) {
				lanc.setVencimento(LocalDate.parse(vencimento));
			}

			Boolean fixa = (Boolean) jsonMap.get("despesaFixa");
			lanc.setDespesaFixa(fixa != null && fixa);

			// Seta o usuário logado
			lanc.setUsuario(usuarioLogado);

			dao.atualizar(lanc);

			response.setStatus(HttpServletResponse.SC_OK);
			response.getWriter().write("{\"status\":\"sucesso\",\"mensagem\":\"Lançamento atualizado com sucesso!\"}");

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro ao atualizar lançamento: " + e.getMessage() + "\"}");
		}
	}

	private void deletarLancamento(HttpServletRequest request, HttpServletResponse response, 
			LancamentoDAO dao, Map<String, Object> jsonMap) throws IOException {
		try {
			Object idObj = jsonMap.get("id");
			long id = idObj instanceof Number ? ((Number) idObj).longValue() : 0L;
			
			dao.deletar(id);

			response.setStatus(HttpServletResponse.SC_OK);
			response.getWriter().write("{\"status\":\"sucesso\",\"mensagem\":\"Lançamento excluído com sucesso!\"}");

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro ao excluir lançamento: " + e.getMessage() + "\"}");
		}
	}
}