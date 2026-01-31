extends CharacterBody2D

@export var step_length = 400
@export var mask_strengh = 0
@onready var cam := get_viewport().get_camera_2d()
@onready var colorRect = $"../ColorRect"

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * step_length
	
	

func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	var mat := colorRect.material as ShaderMaterial
	#mat.set_shader_parameter("player_pos", player.global_position)
	
	var screen_pos = self.global_position
	var viewport_size = get_viewport_rect().size
	var screen_uv = screen_pos / viewport_size
	mat.set_shader_parameter("player_screen_pos", screen_uv)
	print(screen_uv)
