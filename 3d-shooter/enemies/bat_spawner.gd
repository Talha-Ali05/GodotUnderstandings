extends StaticBody3D
const ENEMY = preload("uid://dsqrj3upoggry")
var player:Node3D
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	$Timer.wait_time = randi_range(1,3)
func spawn_bat():
	var bat = ENEMY.instantiate()
	$Marker3D.add_child(bat)
	if player:
		bat.setup($Marker3D,player)


func _on_timer_timeout() -> void:
	spawn_bat()
	$Timer.wait_time = randi_range(10,15)
