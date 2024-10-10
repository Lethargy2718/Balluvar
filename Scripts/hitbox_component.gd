extends Area2D
class_name HitboxComponent
@export var healthcomponent: HealthComponent

func damage(area):
	if area is HitboxComponent:
		healthcomponent.take_damage(area.get_parent().damage)
