extends CharacterBody2D
signal collider_cell(rid, normal, invincibility, delta)
signal cannot_dash
signal cannot_shoot_lightning
signal lightning_line_cooldown(line: Line2D)
@export var speed := 25.0
@export var healthcomponent: HealthComponent
@export var inv_frames := 4.0
@export var damage = 20.0
@export var lightdmg = 10.0
@export var dash_multiplier = 2.0
@export var dash_duration = 0.3
@export var dash_cooldown = 1.0
@export var dash_dmg_multiplier = 1.5
@onready var gamescene = preload('res://Scenes/tutorial.tscn')
@onready var lightningcomponentscene = preload('res://Components/lightningcomponent.tscn')
var collision = null
var invincible = false
var dashing = false
var can_dash = true
var dash_direction: Vector2
var can_shoot_lightning = true

func _ready() -> void:
	cannot_dash.connect(_on_dash_cooldown)
	cannot_shoot_lightning.connect(_on_lightning_cooldown)
	lightning_line_cooldown.connect(_on_lightning_line_cooldown)
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed('A') and not dashing:
			project()
	if Input.is_action_just_pressed('E') and not dashing and can_dash:
			dash()
	if Input.is_action_just_pressed('W'):
		#only for testing purposes :p
		velocity = Vector2.ZERO			
	if Input.is_action_just_pressed('S') and can_shoot_lightning:
		can_shoot_lightning = false
		var line = Line2D.new()
		get_parent().add_child(line)
		line.add_point(position)
		shoot_lightning(self, 0, lightningcomponentscene, [], line)
	
	collision = move_and_collide(velocity)
	if collision:
		var collider = collision.get_collider().name
		if collider == 'graywalls':
			#sends rid (to find the id of the tile), collision's normal (to code
			#the spikes), and invincibility status (to prevent spikes from shooting
			#while invincible to prevent a bug of double spikes)
			emit_signal('collider_cell', collision.get_collider_rid(), Vector2i(collision.get_normal()), invincible)
		else:
			velocity = velocity.bounce(collision.get_normal())
			if collider == 'spikes' or collision.get_collider().is_in_group('SpawnedSpikes'):
				healthcomponent.take_environmental_damage(20.0)

func project():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - position).normalized()
	velocity = direction * speed

func dash():
	var init_dmg = damage
	dashing = true
	dash_direction = (get_global_mouse_position() - position).normalized()
	velocity = speed * dash_multiplier * dash_direction
	damage *= dash_dmg_multiplier
	await get_tree().create_timer(dash_duration).timeout
	dashing = false
	can_dash = false
	damage = init_dmg
	velocity /= dash_multiplier
	emit_signal('cannot_dash')

func shoot_lightning(body, count, lightscene, electrocuted: Array, line: Line2D):
	#base case. 3 enemies shot
	if count == 3:
		emit_signal('lightning_line_cooldown', line)
		#shooting all detected enemies
		for enemy in electrocuted:
			enemy.get_node('HealthComponent').take_damage(lightdmg)
		return
	#creating a detection area
	var lightarea = lightscene.instantiate()
	body.add_child(lightarea)
	#awaitng a physics frame since it takes a frame until an area2d detects bodies
	await get_tree().physics_frame
	
	#just in case an enemy dies after the physics frame
	if not lightarea:
		emit_signal("cannot_shoot_lightning")
		emit_signal('lightning_line_cooldown', line)
		for enemy in electrocuted:
			enemy.get_node('HealthComponent').take_damage(lightdmg)
		return
	var bodies = lightarea.get_overlapping_bodies()
	lightarea.queue_free()
	
	#picking the closest body out of the detected bodies
	var distances_mapping = {}
	if bodies:
		for guy in bodies:
			if guy not in electrocuted:
				distances_mapping[guy] = find_distance(body, guy)
	
		#if nobody was found, just shoot the enemies in electrocuted	
		if not distances_mapping.keys():
			if count != 0:
				emit_signal("cannot_shoot_lightning")
				emit_signal('lightning_line_cooldown', line)
				for enemy in electrocuted:
					enemy.get_node('HealthComponent').take_damage(lightdmg)
				return
			can_shoot_lightning = true	
			line.queue_free()	
			return
		else:
			var shortest_distance = distances_mapping.values().min()
			var new_body = distances_mapping.find_key(shortest_distance)	
			
			electrocuted.append(new_body)
			line.add_point(new_body.global_position)
			count += 1
			shoot_lightning(new_body, count, lightscene, electrocuted, line)
	else:
		if count != 0:
			emit_signal("cannot_shoot_lightning")
			for enemy in electrocuted:
				enemy.get_node('HealthComponent').take_damage(lightdmg)
		else:
			can_shoot_lightning = true
		emit_signal('lightning_line_cooldown', line)	
		return	
		
func find_distance(body1: Node2D, body2: Node2D):
	return (body2.global_position - body1.global_position).length()
			
func _on_tilemap_not_cracked() -> void:
	#if you hit a normal gray wall, stop moving. this is to continue in any
	#other case like cracked walls, gems, enemies, spikes, etc.. going to be
	#updated later for enemies.
	velocity = Vector2.ZERO

func _on_hitbox_component_area_entered(area: Area2D) -> void:
	$HitboxComponent.damage(area)

func _on_dash_cooldown():
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	$excmark.visible = true
	$AnimationPlayerMark.play('can_dash')
	
func _on_lightning_cooldown():
	await get_tree().create_timer(3.0).timeout
	can_shoot_lightning = true	
	
func _on_lightning_line_cooldown(line: Line2D):
	if line:
		await get_tree().create_timer(0.5).timeout
		line.queue_free()
	return	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'can_dash':
		$excmark.visible = false
