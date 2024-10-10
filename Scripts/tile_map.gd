extends Node2D

signal not_cracked

@onready var graywalls = $graywalls
@onready var spike_scene_V = preload("res://Scenes/Branched Scenes/spike.tscn")
@onready var spike_scene_H = preload('res://Scenes/Branched Scenes/spike_horizontal.tscn')

var tiles_with_spikes = []

func _ready():
	$"..".graywalls = graywalls

func _on_playerchar_collider_cell(rid: Variant, normal: Variant, invincibility: Variant) -> void:
	#tile's coords, then tiledata to get custom data to check whether the wall is cracked
	#or not.
	var coords = graywalls.get_coords_for_body_rid(rid)
	#check if the tile already has a spike
	if coords in tiles_with_spikes:
		return
	var tile_data = graywalls.get_cell_tile_data(coords)
	if tile_data:
		if tile_data.get_custom_data('crackedwalls'):
			#"breaks" cracked walls (animate later)
			graywalls.erase_cell(coords)

		
			
		if tile_data.get_custom_data('normalwalls') and normal != Vector2i.ZERO and not invincibility:
			#the normal vector being the zero vector only happens when you collide with
			#the corner of a block. an annoying subcase. in that case, there is no need
			#to shoot spikes. the signal is explained in Ball.gd
			shoot_spike(normal, coords)
			tiles_with_spikes.append(coords)
			emit_signal('not_cracked')
			
func shoot_spike(normal: Vector2, coords: Vector2i):
	#spawn point for the to-be-shot spikes. actual coords are the coords of the 
	#collider tile after converting from tilemap native coords.
	var spawn_point = Vector2.ZERO
	var actual_coords = graywalls.map_to_local(coords)
	
	#each possible vector.V means its a vertical spike. H horizontal. true and false
	#based on whether i need to flip them or not.
	var spike_rotation = {
		Vector2(0,1): [spike_scene_V, true],
		Vector2(1,0): [spike_scene_H, false],
		Vector2(-1,0): [spike_scene_H, true],
		Vector2(0,-1): [spike_scene_V, false]
	}
	
	#spike instance based on whether it's H or V
	var spike = spike_rotation[normal][0].instantiate()
	add_child(spike)
	spike.add_to_group('SpawnedSpikes')
	
	#getting its children
	var sprite = spike.get_node('Sprite2D')
	var collisionshapeprim = spike.get_node('CollisionPolygon2Dprim')
	var collisionshapesec = spike.get_node('CollisionPolygon2Dsec')


	#basically if it has to be flipped, i disable its main collisionpolygon2d.
	#yes, each spike has two polygons, one for each 'face' (flipped or not)
	#after that i flip v or h based on the spike. if it's not rotated, disable
	#the secondary(flipped) one instead.
	if spike_rotation[normal][1]:
		if collisionshapeprim:
			collisionshapeprim.disabled = true	
		if spike_rotation[normal][0] == spike_scene_V:
			sprite.flip_v = true
		else:
			sprite.flip_h = true
	else:
		collisionshapesec.disabled = true		
	
	#vectors are annoying. vertical ones are WITH your movement while horizontal
	#ones are AGAINST it. thats why there are two cases. 
	if normal.x == 0:
		spawn_point = actual_coords + normal
	if normal.y == 0:
		spawn_point = actual_coords - normal 	
	
	spike.position = spawn_point
	spike.dir = normal
