extends Control

@export var main: PackedScene

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit
@onready var tutorial: Button = $MainMenu/Tutorial

const CREDITS = preload("res://scenes/ui/creditos/Credits.tscn")


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	tutorial.pressed.connect(_on_tutorial_pressed)
	quit.pressed.connect(get_tree().quit)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/first_level/first_level_test.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/creditos/Credits.tscn")
	
func _on_tutorial_pressed() -> void: 
	get_tree().change_scene_to_file("res://scenes/levels/prelevel/prelevel.tscn")
	
