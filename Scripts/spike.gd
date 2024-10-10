extends StaticBody2D

@export var speed = 10
@export var spike_buffer = 1.5
@onready var dir = Vector2.ZERO
@onready var shoot_now = false
var moved_distance = 0
var to_be_moved = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(spike_buffer).timeout
	shoot_now = true
	
func _process(_delta: float) -> void:
	if shoot_now:
		to_be_moved = dir
		position += to_be_moved
		moved_distance += to_be_moved.length()
		if dir.y == 0 and moved_distance >= 25:
			moved_distance = 0
			shoot_now = false
			await get_tree().create_timer(spike_buffer).timeout	
		if dir.y != 0 and moved_distance >= 23:
			moved_distance = 0
			shoot_now = false
			await get_tree().create_timer(spike_buffer).timeout	
			
			
				
			
