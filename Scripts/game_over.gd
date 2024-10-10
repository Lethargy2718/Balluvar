extends CanvasLayer
var result = GameManager.result

func _ready() -> void:
	if result:
		$result.text = 'You Win'
		if GameManager.max_health == GameManager.last_health:
			$goodjob.visible = true
	elif not result:	
		$result.text = 'Game Over'
		
	
func _on_play_again_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")


func _on_quit_button_down() -> void:
	get_tree().quit()
