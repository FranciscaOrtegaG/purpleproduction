extends Control

@export var main: PackedScene

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit
@onready var menu: Button = %Menu

const CREDITS = preload("res://scenes/ui/creditos/Credits.tscn")


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(get_tree().quit)
	


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/first_level/first_level_test.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)
	
func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/MainMenu.tscn")
	
	
	
