extends Node

@export var max_capacity = 20
var current_bullets = max_capacity
@onready var gun_animations: AnimationPlayer = $"../GunAnimations"
var can_shoot :=true


func reload():
	if Input.is_action_just_pressed("reload") and current_bullets<max_capacity:
		can_shoot = false
		gun_animations.play("reload")


func use_bullet():
	current_bullets -=1
	current_bullets = clamp(current_bullets,0,max_capacity)





func _on_gun_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload":
		current_bullets = max_capacity
		can_shoot = true
