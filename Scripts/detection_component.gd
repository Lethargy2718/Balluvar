extends Node2D
class_name DetectionComponent

@export var raycast: RayCast2D
var max_detection_distance
var player: Node2D
var in_range = false
var search = false
var can_keep_track = false
func _ready() -> void:
	max_detection_distance = $"../Area2D/CollisionShape2D".shape.radius
	
func _process(_delta):
	if search:
		raycast.target_position = (player.position - get_parent().position).normalized() * max_detection_distance
		raycast.force_raycast_update()
		if raycast.is_colliding() and raycast.get_collider().name == "Player":
			raycast.enabled = false
			search = false	
			$"../AnimationPlayerMark".play("can_dash")
			await get_tree().create_timer(1.0).timeout
			in_range = true	
		else:
			in_range = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	raycast.enabled = true
	player = body
	search = true
	
func _on_keep_track_body_entered(_body: Node2D) -> void:
	can_keep_track = true
	
func _on_keep_track_body_exited(_body: Node2D) -> void:
	can_keep_track = false
	search = false
	in_range = false
