extends Control
@onready var menu: Button = %MENU

func _ready() -> void:
	
	menu.pressed.connect(_on_menu_pressed)
	
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
