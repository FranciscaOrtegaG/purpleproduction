extends Control

@export var main: PackedScene

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit



func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	quit.pressed.connect(get_tree().quit)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(main)


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Credits.tscn")
	
	
