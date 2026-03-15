class_name HurtBox extends Area3D


signal hurt(damage,hitbox:Area3D)
var invulnerable := false

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is HitBox and not invulnerable:
		hurt.emit(area.damage,area)
