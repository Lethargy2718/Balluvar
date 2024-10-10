#IGNORE THIS i use this for testing random math
extends Node2D

@export var count = 400
@export var radius = 20
@export_range(0, 2*PI) var alpha: float = 0.0
@export var rotation_speed = 1.0
@onready var bulletscene = preload("res://Scenes/Branched Scenes/bullet.tscn")
@onready var timer = $Timer
@onready var player = $Player
@onready var timer_slider = $CanvasLayer/tiimer
@onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	print('MATHS NODE IS WORKING')
	var numb = rng.randi_range(1,3)
	for i in range(numb):
		line_draw()
func _process(_delta: float) -> void:
	timer.wait_time = timer_slider.value

func line_draw():
	var screenSize = get_viewport().get_visible_rect().size
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y)	
	var line = Line2D.new()
	line.add_point(Vector2(20, -10))
	line.add_point(Vector2(rndX, rndY))
	line.width = 10
	line.default_color = Color(1,0,1)
	add_child(line)
	var count = rng.randi_range(10,20)
	var padding = 10
	for i in range(count):
		var bullet = bulletscene.instantiate()
		add_child(bullet)
		bullet.position = Vector2(rndX, rndY) + padding * i * Vector2(1,0)
		
		
#func _on_timer_timeout() -> void:
	#var bullet = bulletscene.instantiate()
	#add_child(bullet)
