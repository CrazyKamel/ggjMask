extends CharacterBody2D

@export var step_length = 128
@export var mask_strengh = 0

@onready var tileMap = $"../TileMapLayer"

@onready var cam := get_viewport().get_camera_2d()
@onready var colorRect = $"../ColorRect"

@export var speed = 300

var moves_buffer = []

var target = position

func _physics_process(delta):
	var tile_coords = tileMap.local_to_map(tileMap.to_local(global_position))
	
	var target_tile = tileMap.local_to_map(tileMap.to_local(target))
	var target_type = tileMap.get_cell_tile_data(target_tile)
	
	if !target_type.get_custom_data("mur"):
		if position.distance_to(target) > 10:
			velocity = position.direction_to(target) * speed
			var collide = move_and_slide()
		else:
			position = target
			velocity = Vector2(0,0)
	else:
		target = position
				
	
func _process(delta):
	
	if velocity == Vector2(0,0):
		if Input.is_action_just_pressed("Right"):
			target.x = position.x + step_length
			#position = target
		elif Input.is_action_just_pressed("Left"):
			target.x = position.x - step_length
			#position = target
		elif Input.is_action_just_pressed("Up"):
			target.y = position.y - step_length
			#position = target
		elif Input.is_action_just_pressed("Down"):
			target.y = position.y + step_length
			#position = target
			
	var mat := colorRect.material as ShaderMaterial
	#mat.set_shader_parameter("player_pos", player.global_position)
	
	var screen_pos = self.global_position
	var viewport_size = get_viewport_rect().size
	var screen_uv = screen_pos / viewport_size
	mat.set_shader_parameter("player_screen_pos", screen_uv)
	#print(screen_uv)
