extends ColorRect


@onready var player = $"../CharacterBody2D"
@onready var cam := get_viewport().get_camera_2d()

func _process(delta):
	var mat := self.material as ShaderMaterial
	#mat.set_shader_parameter("player_pos", player.global_position)
	
	var screen_pos = cam.unproject_position(player.global_position)
	var viewport_size = get_viewport_rect().size
	var screen_uv = screen_pos / viewport_size
	mat.set_shader_parameter("player_screen_pos", screen_uv)
	print(screen_uv)
