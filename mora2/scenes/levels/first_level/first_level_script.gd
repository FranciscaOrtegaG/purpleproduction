extends Node2D

@onready var dimension_1: Node2D = $dim_1
@onready var dimension_2: Node2D = $dim_2
@onready var tiles_dim_1: TileMapLayer = $dim_1/tiles_dim_1
@onready var tiles_dim_2: TileMapLayer = $dim_2/tiles_dim_2
@onready var player: Player = $player
@onready var left_border: StaticBody2D = $LeftBorder


var current_dimension = 1
var WIN_X_POSITION = 6600
var LOSE_Y_POSITION = 1000

func _ready() -> void:
	# Mostramos la dimensión 1 y desactivamos la dimensión 2 al inicio
	dimension_1.visible = true
	dimension_2.visible = false

	# Accedemos al TileSet de cada TileMapLayer
	var tileset_dim_1 = tiles_dim_1.tile_set
	var tileset_dim_2 = tiles_dim_2.tile_set

	# Configuramos las capas y máscaras de colisión de los Physics Layers
	# Asumiendo que el índice de la capa física es 0
	# Para dimensión 1
	tileset_dim_1.set_physics_layer_collision_layer(0, 4)  # Capa de colisión 4
	tileset_dim_1.set_physics_layer_collision_mask(0, 2)   # Máscara de colisión 2 (jugador)

	# Para dimensión 2
	tileset_dim_2.set_physics_layer_collision_layer(0, 5)  # Capa de colisión 5
	tileset_dim_2.set_physics_layer_collision_mask(0, 2)   # Máscara de colisión 2 (jugador)
	
	# Setear mascara y layer de colision para bordes
	left_border.collision_layer = 1
	left_border.collision_mask = 2

	# Habilitamos las colisiones en tiles_dim_1 y en los bordes, y deshabilitamos en tiles_dim_2
	tiles_dim_1.collision_enabled = true
	tiles_dim_2.collision_enabled = false

	set_dimension_state(dimension_1, true)
	set_dimension_state(dimension_2, false)

	# Configuramos la máscara de colisión del jugador para la dimensión inicial
	player.collision_layer = 2
	player.collision_mask = 1|4  # Colisiona con la capa 4 (dimensión 1) o capa 1 (bordes)

func _process(delta: float) -> void:
	# Chequeo de victoria
	if player.position.x > WIN_X_POSITION:
		get_tree().change_scene_to_file("res://scenes/ui/winner/Winner.tscn")
	# Chequeo de derrota
	if player.position.y > LOSE_Y_POSITION:
		get_tree().change_scene_to_file("res://scenes/ui/loser/Loser.tscn")
		
	if Input.is_action_just_pressed("ui_down"):
		change_dimension()

func change_dimension() -> void:
	if current_dimension == 1:
		current_dimension = 2

		dimension_1.visible = false
		dimension_2.visible = true
		set_dimension_state(dimension_1, false)
		set_dimension_state(dimension_2, true)

		# Cambiamos la máscara de colisión del jugador para la dimensión 2
		player.collision_layer = 2
		player.collision_mask = 1|5  # Colisiona con la capa 5 (dimensión 2) o capa 1 (bordes)

		# Deshabilitamos colisiones en tiles_dim_1 y habilitamos en tiles_dim_2
		tiles_dim_1.collision_enabled = false
		tiles_dim_2.collision_enabled = true
	else:
		current_dimension = 1
		dimension_1.visible = true
		dimension_2.visible = false
		set_dimension_state(dimension_1, true)
		set_dimension_state(dimension_2, false)

		player.collision_layer = 2
		player.collision_mask = 1|4  # Colisiona con la capa 4 (dimensión 1)

		# Habilitamos colisiones en tiles_dim_1 y deshabilitamos en tiles_dim_2
		tiles_dim_1.collision_enabled = true
		tiles_dim_2.collision_enabled = false

# Función para activar/desactivar colisiones y procesamiento de una dimensión
func set_dimension_state(dimension: Node, is_active: bool) -> void:
	dimension.set_physics_process(is_active)
	dimension.set_process(is_active)
	# Recorrer recursivamente todos los nodos hijos y ajustar su estado
	for child in dimension.get_children():
		if child is Node:
			child.set_physics_process(is_active)
			child.set_process(is_active)
			# Llamada recursiva para ajustar los descendientes
			set_dimension_state(child, is_active)
