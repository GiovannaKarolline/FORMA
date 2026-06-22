extends VBoxContainer

class_name CategorySection

@onready var header_button: Button = %HeaderButton
@onready var title_label: Label = %CategoryTitleLabel
@onready var count_label: Label = %CountBadge
@onready var items_grid: GridContainer = %ItemsGrid
@onready var chevron: TextureRect = %Chevron

const WALLET_ITEM_SCENE := preload("res://scenes/components/wallet_list_item.tscn")

func _ready() -> void:
	header_button.pressed.connect(_toggle_collapse)

func setup(category_name: String, assets: Array) -> void:
	title_label.text = category_name.to_upper()
	count_label.text = "(%d)" % assets.size()
	for child in items_grid.get_children():
		child.queue_free()
	for asset in assets:
		var item := WALLET_ITEM_SCENE.instantiate()
		items_grid.add_child(item)
		item.setup(asset)

func set_columns(columns: int) -> void:
	items_grid.columns = max(1, columns)

func filter_by_text(query: String) -> int:
	var visible_count: int = 0
	for item in items_grid.get_children():
		var wallet_item := item as WalletListItem
		if wallet_item == null:
			continue
		var matches: bool = query.is_empty() or wallet_item.matches_query(query)
		wallet_item.visible = matches
		visible_count += int(matches)
	visible = visible_count > 0
	return visible_count

func _toggle_collapse() -> void:
	items_grid.visible = not items_grid.visible
	chevron.rotation_degrees = 180.0 if not items_grid.visible else 0.0
