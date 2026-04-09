extends Control

@export var home_scene:PackedScene

func _on_restart_btn_pressed() -> void:
	get_tree().reload_current_scene()


func _on_home_btn_pressed() -> void:
	if home_scene:
		get_tree().change_scene_to_packed(home_scene)
