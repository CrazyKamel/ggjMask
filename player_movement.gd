extends CharacterBody2D

@export var step_length = 128
@export var speed = 300

@export var startX = 928
@export var startY = 800

@export var mask_strengh = 10

@onready var tileMap = $"../TileMapLayer"

@onready var crounch = $"../Crounch"

@onready var cam := get_viewport().get_camera_2d()
@onready var colorRect = $"../ColorRect"

var moves_buffer = []
var moving = false
 
var target = position

var crounch_state = false
func _ready():
	position = Vector2(startX, startY)
	crounch.start(4)

func _physics_process(delta):
	var tile_coords = tileMap.local_to_map(tileMap.to_local(global_position))
	
	var target_tile = tileMap.local_to_map(tileMap.to_local(target))
	var target_type = tileMap.get_cell_tile_data(target_tile)
	
	if !target_type.get_custom_data("mur"):
		moving = true
		if position.distance_to(target) > 10:
			velocity = position.direction_to(target) * speed
			var collide = move_and_slide()
		else:
			moving = false
			position = target
			velocity = Vector2(0,0)
		if target_type.get_custom_data("pikpikpik"):
			print("ça pikpikpik 1 peu kan même")
			# relancer la partie à l'état initial
		elif target_type.get_custom_data("crounch"):
			if crounch_state:
				print("retard sur la ligne A à cause d'un incident voyageur")
				# relancer la partie à l'état initial
		elif target_type.get_custom_data("teleport"):
			print("wtf jsuis un photon")
		elif target_type.get_custom_data("exit"):
			print("tié un kouign amann")
			#passer au niveau suivant
		
	else:
		target = position
		moving = false

func incidentVoyageur():
	crounch_state = !crounch_state
	if !crounch_state :
		crounch.start(4)
	else :
		crounch.start(2)
		
func move(dir):
	match dir:
		"R":target.x = position.x + step_length
		"L":target.x = position.x - step_length
		"U":target.y = position.y - step_length
		"D":target.y = position.y + step_length
	
func _process(delta):
	
	if moves_buffer.size() > 0 and !moving:
		move(moves_buffer.pop_front())
	else:
		if Input.is_action_just_pressed("Right"):
			if !moving: move("R")
			else: moves_buffer.append("R")
		elif Input.is_action_just_pressed("Left"):
			if !moving: move("L")
			else: moves_buffer.append("L")
		elif Input.is_action_just_pressed("Up"):
			if !moving: move("U")
			else: moves_buffer.append("U")
		elif Input.is_action_just_pressed("Down"):
			if !moving: move("D")
			else: moves_buffer.append("D")

	var mat := colorRect.material as ShaderMaterial
	
	var screen_pos = self.global_position
	var viewport_size = get_viewport_rect().size
	var screen_uv = screen_pos / viewport_size
	mat.set_shader_parameter("player_screen_pos", screen_uv)
	mat.set_shader_parameter("mask_strengh", mask_strengh)
	if Input.is_action_just_pressed("DEBUG_TRAP"):
		if mask_strengh > 1:
			$"../ColorRect".set_visible(true)
			mask_strengh = 1
		mask_strengh=mask_strengh*0.5
		if mask_strengh < 0.05:
			mask_strengh = 0 
	if Input.is_action_just_pressed("ui_cancel"):
		Global.goto_scene("res://menu.tscn")


func _on_crounch_timeout() -> void:
	print(crounch_state)
	incidentVoyageur()
	
