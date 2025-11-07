package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import models.Lancamento;
import models.Usuario;
import util.JDBCUtil;

public class LancamentoDAO {
	private Connection connection;

	public LancamentoDAO(Connection connection) {
		this.connection = connection;
	}

	public void salvar(Lancamento lancamento) throws SQLException {
		String sql = "INSERT INTO lancamentos (titulo, valor, categoria, data, formaPagamento, descricao, tipo, despesaFixa, vencimento, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, lancamento.getTitulo());
			stmt.setDouble(2, lancamento.getValor());
			stmt.setString(3, lancamento.getCategoria());
			stmt.setDate(4, Date.valueOf(lancamento.getData()));
			stmt.setString(5, lancamento.getFormaPagamento());
			stmt.setString(6, lancamento.getDescricao());
			stmt.setString(7, lancamento.getTipo());
			stmt.setBoolean(8, lancamento.getDespesaFixa());
			if (lancamento.getVencimento() != null) {
				stmt.setDate(9, Date.valueOf(lancamento.getVencimento()));
			} else {
				stmt.setNull(9, Types.DATE);
			}
			stmt.setLong(10, lancamento.getUsuario().getId());
			stmt.executeUpdate();
			try (ResultSet rs = stmt.getGeneratedKeys()) {
				if (rs.next()) {
					lancamento.setId(rs.getLong(1));
				}
			}
		}
	}

	public void atualizar(Lancamento lancamento) throws SQLException {
		String sql = "UPDATE lancamentos SET titulo=?, valor=?, categoria=?, data=?, formaPagamento=?, descricao=?, tipo=?, despesaFixa=?, vencimento=?, usuario_id=? WHERE id=?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, lancamento.getTitulo());
			stmt.setDouble(2, lancamento.getValor());
			stmt.setString(3, lancamento.getCategoria());
			stmt.setDate(4, Date.valueOf(lancamento.getData()));
			stmt.setString(5, lancamento.getFormaPagamento());
			stmt.setString(6, lancamento.getDescricao());
			stmt.setString(7, lancamento.getTipo());
			stmt.setBoolean(8, lancamento.getDespesaFixa());
			if (lancamento.getVencimento() != null) {
				stmt.setDate(9, Date.valueOf(lancamento.getVencimento()));
			} else {
				stmt.setNull(9, Types.DATE);
			}
			stmt.setLong(10, lancamento.getUsuario().getId());
			stmt.setLong(11, lancamento.getId());
			stmt.executeUpdate();
		}
	}

	public void deletar(Long id) throws SQLException {
		String sql = "DELETE FROM lancamentos WHERE id=?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, id);
			stmt.executeUpdate();
		}
	}

	public Lancamento buscarPorId(Long id) throws SQLException {
		String sql = "SELECT * FROM lancamentos WHERE id=?";
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

	public List<Lancamento> listarPorUsuario(Usuario usuario) throws SQLException {
		List<Lancamento> lista = new ArrayList<>();
		String sql = "SELECT * FROM lancamentos WHERE usuario_id=? ORDER BY data DESC";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuario.getId());
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					lista.add(map(rs));
				}
			}
		}
		return lista;
	}

	// ================================
	// NOVO MÉTODO: listar apenas despesas fixas
	public List<Lancamento> listarPorUsuarioEFixa(Usuario usuario, boolean despesaFixa) throws SQLException {
		List<Lancamento> lista = new ArrayList<>();
		String sql = "SELECT * FROM lancamentos WHERE usuario_id=? AND despesaFixa=? ORDER BY data DESC";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuario.getId());
			stmt.setBoolean(2, despesaFixa);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					lista.add(map(rs));
				}
			}
		}
		return lista;
	}

	// ================================
	// MÉTODO: listar por período
	public List<Lancamento> listarPorPeriodo(Usuario usuario, LocalDate dataInicio, LocalDate dataFim)
			throws SQLException {
		List<Lancamento> lista = new ArrayList<>();
		String sql = "SELECT * FROM lancamentos WHERE usuario_id=? AND data BETWEEN ? AND ? ORDER BY data DESC";

		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuario.getId());
			stmt.setDate(2, Date.valueOf(dataInicio));
			stmt.setDate(3, Date.valueOf(dataFim));

			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					lista.add(map(rs));
				}
			}
		}

		return lista;
	}
	// ================================

	private Lancamento map(ResultSet rs) throws SQLException {
		Lancamento l = new Lancamento();
		l.setId(rs.getLong("id"));
		l.setTitulo(rs.getString("titulo"));
		l.setValor(rs.getDouble("valor"));
		l.setCategoria(rs.getString("categoria"));
		l.setData(rs.getDate("data").toLocalDate());
		l.setFormaPagamento(rs.getString("formaPagamento"));
		l.setDescricao(rs.getString("descricao"));
		l.setTipo(rs.getString("tipo"));
		l.setDespesaFixa(rs.getBoolean("despesaFixa"));

		Date vencimento = rs.getDate("vencimento");
		if (vencimento != null) {
			l.setVencimento(vencimento.toLocalDate());
		}

		Usuario u = new Usuario();
		u.setId(rs.getLong("usuario_id"));
		l.setUsuario(u);

		return l;
	}

	/**
	 * Calcula o total de receitas do mês atual do usuário
	 */
	public Double calcularTotalReceitasMesAtual(Long usuarioId) throws SQLException {
		String sql = "SELECT COALESCE(SUM(valor), 0) as total " + "FROM lancamentos " + "WHERE usuario_id = ? "
				+ "AND tipo = 'RECEITA' " + "AND MONTH(data) = MONTH(CURRENT_DATE()) "
				+ "AND YEAR(data) = YEAR(CURRENT_DATE())";

		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuarioId);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getDouble("total");
				}
			}
		}
		return 0.0;
	}

	/**
	 * Calcula o total de despesas do mês atual do usuário
	 */
	public Double calcularTotalDespesasMesAtual(Long usuarioId) throws SQLException {
		String sql = "SELECT COALESCE(SUM(valor), 0) as total " + "FROM lancamentos " + "WHERE usuario_id = ? "
				+ "AND tipo = 'DESPESA' " + "AND MONTH(data) = MONTH(CURRENT_DATE()) "
				+ "AND YEAR(data) = YEAR(CURRENT_DATE())";

		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuarioId);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getDouble("total");
				}
			}
		}
		return 0.0;
	}

	/**
	 * Calcula o total de receitas de todos os tempos (já existente ou adicionar)
	 */
	public Double calcularTotalReceitas(Long usuarioId) throws SQLException {
		String sql = "SELECT COALESCE(SUM(valor), 0) as total " + "FROM lancamentos "
				+ "WHERE usuario_id = ? AND tipo = 'RECEITA'";

		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuarioId);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getDouble("total");
				}
			}
		}
		return 0.0;
	}

	/**
	 * Calcula o total de despesas de todos os tempos (já existente ou adicionar)
	 */
	public Double calcularTotalDespesas(Long usuarioId) throws SQLException {
		String sql = "SELECT COALESCE(SUM(valor), 0) as total " + "FROM lancamentos "
				+ "WHERE usuario_id = ? AND tipo = 'DESPESA'";

		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, usuarioId);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getDouble("total");
				}
			}
		}
		return 0.0;
	}

	public List<Lancamento> listarTodos() throws SQLException {
		List<Lancamento> lista = new ArrayList<>();
		String sql = "SELECT * FROM lancamentos ORDER BY data DESC";
		try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				lista.add(map(rs));
			}
		}
		return lista;
	}

}