extends CharacterBody2D

@export var step_length = 128
@export var mask_strengh = 0
@export var minX = 672
@export var maxX = 1248
@export var minY = 224
@export var maxY = 800

@onready var tileMap = $"../TileMapLayer"

@onready var cam := get_viewport().get_camera_2d()
@onready var colorRect = $"../ColorRect"

@export var speed = 250

var target = position

func _physics_process(delta):
	var tile_coords = tileMap.local_to_map(tileMap.to_local(global_position))
	print(tile_coords)
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()
	else:
		position = target
		velocity = Vector2(0,0)
	
func _process(delta):
	if velocity == Vector2(0,0):
		if Input.is_action_just_pressed("Right"):
			target.x = clamp(position.x + step_length, minX, maxX)
			#position = target
		elif Input.is_action_just_pressed("Left"):
			target.x = clamp(position.x - step_length, minX, maxX)
			#position = target
		elif Input.is_action_just_pressed("Up"):
			target.y = clamp(position.y - step_length, minY, maxY)
			#position = target
		elif Input.is_action_just_pressed("Down"):
			target.y = clamp(position.y + step_length, minY, maxY)
			#position = target
			
	var mat := colorRect.material as ShaderMaterial
	#mat.set_shader_parameter("player_pos", player.global_position)
	
	var screen_pos = self.global_position
	var viewport_size = get_viewport_rect().size
	var screen_uv = screen_pos / viewport_size
	mat.set_shader_parameter("player_screen_pos", screen_uv)
	#print(screen_uv)
