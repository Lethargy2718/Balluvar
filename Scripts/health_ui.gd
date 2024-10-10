extends Label

@onready var max_health = $"../../HealthComponent".max_health
@onready var current_health = $"../../HealthComponent".current_health
	

func _ready() -> void:
	text = str(current_health) + '/' + str(max_health)

func _on_health_component_lost_health(current_hp: Variant) -> void:
	text = str(current_hp) + '/' + str(max_health)
