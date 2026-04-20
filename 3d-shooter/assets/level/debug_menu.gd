extends Control

@export var player:Player

func  _process(_delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	$FPS.text = "FPS : " + str(fps)
	if player:
		$CanDash.text = "CanDash : " + str(player.can_dash)
