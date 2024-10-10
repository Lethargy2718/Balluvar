extends Node2D
@onready var graywalls: TileMapLayer
var coords: Vector2i

func _ready() -> void:
	get_node('enemy1/HealthComponent').entity_died.connect(_on_entity_died)
	
func _process(delta: float) -> void:
	var fps = Performance. get_monitor(Performance. TIME_FPS)
	$Player/CanvasLayer/fps.text = str(fps)
func _on_entity_died(entity_name):
	if entity_name == 'enemy1':
		for i in range(-10,10):
			coords = Vector2i(i,-27)
			graywalls.set_cell(coords, 9, Vector2i(12,3), 0)
		$room2/label2.text = 'Hit cracked walls to break them'

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		$Area2D.queue_free()
		for i in range(-10,10):
			coords = Vector2i(i,-27)
			graywalls.set_cell(coords, 9, Vector2i(12,0), 0)
