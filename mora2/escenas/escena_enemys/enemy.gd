extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed = 200
@export var left_limit = -100
@export var right_limit = 100

var direction = 1

func _physics_process(delta: float) -> void:
	if direction != 0: 
		sprite_2d.flip_h = (direction == -1)
	animation_player.play("hop")
	# Mover al personaje en la dirección actual
	position.x += speed * delta * direction
	
	# Cambiar la dirección si llega a los límites
	if position.x > right_limit:
		direction = -1
	elif position.x < left_limit:
		direction = 1
