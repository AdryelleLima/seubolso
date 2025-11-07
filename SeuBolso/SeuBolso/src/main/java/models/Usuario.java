// Adicionar estes atributos e métodos à classe Usuario existente

package models;

public class Usuario {
    private Long id;
    private String nome;
    private String email;
    private String senha;
    private String fotoPerfil;
    private Double objetivoFinanceiro;
    private Double valorGuardado;

    // Construtores
    public Usuario() {
        this.objetivoFinanceiro = 0.0;
        this.valorGuardado = 0.0;
    }

    public Usuario(String nome, String email, String senha) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.objetivoFinanceiro = 0.0;
        this.valorGuardado = 0.0;
    }

    

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSenha() {
		return senha;
	}

	public void setSenha(String senha) {
		this.senha = senha;
	}

	public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }

    public Double getObjetivoFinanceiro() {
        return objetivoFinanceiro != null ? objetivoFinanceiro : 0.0;
    }

    public void setObjetivoFinanceiro(Double objetivoFinanceiro) {
        this.objetivoFinanceiro = objetivoFinanceiro;
    }

    public Double getValorGuardado() {
        return valorGuardado != null ? valorGuardado : 0.0;
    }

    public void setValorGuardado(Double valorGuardado) {
        this.valorGuardado = valorGuardado;
    }

    public Double getProgressoObjetivo() {
        if (objetivoFinanceiro == null || objetivoFinanceiro == 0) {
            return 0.0;
        }
        return (valorGuardado / objetivoFinanceiro) * 100;
    }
}