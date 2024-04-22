extends CharacterBody2D

@onready var health_stat = $Health
@onready var weapon = $Weapon
@onready var ai:AI = $AI


func _ready():
	ai.initialize(self, weapon)
	
	
func handle_hit():
	health_stat.health -= 20
	print(name + ' hit! ', health_stat.health)
	if health_stat.health <= 0:
		queue_free()
