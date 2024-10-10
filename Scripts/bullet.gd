extends CharacterBody2D
var damage: float
var bullet_speed

func _physics_process(_delta: float) -> void:
	#again, for testing purposes only.
	if Input.is_action_just_pressed("D"):
		queue_free()
		
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
