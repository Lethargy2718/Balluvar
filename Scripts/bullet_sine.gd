extends Area2D
var damage: float
var theta: float
var bullet_speed: float
var t = 0.0
var init_pos: Vector2
var amp: float
var freq: float

func _process(delta: float) -> void:
	#you guessed it; testing purposes only.
	if Input.is_action_just_pressed("D"):
		queue_free()

	t += delta * bullet_speed
	position = sine_wave(theta)

func sine_wave(alpha):
	#the sine wave starts at y = 0 by default, so i translate it
	#to the enemy's position by adding init_pos.y
	var y = (amp * sin(freq * t)) + init_pos.y
	return rotate_point(Vector2(t,y), alpha)
	
#when i rotate a point, it rotates with respect to the x and y axes, which is not
#what i need. what i need is two custom axes where the enemy is the origin. so
#i simply translate the point, rotate it using the rotation matrix equations,
#then translate it back. that fixes the problem. pretty difficult to explain without
#drawing..
func rotate_point(point: Vector2, alpha):
	point -= init_pos
	var i = point.x * cos(alpha) - point.y * sin(alpha)
	var j = point.x * sin(alpha) + point.y * cos(alpha)
	return Vector2(i ,j) + init_pos

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
