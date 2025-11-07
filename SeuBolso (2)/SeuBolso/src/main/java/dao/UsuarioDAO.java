package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Usuario;

public class UsuarioDAO {
	private Connection connection;

	// Construtor que recebe conexão
	public UsuarioDAO(Connection connection) {
		this.connection = connection;
	}

	/**
	 * Busca usuário por email e senha (usado no login)
	 */
	public Usuario buscarPorEmailESenha(String email, String senha) throws SQLException {
		String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, email);
			stmt.setString(2, senha);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return mapearUsuario(rs);
				}
			}
		}
		return null;
	}

	/**
	 * Busca usuário por ID
	 */
	public Usuario buscarPorId(Long id) throws SQLException {
		String sql = "SELECT * FROM usuarios WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, id);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return mapearUsuario(rs);
				}
			}
		}
		return null;
	}

	/**
	 * Busca usuário por email
	 */
	public Usuario buscarPorEmail(String email) throws SQLException {
		String sql = "SELECT * FROM usuarios WHERE email = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, email);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return mapearUsuario(rs);
				}
			}
		}
		return null;
	}

	/**
	 * Cadastra um novo usuário
	 */
	public boolean cadastrar(Usuario usuario) throws SQLException {
		String sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";
		try (PreparedStatement stmt = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, usuario.getNome());
			stmt.setString(2, usuario.getEmail());
			stmt.setString(3, usuario.getSenha());

			int linhasAfetadas = stmt.executeUpdate();

			if (linhasAfetadas > 0) {
				try (ResultSet rs = stmt.getGeneratedKeys()) {
					if (rs.next()) {
						usuario.setId(rs.getLong(1));
					}
				}
				return true;
			}
		}
		return false;
	}

	/**
	 * Atualiza a foto de perfil do usuário
	 */
	public boolean atualizarFotoPerfil(Long id, String fotoPerfil) throws SQLException {
		String sql = "UPDATE usuarios SET foto_perfil = ? WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, fotoPerfil);
			stmt.setLong(2, id);

			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Atualiza o nome do usuário
	 */
	public boolean atualizarNome(Long id, String nome) throws SQLException {
		String sql = "UPDATE usuarios SET nome = ? WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, nome);
			stmt.setLong(2, id);

			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Atualiza o objetivo financeiro do usuário
	 */
	public boolean atualizarObjetivoFinanceiro(Long id, Double objetivoFinanceiro) throws SQLException {
		String sql = "UPDATE usuarios SET objetivo_financeiro = ? WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setDouble(1, objetivoFinanceiro);
			stmt.setLong(2, id);

			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Atualiza o valor guardado do usuário
	 */
	public boolean atualizarValorGuardado(Long id, Double valorGuardado) throws SQLException {
		String sql = "UPDATE usuarios SET valor_guardado = ? WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setDouble(1, valorGuardado);
			stmt.setLong(2, id);

			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Atualiza a senha do usuário
	 */
	public boolean atualizarSenha(Long id, String novaSenha) throws SQLException {
		String sql = "UPDATE usuarios SET senha = ? WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, novaSenha);
			stmt.setLong(2, id);

			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Exclui um usuário (e todos os dados relacionados devido ao CASCADE)
	 */
	public boolean excluir(Long id) throws SQLException {
		String sql = "DELETE FROM usuarios WHERE id = ?";
		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setLong(1, id);
			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Mapeia um ResultSet para um objeto Usuario
	 */
	private Usuario mapearUsuario(ResultSet rs) throws SQLException {
		Usuario usuario = new Usuario();
		usuario.setId(rs.getLong("id"));
		usuario.setNome(rs.getString("nome"));
		usuario.setEmail(rs.getString("email"));
		usuario.setSenha(rs.getString("senha"));
		usuario.setFotoPerfil(rs.getString("foto_perfil"));

		// Usar getDouble com verificação para evitar valores null
		Double objetivo = rs.getDouble("objetivo_financeiro");
		usuario.setObjetivoFinanceiro(rs.wasNull() ? 0.0 : objetivo);

		Double guardado = rs.getDouble("valor_guardado");
		usuario.setValorGuardado(rs.wasNull() ? 0.0 : guardado);

		return usuario;
	}

	/**
	 * Lista todos os usuários cadastrados
	 */
	public List<Usuario> listarTodos() throws SQLException {
		List<Usuario> usuarios = new ArrayList<>();
		String sql = "SELECT * FROM usuarios ORDER BY nome";

		try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

			while (rs.next()) {
				usuarios.add(mapearUsuario(rs));
			}
		}

		return usuarios;
	}

	/**
	 * Salva um novo usuário (alias para o método cadastrar)
	 */
	public boolean salvar(Usuario usuario) throws SQLException {
		return cadastrar(usuario);
	}

	/**
	 * Atualiza todos os dados de um usuário existente
	 */
	public boolean atualizar(Usuario usuario) throws SQLException {
		String sql = "UPDATE usuarios SET nome = ?, email = ?, senha = ?, "
				+ "foto_perfil = ?, objetivo_financeiro = ?, valor_guardado = ? " + "WHERE id = ?";

		try (PreparedStatement stmt = connection.prepareStatement(sql)) {
			stmt.setString(1, usuario.getNome());
			stmt.setString(2, usuario.getEmail());
			stmt.setString(3, usuario.getSenha());
			stmt.setString(4, usuario.getFotoPerfil());
			stmt.setDouble(5, usuario.getObjetivoFinanceiro());
			stmt.setDouble(6, usuario.getValorGuardado());
			stmt.setLong(7, usuario.getId());

			return stmt.executeUpdate() > 0;
		}
	}

	/**
	 * Deleta um usuário (alias para o método excluir)
	 */
	public boolean deletar(Long id) throws SQLException {
		return excluir(id);
	}
}