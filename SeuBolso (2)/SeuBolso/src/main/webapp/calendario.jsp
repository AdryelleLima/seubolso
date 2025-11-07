<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="models.Lancamento"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>

<%
// Verifica se o usuário está logado
if (session.getAttribute("usuarioLogado") == null) {
	response.sendRedirect("login.jsp");
	return;
}

models.Usuario usuario = (models.Usuario) session.getAttribute("usuarioLogado");

// Carrega os lançamentos do usuário para o calendário
dao.LancamentoDAO lancamentoDAO = new dao.LancamentoDAO(util.JDBCUtil.getConnection());
List<Lancamento> lancamentos = lancamentoDAO.listarPorUsuario(usuario);

// Configura o formatador de moeda para o padrão brasileiro
NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>Calendário</title>

<link
	href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/main.min.css"
	rel="stylesheet" />
<link href="css/main.css" rel="stylesheet" />
<link href="css/calendario.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="navbar.jsp" />

	<div id="navbar-container"></div>

	<div class="conteudo">
		<div id="calendar"></div>
	</div>

	<jsp:include page="footer.jsp" />

	<script
		src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/locales-all.global.min.js"></script>

<script>
    // ========== CORES CENTRALIZADAS ==========
    const CORES = {
        despesa: {
            background: '#dc3545',
            border: '#bd2130',
            text: '#ffffff'
        },
        receita: {
            background: '#28a745',
            border: '#1e7e34',
            text: '#ffffff'
        }
    };

    // Passando lançamentos do back-end para o front-end
    const lancamentos = [
        <%for (int i = 0; i < lancamentos.size(); i++) {
            Lancamento l = lancamentos.get(i);
            
            // 1. Normalização do Tipo: Essencial para o JS
            String tipoOriginal = l.getTipo() != null ? l.getTipo().trim() : "RECEITA";
            String tipoNormalizado = tipoOriginal.toLowerCase();
            
            // 2. Data de Referência: Vencimento tem prioridade
            LocalDate dataReferencia = l.getVencimento() != null ? l.getVencimento() : l.getData();
            int diaVencimento = dataReferencia.getDayOfMonth();
        %>
            {
                // 3. Formatação do Título: Usando NumberFormat para R$
                title: "<%=l.getTitulo()%> - <%=nf.format(l.getValor())%>",
                start: "<%=l.getData()%>",
                tipo: "<%=tipoNormalizado%>",
                fixo: <%=l.getDespesaFixa() != null && l.getDespesaFixa()%>,
                diaVencimento: <%=diaVencimento%>
            }<%=(i < lancamentos.size() - 1) ? "," : ""%>
        <%}%>
    ];
    
    // DEBUG: Verifica os tipos no console
    console.log("Lançamentos carregados:", lancamentos);
</script>

	<script src="js/main.js"></script>
	<script src="js/calendario.js"></script>
</body>
</html>