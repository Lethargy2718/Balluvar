extends Node

var deaths = 0
var result: bool
var last_health = 0.0
var max_health = 0.0
func game_over(wl: bool):
	result = wl
	deaths = 0
	get_tree().change_scene_to_file.bind('res://Scenes/Game_over.tscn').call_deferred()
