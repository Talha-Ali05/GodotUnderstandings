class_name Collectable extends Area3D

@export var collect_value:=10


func _ready() -> void:
	body_entered.connect(collect)

func collect(body:Node3D):
	if body is Player:
		gCollectable.collected.emit(collect_value)
		queue_free()
