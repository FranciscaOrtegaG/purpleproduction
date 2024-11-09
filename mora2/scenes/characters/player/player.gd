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

# Escenas precargadas
const WINNER = preload("res://scenes/ui/winner/Winner.tscn")
const LOSER = preload("res://scenes/ui/loser/Loser.tscn")

# Parámetros de wall jump
const wall_jump_pushback = 100
var can_wall_jump = false  # Variable para controlar si puede hacer wall jump

# Variables para invulnerabilidad
var is_invulnerable = false
var invulnerability_time = 1.0  # Duración de la invulnerabilidad en segundos


# Función que se ejecuta cuando el nodo entra en la escena
func _ready() -> void:
	position = Global.player_position  # Restauramos la posición guardada
	animation_tree.active = true
	hitbox.damage_dealt.connect(_on_damage_dealt)
	add_to_group("Player")

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
	if position.y > 1500:
		Global.player_position = Vector2(0, 0) 
		get_tree().change_scene_to_packed(LOSER)

	# Si el jugador llega al final del nivel
	if position.x > 3440:
		get_tree().change_scene_to_packed(WINNER)

# Método para hacer rebotar al jugador
func bounce():
	velocity.y = -jump_speed  # Rebotar hacia arriba con la misma velocidad de salto
	jump_sound.play()         # Reproducir el sonido de salto (opcional)

# Función que se ejecuta cuando el jugador hace daño
func _on_damage_dealt() -> void:
	hit.play()
	velocity.y = -jump_speed
	print("We made damage to enemy")

# Función para manejar el daño recibido
func take_damage(damage: int, attacker_position = null):
	if not is_invulnerable:
		playerlife -= damage
		is_invulnerable = true
		flash_red()  # Llama a la función para destellar en rojo
		if attacker_position != null:
			apply_knockback(attacker_position)  # Aplica el empuje hacia atrás
		print("Player hurt, life remaining: ", playerlife)
		if playerlife <= 0:
			die()
		else:
			# Iniciar invulnerabilidad temporal
			var invulnerability_timer = get_tree().create_timer(invulnerability_time)
			invulnerability_timer.timeout.connect(_end_invulnerability)
	else:
		print("Player is invulnerable")

func _end_invulnerability():
	is_invulnerable = false
	sprite_2d.modulate = Color(1, 1, 1)  # Restablece el color original

# Función para manejar la muerte del jugador
func die():
	queue_free()    
	get_tree().change_scene_to_packed(LOSER)
	
func flash_red():
	sprite_2d.modulate = Color(1, 0, 0)  # Cambia el color a rojo
	# Inicia un temporizador para restaurar el color original
	var flash_timer = Timer.new()
	flash_timer.wait_time = 0.1  # Duración del destello en segundos
	flash_timer.one_shot = true
	add_child(flash_timer)
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	flash_timer.start()
	
func _on_flash_timer_timeout():
	sprite_2d.modulate = Color(1, 1, 1)  # Restaura el color original
	# Obtener referencia al temporizador y eliminarlo
	var flash_timer = get_node("flash_timer")
	if flash_timer:
		flash_timer.queue_free()
		
func apply_knockback(attacker_position: Vector2):
	var knockback_strength = 300  # Ajusta este valor según sea necesario
	var knockback_direction = (global_position - attacker_position).normalized()
	# Aplica el empuje a la velocidad del jugador
	velocity += knockback_direction * knockback_strength
