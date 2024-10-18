class_name Player
extends CharacterBody2D

# Variables exportadas para ajustar desde el editor
@export var speed = 400
@export var jump_speed = 600
@export var gravity = 1500
@export var acceleration = 2000
@export var attacking = false
@export var playerlife = 20

# Nodos del jugador
@onready var hitbox: Hitbox = $Pivote/Hitbox
@onready var hurtbox: Hurtbox = $Pivote/Hurtbox
@onready var hit: AudioStreamPlayer2D = $Hit
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var sprite_2d: Sprite2D = $Pivote/Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot: Node2D = $Pivote

# Parámetros de wall jump
const wall_jump_pushback = 100
var can_wall_jump = false  # Variable para controlar si puede hacer wall jump

# Función que se ejecuta cuando el nodo entra en la escena
func _ready() -> void:
	position = Global.player_position  # Restauramos la posición guardada
	animation_tree.active = true
	hitbox.damage_dealt.connect(_on_damage_dealt)

# Función que controla la física y los movimientos del jugador
func _physics_process(delta: float) -> void:
	# Aplicar gravedad cuando no estamos en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta

	# Control del movimiento horizontal
	var move_input = Input.get_axis("ui_left", "ui_right")
	velocity.x = move_toward(velocity.x, speed * move_input, acceleration * delta)

	# Lógica de salto y wall jump
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			# Salto normal
			velocity.y = -jump_speed
			jump_sound.play()
		elif is_on_wall():
			# Wall jump (izquierda o derecha según la pared)
			if Input.is_action_pressed("ui_right"):
				velocity.y = -jump_speed
				velocity.x = -wall_jump_pushback
				jump_sound.play()
			elif Input.is_action_pressed("ui_left"):
				velocity.y = -jump_speed
				velocity.x = wall_jump_pushback
				jump_sound.play()

	# Actualizamos la animación del jugador según el movimiento
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

	# Movimiento del jugador
	move_and_slide()

	# Si el jugador cae del mapa, reiniciamos su posición
	if position.y > 800:
		Global.player_position = Vector2(0, 0) 
		get_tree().change_scene_to_file("res://escenas/escena_loser/Loser.tscn")

	# Si el jugador llega al final del nivel
	if position.x > 3440:
		get_tree().change_scene_to_file("res://escenas/escena_winner/Winner.tscn")

# Función que se ejecuta cuando el jugador hace daño
func _on_damage_dealt() -> void:
	hit.play()
	velocity.y = -jump_speed
	print("We made damage to enemy")

# Función para manejar el daño recibido
func take_damage(damage: int):
	playerlife -= damage
	print("player hurt")
	if playerlife <= 0:
		queue_free()	
		get_tree().change_scene_to_file("res://escenas/escena_loser/Loser.tscn")
