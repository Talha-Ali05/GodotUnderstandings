extends Timer
@onready var collision_shape_3d: CollisionShape3D = $"../CollisionShape3D"




func _on_timeout() -> void:
	collision_shape_3d.disabled = not collision_shape_3d.disabled 
	$"../Label3D".text = "OFF" if collision_shape_3d.disabled else "ON"
