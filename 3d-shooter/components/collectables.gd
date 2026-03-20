class_name Collectable extends Area3D

@export var collect_value:=10

signal collected

func _ready() -> void:
	body_entered.connect(collect)

func spawn(parent:Node3D,spawn_point:Marker3D):
	parent.add_child(self)
	self.global_position = spawn_point.global_position
	scale = Vector3.ZERO
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector3.ONE,.5)
func collect(body:Node3D):
	if body is Player:
		apply(collect_value,body)
		collected.emit()
		queue_free()

func apply(value,player:Player):
	pass
