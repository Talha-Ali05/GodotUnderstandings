extends Node3D

var current_collectable
func _on_spawn_time_timeout() -> void:
	current_collectable = Collectables.collectableslist.pick_random()
	var collectable = Collectables.collectables[current_collectable].instantiate()
	collectable.spawn(self,$Marker3D)
	collectable.collected.connect(start_spawner)

func start_spawner():
	$SpawnTime.start()
