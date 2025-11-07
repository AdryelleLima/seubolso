package dao;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.ListaDesejos;
import util.JDBCUtil;

public class ListaDesejosDAO {
	private Connection connection;

	public ListaDesejosDAO(Connection connection) {
		this.connection = connection;
	}

	public void salvar(ListaDesejos lista) throws SQLException {
		String sql = "INSERT INTO lista_desejos (descricao, valor_objetivo, valor_atual, link, imagem_base64, usuario_id) VALUES (?, ?, ?, ?, ?, ?)";
		try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, lista.getDescricao());
			stmt.setBigDecimal(2, lista.getValorObjetivo());
			stmt.setBigDecimal(3, lista.getValorAtual());
			stmt.setString(4, lista.getLink());
			stmt.setString(5, lista.getImagemBase64());
			stmt.setLong(6, lista.getUsuarioId());
			stmt.executeUpdate();

			try (ResultSet rs = stmt.getGeneratedKeys()) {
				if (rs.next()) {
					lista.setId(rs.getLong(1));
				}
			}
		}
	}

	public void atualizar(ListaDesejos lista) throws SQLException {
		String sql = "UPDATE lista_desejos SET descricao = ?, valor_objetivo = ?, valor_atual = ?, link = ?, imagem_base64 = ? WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, lista.getDescricao());
			stmt.setBigDecimal(2, lista.getValorObjetivo());
			stmt.setBigDecimal(3, lista.getValorAtual());
			stmt.setString(4, lista.getLink());
			stmt.setString(5, lista.getImagemBase64());
			stmt.setLong(6, lista.getId());
			stmt.executeUpdate();
		}
	}

	public void deletar(Long id) throws SQLException {
		String sql = "DELETE FROM lista_desejos WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, id);
			stmt.executeUpdate();
		}
	}

	public ListaDesejos buscarPorId(Long id) throws SQLException {
		String sql = "SELECT * FROM lista_desejos WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, id);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return map(rs);
				}
			}
		}
		return null;
	}

	public List<ListaDesejos> listarPorUsuario(long usuarioId) throws SQLException {
		List<ListaDesejos> lista = new ArrayList<>();
		String sql = "SELECT * FROM lista_desejos WHERE usuario_id = ? ORDER BY data_criacao DESC";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuarioId);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					lista.add(map(rs));
				}
			}
		}
		return lista;
	}

	private ListaDesejos map(ResultSet rs) throws SQLException {
		ListaDesejos l = new ListaDesejos();
		l.setId(rs.getLong("id"));
		l.setDescricao(rs.getString("descricao"));
		l.setValorObjetivo(rs.getBigDecimal("valor_objetivo"));
		l.setValorAtual(rs.getBigDecimal("valor_atual"));
		l.setLink(rs.getString("link"));
		l.setImagemBase64(rs.getString("imagem_base64"));
		l.setUsuarioId(rs.getLong("usuario_id"));
		l.setDataCriacao(rs.getTimestamp("data_criacao"));
		return l;
	}

	/**
	 * Busca os desejos com maior progresso (mais próximos de serem completados)
	 * 
	 * @param usuarioId ID do usuário
	 * @param limite    Quantidade máxima de registros a retornar
	 * @return Lista de desejos ordenada por progresso (decrescente)
	 */
	public List<ListaDesejos> buscarTopDesejosPorProgresso(Long usuarioId, int limite) {
		List<ListaDesejos> lista = new ArrayList<>();
		String sql = "SELECT * FROM lista_desejos WHERE usuario_id = ? AND valor_objetivo > 0 "
				+ "ORDER BY (valor_atual / valor_objetivo) DESC LIMIT ?";

		try (Connection conn = JDBCUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setLong(1, usuarioId);
			stmt.setInt(2, limite);

			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					ListaDesejos item = map(rs);
					lista.add(item);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return lista;
	}

	/**
	 * Calcula o progresso percentual de um desejo
	 * 
	 * @param valorAtual    Valor já economizado
	 * @param valorObjetivo Valor total necessário
	 * @return Progresso em percentual (0-100)
	 */
	public static int calcularProgresso(BigDecimal valorAtual, BigDecimal valorObjetivo) {
		if (valorObjetivo == null || valorObjetivo.compareTo(BigDecimal.ZERO) == 0) {
			return 0;
		}

		if (valorAtual == null) {
			return 0;
		}

		BigDecimal progresso = valorAtual.multiply(new BigDecimal("100")).divide(valorObjetivo, 2,
				RoundingMode.HALF_UP);

		// Limitar a 100%
		if (progresso.compareTo(new BigDecimal("100")) > 0) {
			return 100;
		}

		return progresso.intValue();
	}
}