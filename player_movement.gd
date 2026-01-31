extends CharacterBody2D

@export var step_length = 128
@export var speed = 250

var target = position

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
		
		
func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()
	else:
		position = target
		velocity = Vector2(0,0)
	
#func move():
	#position = target
	move_and_slide()
