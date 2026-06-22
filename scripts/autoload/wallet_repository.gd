extends Node
# Autoload: "WalletRepository"
# Formato padronizado do ativo. A futura API DEVE devolver objetos
# neste exato shape para que nenhuma outra parte da tela precise mudar.
#
# { "ticker": "PETR4", "nome": "Petrobras PN",
#   "categoria": "acoes_blue_chips", "preco": 38.42, "variacao_pct": 1.27 }

const CATEGORIES := [
	{ "id": "acoes_blue_chips",     "nome": "Ações · Blue Chips" },
	{ "id": "acoes_small_caps",     "nome": "Ações · Small & Mid Caps" },
	{ "id": "bancos_seguradoras",   "nome": "Bancos & Seguradoras" },
	{ "id": "fundos_imobiliarios",  "nome": "Fundos Imobiliários (FIIs)" },
	{ "id": "bdrs",                 "nome": "BDRs · Empresas Globais" },
	{ "id": "etfs",                 "nome": "ETFs" },
	{ "id": "renda_fixa",           "nome": "Renda Fixa Indexada" },
]

var _base_assets := [
	{"ticker":"PETR4","nome":"Petrobras PN","categoria":"acoes_blue_chips","preco":38.42,"variacao_pct":1.27},
	{"ticker":"PETR3","nome":"Petrobras ON","categoria":"acoes_blue_chips","preco":40.15,"variacao_pct":1.10},
	{"ticker":"VALE3","nome":"Vale ON","categoria":"acoes_blue_chips","preco":61.80,"variacao_pct":-0.45},
	{"ticker":"ITUB4","nome":"Itaú Unibanco PN","categoria":"acoes_blue_chips","preco":33.27,"variacao_pct":0.62},
	{"ticker":"BBDC4","nome":"Bradesco PN","categoria":"acoes_blue_chips","preco":14.55,"variacao_pct":-0.88},
	{"ticker":"BBDC3","nome":"Bradesco ON","categoria":"acoes_blue_chips","preco":13.90,"variacao_pct":-0.71},
	{"ticker":"ABEV3","nome":"Ambev ON","categoria":"acoes_blue_chips","preco":12.34,"variacao_pct":0.33},
	{"ticker":"BBAS3","nome":"Banco do Brasil ON","categoria":"acoes_blue_chips","preco":27.10,"variacao_pct":1.95},
	{"ticker":"WEGE3","nome":"WEG ON","categoria":"acoes_blue_chips","preco":39.88,"variacao_pct":2.41},
	{"ticker":"ITSA4","nome":"Itaúsa PN","categoria":"acoes_blue_chips","preco":9.87,"variacao_pct":0.51},
	{"ticker":"B3SA3","nome":"B3 ON","categoria":"acoes_blue_chips","preco":11.45,"variacao_pct":-1.12},
	{"ticker":"RENT3","nome":"Localiza ON","categoria":"acoes_blue_chips","preco":45.20,"variacao_pct":0.89},

	{"ticker":"MGLU3","nome":"Magazine Luiza ON","categoria":"acoes_small_caps","preco":8.12,"variacao_pct":3.10},
	{"ticker":"COGN3","nome":"Cogna Educação ON","categoria":"acoes_small_caps","preco":2.34,"variacao_pct":-2.05},
	{"ticker":"AZUL4","nome":"Azul PN","categoria":"acoes_small_caps","preco":6.78,"variacao_pct":-3.42},
	{"ticker":"CVCB3","nome":"CVC Brasil ON","categoria":"acoes_small_caps","preco":3.55,"variacao_pct":1.44},
	{"ticker":"RAIL3","nome":"Rumo ON","categoria":"acoes_small_caps","preco":19.60,"variacao_pct":0.77},
	{"ticker":"SOMA3","nome":"Grupo Soma ON","categoria":"acoes_small_caps","preco":7.95,"variacao_pct":1.02},
	{"ticker":"CASH3","nome":"Méliuz ON","categoria":"acoes_small_caps","preco":4.20,"variacao_pct":-0.95},
	{"ticker":"MOVI3","nome":"Movida ON","categoria":"acoes_small_caps","preco":10.30,"variacao_pct":0.58},

	{"ticker":"SANB11","nome":"Santander Brasil Unit","categoria":"bancos_seguradoras","preco":28.40,"variacao_pct":0.41},
	{"ticker":"BPAC11","nome":"BTG Pactual Unit","categoria":"bancos_seguradoras","preco":32.15,"variacao_pct":1.18},
	{"ticker":"PSSA3","nome":"Porto Seguro ON","categoria":"bancos_seguradoras","preco":24.70,"variacao_pct":-0.30},
	{"ticker":"BBSE3","nome":"BB Seguridade ON","categoria":"bancos_seguradoras","preco":31.05,"variacao_pct":0.66},
	{"ticker":"CXSE3","nome":"Caixa Seguridade ON","categoria":"bancos_seguradoras","preco":13.85,"variacao_pct":0.22},

	{"ticker":"HGLG11","nome":"CSHG Logística FII","categoria":"fundos_imobiliarios","preco":162.30,"variacao_pct":0.18},
	{"ticker":"KNRI11","nome":"Kinea Renda Imobiliária FII","categoria":"fundos_imobiliarios","preco":148.90,"variacao_pct":-0.12},
	{"ticker":"MXRF11","nome":"Maxi Renda FII","categoria":"fundos_imobiliarios","preco":10.45,"variacao_pct":0.05},
	{"ticker":"XPLG11","nome":"XP Log FII","categoria":"fundos_imobiliarios","preco":105.60,"variacao_pct":0.40},
	{"ticker":"VISC11","nome":"Vinci Shopping Centers FII","categoria":"fundos_imobiliarios","preco":118.20,"variacao_pct":-0.25},
	{"ticker":"BCFF11","nome":"BTG Pactual Fundo de Fundos","categoria":"fundos_imobiliarios","preco":76.40,"variacao_pct":0.10},
	{"ticker":"HGRE11","nome":"CSHG Real Estate FII","categoria":"fundos_imobiliarios","preco":140.15,"variacao_pct":0.31},

	{"ticker":"AAPL34","nome":"Apple Inc","categoria":"bdrs","preco":68.90,"variacao_pct":1.05},
	{"ticker":"MSFT34","nome":"Microsoft Corp","categoria":"bdrs","preco":92.45,"variacao_pct":0.84},
	{"ticker":"GOGL34","nome":"Alphabet Inc","categoria":"bdrs","preco":54.30,"variacao_pct":-0.41},
	{"ticker":"AMZO34","nome":"Amazon.com Inc","categoria":"bdrs","preco":48.75,"variacao_pct":0.97},
	{"ticker":"TSLA34","nome":"Tesla Inc","categoria":"bdrs","preco":71.20,"variacao_pct":-2.18},
	{"ticker":"NVDC34","nome":"Nvidia Corp","categoria":"bdrs","preco":135.60,"variacao_pct":3.05},

	{"ticker":"BOVA11","nome":"iShares Ibovespa","categoria":"etfs","preco":124.80,"variacao_pct":0.55},
	{"ticker":"IVVB11","nome":"iShares S&P 500","categoria":"etfs","preco":280.10,"variacao_pct":0.72},
	{"ticker":"SMAL11","nome":"iShares Small Cap","categoria":"etfs","preco":98.40,"variacao_pct":-0.15},
	{"ticker":"DIVO11","nome":"It Now IDIV","categoria":"etfs","preco":92.70,"variacao_pct":0.38},

	{"ticker":"TESOURO-SELIC-2029","nome":"Tesouro Selic 2029","categoria":"renda_fixa","preco":1.00,"variacao_pct":0.04},
	{"ticker":"TESOURO-IPCA-2035","nome":"Tesouro IPCA+ 2035","categoria":"renda_fixa","preco":1.00,"variacao_pct":0.06},
	{"ticker":"CDB-LIQ-DIARIA","nome":"CDB Liquidez Diária 102% CDI","categoria":"renda_fixa","preco":1.00,"variacao_pct":0.03},
]

# --- Carteiras (carteiras-modelo) mockadas ------------------------------
var _suggested_portfolios := [
	{
		"id": "carteira_dividendos",
		"nome": "Carteira Dividendos",
		"descricao": "Foco em empresas pagadoras de proventos recorrentes.",
		"tickers": ["BBAS3", "BBSE3", "ITSA4", "KNRI11", "HGLG11", "PSSA3", "SANB11"]
	},
	{
		"id": "carteira_crescimento",
		"nome": "Carteira Crescimento & Tech",
		"descricao": "Exposição a empresas de alto potencial de valorização.",
		"tickers": ["WEGE3", "RENT3", "MGLU3", "AAPL34", "MSFT34", "NVDC34", "TSLA34"]
	},
]

func get_categories() -> Array:
	return CATEGORIES.duplicate(true)

func get_available_assets() -> Array:
	# >>> PONTO DE TROCA PARA A API REAL <
	# Quando o backend estiver pronto, troque a linha abaixo por algo como:
	#   return await WalletApiClient.fetch_available_assets()
	# mantendo o MESMO formato de dicionário retornado.
	return _base_assets.duplicate(true) + _generate_extra_mock_assets()

func get_suggested_portfolios() -> Array:
	return _suggested_portfolios.duplicate(true)

# Apenas para simular o volume real (~180 itens) e testar scroll/grid.
# REMOVER esta função quando a API estiver integrada.
func _generate_extra_mock_assets() -> Array:
	var extra := []
	var categorias_ids := []
	for c in CATEGORIES:
		categorias_ids.append(c["id"])
	for i in range(135):
		var cat: String = categorias_ids[i % categorias_ids.size()]
		extra.append({
			"ticker": "MOCK%03d3" % i,
			"nome": "Ativo Simulado %d" % i,
			"categoria": cat,
			"preco": randf_range(2.0, 200.0),
			"variacao_pct": randf_range(-4.0, 4.0),
		})
	return extra
