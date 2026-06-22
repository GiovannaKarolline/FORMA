extends VBoxContainer

@onready var safe_area_margin: MarginContainer = %SafeAreaMargin
@onready var counter_label: Label              = %SelectionCounterLabel
@onready var suggested_row: HBoxContainer      = %SuggestedPortfoliosRow
@onready var search_edit: LineEdit             = %SearchLineEdit
@onready var assets_list: VBoxContainer        = %AssetsListContainer
@onready var bottom_bar: PanelContainer        = %BottomSelectionBar
@onready var clear_button: Button              = %ClearSelectionButton
@onready var continue_button: Button           = %ContinueButton

const CATEGORY_SECTION_SCENE := preload("res://scenes/components/category_section.tscn")
const SUGGESTED_CHIP_SCENE   := preload("res://scenes/components/suggested_portfolio_chip.tscn")

const BREAKPOINT_TABLET  := 600
const BREAKPOINT_DESKTOP := 900

# Valores explícitos pois são usados fora de _ready() (no sinal resized)
var _category_sections: Dictionary = {}

func _ready() -> void:
	resized.connect(_update_responsive_layout)
	get_viewport().size_changed.connect(_update_responsive_layout)  # ← linha nova

	search_edit.text_changed.connect(_on_search_changed)
	SelectionManager.selection_changed.connect(_on_selection_changed)
	SelectionManager.selection_limit_reached.connect(_on_limit_reached)
	clear_button.pressed.connect(SelectionManager.clear)

	_load_suggested_portfolios()
	_load_categories()
	_update_responsive_layout.call_deferred()  # ← era _update_responsive_layout()
	_on_selection_changed([], 0)

func _load_categories() -> void:
	var categories: Array = WalletRepository.get_categories()
	var all_assets: Array = WalletRepository.get_available_assets()

	for category: Dictionary in categories:
		var in_cat: Array = all_assets.filter(
			func(a: Dictionary) -> bool:
				return a.get("categoria", "") == category.get("id", "")
		)
		if in_cat.is_empty():
			continue

		# Cast explícito: instantiate() retorna Node, precisamos de CategorySection
		var section: CategorySection = CATEGORY_SECTION_SCENE.instantiate()
		assets_list.add_child(section)
		section.setup(category.get("nome", ""), in_cat)
		_category_sections[category.get("id", "")] = section

func _load_suggested_portfolios() -> void:
	for portfolio: Dictionary in WalletRepository.get_suggested_portfolios():
		# Cast explícito: necessário para acessar .setup() e .applied
		var chip: SuggestedPortfolioChip = SUGGESTED_CHIP_SCENE.instantiate()
		suggested_row.add_child(chip)
		chip.setup(portfolio)

		# Captura local evita o problema clássico de closure-em-loop
		var tickers: Array = portfolio.get("tickers", []).duplicate()
		chip.applied.connect(func() -> void: SelectionManager.apply_preset(tickers))

func _on_search_changed(text: String) -> void:
	for section: CategorySection in _category_sections.values():
		section.filter_by_text(text)

func _on_selection_changed(_selected: Array, count: int) -> void:
	counter_label.text = "%d/10 selecionados" % count

	var cor: Color = FormaTokens.N500
	if count == SelectionManager.MAX_SELECTION:
		cor = FormaTokens.RED
	elif count >= 8:
		cor = FormaTokens.AMBER
	counter_label.add_theme_color_override("font_color", cor)

	bottom_bar.visible        = count > 0
	clear_button.visible      = count > 0
	continue_button.disabled  = count == 0

func _on_limit_reached() -> void:
	push_warning("Limite de 10 ativos atingido. Remova um para adicionar outro.")

func _update_responsive_layout() -> void:
	var w := get_viewport().get_visible_rect().size.x  # ← sempre tem valor real
	var columns := 1
	var margin  := 16

	if w >= BREAKPOINT_DESKTOP:
		columns = 3
		margin  = 64
	elif w >= BREAKPOINT_TABLET:
		columns = 2
		margin  = 32

	for section: CategorySection in _category_sections.values():
		section.set_columns(columns)

	safe_area_margin.add_theme_constant_override("margin_left",  margin)
	safe_area_margin.add_theme_constant_override("margin_right", margin)
