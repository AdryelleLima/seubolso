package models;


import java.time.LocalDate;

public class Lancamento {
    private Long id;
    private String titulo;
    private Double valor;
    private String categoria;
    private LocalDate data;
    private String formaPagamento;
    private String descricao;
    private String tipo; // "receita" ou "despesa"
    private Boolean despesaFixa = false;
    private LocalDate vencimento;
    private Usuario usuario;

    public Lancamento() {
    }

    public Lancamento(Long id, String titulo, Double valor, String categoria, LocalDate data,
                      String formaPagamento, String descricao, String tipo,
                      Boolean despesaFixa, LocalDate vencimento, Usuario usuario) {
        this.id = id;
        this.titulo = titulo;
        this.valor = valor;
        this.categoria = categoria;
        this.data = data;
        this.formaPagamento = formaPagamento;
        this.descricao = descricao;
        this.tipo = tipo;
        this.despesaFixa = despesaFixa;
        this.vencimento = vencimento;
        this.usuario = usuario;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Double getValor() {
        return valor;
    }

    public void setValor(Double valor) {
        this.valor = valor;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public LocalDate getData() {
        return data;
    }

    public void setData(LocalDate data) {
        this.data = data;
    }

    public String getFormaPagamento() {
        return formaPagamento;
    }

    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Boolean getDespesaFixa() {
        return despesaFixa;
    }

    public void setDespesaFixa(Boolean despesaFixa) {
        this.despesaFixa = despesaFixa;
    }

    public LocalDate getVencimento() {
        return vencimento;
    }

    public void setVencimento(LocalDate vencimento) {
        this.vencimento = vencimento;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
