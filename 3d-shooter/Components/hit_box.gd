class_name HitBox extends Area3D


@export var damage := 10

signal hit

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	


func _on_area_entered (area:Area3D) -> void:
	if area is HurtBox:
		hit.emit()
