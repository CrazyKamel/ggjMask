extends CharacterBody2D

@export var step_length = 128
@export var mask_strengh = 1.05
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
		var collide = move_and_slide()
		if (collide) :
			velocity = Vector2(0,0)
	else:
		position = target
		velocity = Vector2(0,0)
	
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
	
	var screen_pos = self.global_position
	var viewport_size = get_viewport_rect().size
	var screen_uv = screen_pos / viewport_size
	mat.set_shader_parameter("player_screen_pos", screen_uv)
	mat.set_shader_parameter("mask_strengh", mask_strengh)
	if Input.is_action_just_pressed("DEBUG_TRAP"):
		mask_strengh-=0.05
