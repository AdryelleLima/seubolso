package models;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;

public class ListaDesejos {
	private Long id;
	private String descricao;
	private BigDecimal valorObjetivo;
	private BigDecimal valorAtual;
	private String link;
	private String imagemBase64;
	private Long usuarioId;
	private Timestamp dataCriacao;

	// Construtores
	public ListaDesejos() {
		this.valorAtual = BigDecimal.ZERO;
	}

	public ListaDesejos(String descricao, BigDecimal valorObjetivo, Long usuarioId) {
		this.descricao = descricao;
		this.valorObjetivo = valorObjetivo;
		this.usuarioId = usuarioId;
		this.valorAtual = BigDecimal.ZERO;
	}

	// Getters e Setters
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public BigDecimal getValorObjetivo() {
		return valorObjetivo;
	}

	public void setValorObjetivo(BigDecimal valorObjetivo) {
		this.valorObjetivo = valorObjetivo;
	}

	public BigDecimal getValorAtual() {
		return valorAtual != null ? valorAtual : BigDecimal.ZERO;
	}

	public void setValorAtual(BigDecimal valorAtual) {
		this.valorAtual = valorAtual;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public String getImagemBase64() {
		return imagemBase64;
	}

	public void setImagemBase64(String imagemBase64) {
		this.imagemBase64 = imagemBase64;
	}

	public Long getUsuarioId() {
		return usuarioId;
	}

	public void setUsuarioId(Long usuarioId) {
		this.usuarioId = usuarioId;
	}

	public Timestamp getDataCriacao() {
		return dataCriacao;
	}

	public void setDataCriacao(Timestamp dataCriacao) {
		this.dataCriacao = dataCriacao;
	}

	/**
	 * Calcula o progresso percentual do desejo (0-100) Este método é usado
	 * diretamente nos JSPs via ${item.progresso}
	 * 
	 * @return Progresso em percentual inteiro
	 */
	public int getProgresso() {
		if (valorObjetivo == null || valorObjetivo.compareTo(BigDecimal.ZERO) == 0) {
			return 0;
		}

		BigDecimal atual = getValorAtual(); // Usa o getter que retorna ZERO se for null

		BigDecimal progresso = atual.multiply(new BigDecimal("100")).divide(valorObjetivo, 2, RoundingMode.HALF_UP);

		// Limitar a 100%
		if (progresso.compareTo(new BigDecimal("100")) > 0) {
			return 100;
		}

		return progresso.intValue();
	}

	/**
	 * Calcula quanto falta para atingir o objetivo
	 * 
	 * @return Valor restante
	 */
	public BigDecimal getValorRestante() {
		BigDecimal atual = getValorAtual();
		if (valorObjetivo == null) {
			return BigDecimal.ZERO;
		}

		BigDecimal restante = valorObjetivo.subtract(atual);
		return restante.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : restante;
	}

	/**
	 * Verifica se o desejo foi completamente realizado
	 * 
	 * @return true se o valor atual >= valor objetivo
	 */
	public boolean isCompleto() {
		if (valorObjetivo == null) {
			return false;
		}
		return getValorAtual().compareTo(valorObjetivo) >= 0;
	}

	@Override
	public String toString() {
		return "ListaDesejos [id=" + id + ", descricao=" + descricao + ", valorObjetivo=" + valorObjetivo
				+ ", valorAtual=" + valorAtual + ", progresso=" + getProgresso() + "%]";
	}
}