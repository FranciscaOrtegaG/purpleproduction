extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hop_timer: Timer = $HopTimer
@onready var hurt_box: CollisionShape2D = $Area2D/HurtBox
@onready var hit_box: CollisionShape2D = $Area2D2/HitBox



var hit_count = 0   # Cuenta las vidas restantes de la rana (inicialmente 0, sumaremos al recibir daño)
var frog_lifes = 2
var max_hits = 2    # Número de golpes necesarios para eliminar a la rana
var dying = false

func _ready() -> void:
	if not dying:
		animation_player.play("Idle")
	# Conecta la señal de timeout del temporizador para que ejecute hop periódicamente
	hop_timer.timeout.connect(_on_hop_timer_timeout)
	
func _on_hop_finished(anim_name: String) -> void:
	if anim_name == "Hop":
		animation_player.play("Idle")
		# Desconectar para evitar múltiples conexiones innecesarias
		animation_player.animation_finished.disconnect(_on_hop_finished)

func take_damage():
	if not dying:		
		hit_count += 1
		frog_lifes -= 1
		animation_player.play("damage")
		if hit_count >= max_hits:
			die()
		if frog_lifes == 0:
			die()

func die():
	if not dying:
		dying = true
		animation_player.play("explosion")
		var finished_animation = await animation_player.animation_finished
		if finished_animation == "explosion":
			print("explosion")
			queue_free()

func attack():
	if not dying:
		animation_player.play("attack")
	# Aquí puedes agregar lógica para el ataque si el jugador está cerca
	

func attack_player(body):
	if not dying:	
		animation_player.play("attack")
		body.take_damage(1, global_position)  # Asumiendo que el jugador tiene un método `take_damage(amount)`

func _on_hop_timer_timeout() -> void:
	if not dying:
		# Reproducir animación de salto
		animation_player.play("Hop")
		# Conectar la señal para volver a "idle" después de la animación "hop"
		animation_player.animation_finished.connect(_on_hop_finished)


func _on_hit_area_2d_body_entered(body: Node2D) -> void:
	if not dying:
		if body.is_in_group("Player"):
			attack_player(body)


func _on_hurt_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not dying:	
			take_damage()
		body.bounce()
