extends Control

@export var player:CharacterBody3D

func  _process(_delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	$FPS.text = "FPS :" + str(fps)
