extends Node2D

@onready var dimension_1 = $dm1
@onready var dimension_2 = $dm2
var current_dimension = 1

func _ready() -> void:
	# Mostramos la dimensión 1 y desactivamos la dimensión 2 al inicio
	dimension_1.visible = true
	dimension_2.visible = false
	set_dimension_state(dimension_1, true)
	set_dimension_state(dimension_2, false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		change_dimension()

func change_dimension() -> void:
	if current_dimension == 1:
		current_dimension = 2
		dimension_1.visible = false
		dimension_2.visible = true
		set_dimension_state(dimension_1, false)
		set_dimension_state(dimension_2, true)
	else:
		current_dimension = 1
		dimension_1.visible = true
		dimension_2.visible = false
		set_dimension_state(dimension_1, true)
		set_dimension_state(dimension_2, false)

# Función para activar/desactivar colisiones y procesamiento de una escena
func set_dimension_state(dimension: Node, is_active: bool) -> void:
	dimension.set_physics_process(is_active)  # Activar/desactivar física
	dimension.set_process(is_active)  # Activar/desactivar lógica

	# Si tienes objetos con colisiones, desactiva/activa sus capas de colisión
	for collider in dimension.get_children():
		if collider is CollisionObject2D:
			if is_active:
				collider.set_collision_layer(1)  # Activa la colisión
				collider.set_collision_mask(1)  # Activa la máscara de colisión
			else:
				collider.set_collision_layer(0)  # Desactiva la colisión
				collider.set_collision_mask(0)  # Desactiva la máscara de colisión
