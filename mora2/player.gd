class_name Player
extends CharacterBody2D



@export var speed = 400
@export var jump_speed = 600
@export var gravity = 1500
@export var acceleration = 2000
@export var attacking = false
@export var playerlife = 20
@onready var hitbox: Hitbox = $Pivote/Hitbox
@onready var hurtbox: Hurtbox = $Pivote/Hurtbox

@onready var hit: AudioStreamPlayer2D = $Hit
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var sprite_2d: Sprite2D = $Pivote/Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot: Node2D = $Pivote


func _ready() -> void:
	animation_tree.active = true
	hitbox.damage_dealt.connect(_on_damage_dealt)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	var move_input = Input.get_axis("ui_left", "ui_right")
	
	velocity.x = move_toward(velocity.x, speed *  move_input, acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump_speed
		jump_sound.play()
	move_and_slide()
	
	
	if move_input != 0:
		pivot.scale.x = sign(move_input)
	
	if is_on_floor():
		if abs(velocity.x) > 10 or move_input:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("air")
	if position.y > 1000:
		get_tree().change_scene_to_file("res://Loser.tscn")
	if position.x > 3440:
		get_tree().change_scene_to_file("res://Winner.tscn")
	
		
			
func _on_damage_dealt() -> void:
	hit.play()
	velocity.y = -jump_speed
	print("We made damage")
	
func take_damage(damage: int):
	playerlife -= damage
	if playerlife <= 0:
		queue_free()	
		get_tree().change_scene_to_file("res://Loser.tscn")
