extends Collectable

func apply(value,player:Player):
	player.health_system.heal(value)
