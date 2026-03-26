class_name BulletSystem extends Node

@export var max_capacity:int
var current_bullets:
	set(value):
		current_bullets = value
var can_shoot :=true


func _ready() -> void:
	current_bullets = max_capacity

func reload():
	if Input.is_action_just_pressed("reload") and current_bullets<max_capacity:
		current_bullets = max_capacity


func use_bullet():
	current_bullets -=1
	current_bullets = clamp(current_bullets,0,max_capacity)
