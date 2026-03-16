extends ProgressBar
@onready var health_system: HealthSystem = $"../../HealthSystem"

var health:float:
	set(newvalue):
		health = newvalue
		value = lerp(value,float(health_system.health),.1)
