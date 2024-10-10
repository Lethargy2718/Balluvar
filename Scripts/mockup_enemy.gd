extends StaticBody2D

signal cooldown_started

@onready var bulletscene = preload("res://Scenes/Branched Scenes/bullet.tscn")
@onready var bulletsinescene = preload('res://Scenes/Branched Scenes/bullet_sine.tscn')
@export var count = 5
@export var bullet_speed = 5.0
@export var cooldown_period = 3.5
@export var bullet_damage = 20.0
@export var bullet_buffer = 0.5
@export var freq = 0.1
@export var amp = 50.0
@export_enum('regular', 'sine') var bullet_type
var cooldown = false


func _ready() -> void:
	cooldown_started.connect(on_cooldown_started)
	
func _process(_delta: float) -> void:
	if $DetectionComponent.in_range and not cooldown and $DetectionComponent.can_keep_track:
		match bullet_type:
			0:
				shoot_bullets(count)
			1:
				shoot_sine(count)	
		cooldown = true
		
func shoot_bullets(bullet_count):
	for i in range(bullet_count):
		var bullet = spawn_bullet()
		if $DetectionComponent.player and position:
			var direction = ($DetectionComponent.player.position - position).normalized()
			bullet.velocity = direction * bullet_speed
			await get_tree().create_timer(bullet_buffer).timeout	
	emit_signal("cooldown_started")	

func shoot_sine(bullet_count):
	if $DetectionComponent.player:
		var direction = ($DetectionComponent.player.position - position).normalized()
		var theta = arctan(direction)
		for i in range(bullet_count):
			var bullet = spawn_bullet_sine()
			bullet.theta = theta
			bullet.bullet_speed = bullet_speed
			await get_tree().create_timer(bullet_buffer).timeout
		emit_signal("cooldown_started")
		
func on_cooldown_started():
	await get_tree().create_timer(cooldown_period).timeout
	cooldown = false
		
func spawn_bullet():
	var bullet = bulletscene.instantiate()
	get_parent().add_child(bullet)
	bullet.damage = bullet_damage
	bullet.position = position
	return bullet
	
func spawn_bullet_sine():
	var bullet = bulletsinescene.instantiate()
	get_parent().add_child(bullet)
	bullet.damage = bullet_damage
	bullet.position = position
	bullet.t = position.x
	bullet.init_pos = position
	bullet.amp = amp
	bullet.freq = freq
	return bullet


#custom arctan i made because godot is stupid
#i hate how the positive y axis is DOWN. computer
#graphics are annoying
func arctan(direction: Vector2):
	var theta = atan(direction.y/direction.x)
	if direction.x < 0:
		if direction.y < 0:
			theta += -PI
		else:	
			theta = PI - theta * -1
	return theta	

func _on_hitbox_component_area_entered(area: Area2D) -> void:
	$HitboxComponent.damage(area)
