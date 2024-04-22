extends CharacterBody2D

@export var speed = 100

@onready var health_stat = $Health
@onready var weapon = $Weapon
@onready var ai:AI = $AI


func _ready():
	ai.initialize(self, weapon)
	

func rotate_toward(location:Vector2):
	rotation = lerp_angle(rotation, global_position.direction_to(location).angle(), 0.1)


func velocity_toward(location:Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
	

func handle_hit():
	health_stat.health -= 20
	print(name + ' hit! ', health_stat.health)
	if health_stat.health <= 0:
		queue_free()
