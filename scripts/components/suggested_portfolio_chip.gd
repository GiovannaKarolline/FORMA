extends PanelContainer

class_name SuggestedPortfolioChip

signal applied

@onready var name_label: Label = %PortfolioNameLabel
@onready var desc_label: Label = %PortfolioDescriptionLabel
@onready var apply_button: Button = %ApplyButton

func setup(portfolio: Dictionary) -> void:
	name_label.text = portfolio["nome"]
	desc_label.text = portfolio["descricao"]
	apply_button.pressed.connect(func(): applied.emit())
