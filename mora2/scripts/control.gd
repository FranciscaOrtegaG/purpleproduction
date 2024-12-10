extends Control

@export var main: PackedScene

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit
@onready var tutorial: Button = %Tutorial

const CREDITS = preload("res://scenes/ui/creditos/Credits.tscn")


func _ready() -> void:
	if start:
		start.pressed.connect(_on_start_pressed)
	if credits:
		credits.pressed.connect(_on_credits_pressed)
	if tutorial:
		tutorial.pressed.connect(_on_tutorial_pressed)
	if quit:
		quit.pressed.connect(get_tree().quit)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/first_level/first_level_test.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/creditos/Credits.tscn")
	
func _on_tutorial_pressed() -> void: 
	get_tree().change_scene_to_file("res://scenes/levels/prelevel/prelevel.tscn")
	
