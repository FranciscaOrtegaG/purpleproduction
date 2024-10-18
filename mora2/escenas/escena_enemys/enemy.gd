extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var enemylife = 10

@export var speed = 200
@export var left_limit = -100
@export var right_limit = 100

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox

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

func die():
	animation_player.play("hurt")
	queue_free()
	pass




func _ready() -> void:
	hitbox.damage_dealt.connect(_on_damage_dealt)
func _on_damage_dealt() -> void:
	
	print("We made damage to player")
	

func take_damage(damage: int):
	print("enemy hurt")
	enemylife -= damage
	animation_player.play("hurt")
	if enemylife <= 0:
		queue_free()
	

	
