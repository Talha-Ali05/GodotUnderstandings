class_name HealthSystem extends Node
@export var max_health :=100
var health := max_health

signal die

func take_damage(damage_points):
	health -= damage_points
	health = clamp(health, 0, max_health)
	if health <= 0:
		die.emit()

func heal (health_points):
	health += health_points
	health = clamp(health, 0, max_health)
	
