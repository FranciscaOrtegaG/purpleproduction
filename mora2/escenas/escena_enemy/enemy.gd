extends CharacterBody2D
@export var enemylife = 10
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox



func _ready() -> void:
	hitbox.damage_dealt.connect(_on_damage_dealt)
func _on_damage_dealt() -> void:
	
	print("We made damage")
	

func take_damage(damage: int):
	enemylife -= damage
	if enemylife <= 0:
		queue_free()
	

	
