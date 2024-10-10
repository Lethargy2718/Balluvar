extends Node2D
class_name HealthComponent
signal lost_health(current_hp)
signal entity_died(entity_name)
@export var max_health: float = 40.0
@export var inv_frames = 4
@export var animationplayer: AnimationPlayer
@onready var parent = get_parent()
@onready var current_health = max_health
var currently_invincible = false

func take_damage(damage):
	if parent.name == 'Player': if parent.dashing == true: return
	if not currently_invincible:
		current_health -= damage
		invincible()
		if current_health <= 0:
			current_health = 0
			if parent.name == 'Player':
				GameManager.game_over(false)
				return
			else:
				die()
				GameManager.deaths += 1
				if GameManager.deaths >= 3:
					var player_healthcomp = get_parent().get_parent().get_node('Player/HealthComponent')
					GameManager.max_health = player_healthcomp.max_health
					GameManager.last_health = player_healthcomp.current_health
					GameManager.game_over(true)
					#do i even need to 'return' here?
					return
		else:
			emit_signal('lost_health', current_health)
				
		if parent.name == 'Player':
			$"../CanvasLayer/HealthLabel".text = str(current_health) + '/' + str(max_health)
		
func take_environmental_damage(dmg: float):
	if not currently_invincible:
		current_health -= dmg
		invincible()
		emit_signal('lost_health', current_health)
		$"../CanvasLayer/HealthLabel".text = str(current_health) + '/' + str(max_health)
		if current_health <= 0:
			current_health = 0
			GameManager.game_over(false)

		
func die():
	emit_signal('entity_died', get_parent().name)
	parent.queue_free()
			
func invincible():
	animationplayer.play('Invincible')
	if parent.name == 'Player':
		parent.invincible = true
	currently_invincible = true	
	await get_tree().create_timer(inv_frames).timeout
	if parent.name == 'Player':
		parent.invincible = false
	currently_invincible = false	
