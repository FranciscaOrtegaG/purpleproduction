extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hop_timer: Timer = $HopTimer


var hit_count = 0  # Contador de golpes hacia la rana

func _ready() -> void:
	animation_player.play("Idle")
	# Conecta la señal de timeout del temporizador para que ejecute hop periódicamente
	hop_timer.timeout.connect(_on_hop_timer_timeout)
	
func _on_hop_finished(anim_name: String) -> void:
	if anim_name == "Hop":
		animation_player.play("Idle")
		# Desconectar para evitar múltiples conexiones innecesarias
		animation_player.animation_finished.disconnect(_on_hop_finished)

func take_damage():
	hit_count += 1
	animation_player.play("damage")
	if hit_count >= 2:
		die()

func die():
	animation_player.play("explosion")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "explosion":
		queue_free()  # Elimina el nodo de la rana después de la animación

func attack():
	animation_player.play("attack")
	# Aquí puedes agregar lógica para el ataque si el jugador está cerca


func _on_hop_timer_timeout() -> void:
	# Reproducir animación de salto
	animation_player.play("Hop")
	# Conectar la señal para volver a "idle" después de la animación "hop"
	animation_player.animation_finished.connect(_on_hop_finished)
