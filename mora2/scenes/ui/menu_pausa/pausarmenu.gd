extends CanvasLayer

@onready var resume: Button = %Resume
@onready var menu: Button = %Menu
@onready var quit: Button = %Quit

const MAIN_MENU = preload("res://scenes/ui/main_menu/MainMenu.tscn")


func _ready() -> void:
	resume.pressed.connect(_on_resume_pressed)
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(get_tree().quit)
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		visible = not visible
		get_tree().paused = visible


func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/MainMenu.tscn")
	
