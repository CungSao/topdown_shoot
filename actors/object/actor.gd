class_name Actor extends CharacterBody2D

signal died

@export var speed = 100

@onready var coll_shape = $CollisionShape2D
@onready var health_stat = $Health
@onready var weapon:Weapon = $Weapon
@onready var ai:AI = $AI
@onready var team = $Team
var pathfinding:Pathfinding


func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team)
	

func rotate_toward(location:Vector2):
	rotation = lerp_angle(rotation, global_position.direction_to(location).angle(), 0.1)


func velocity_toward(location:Vector2) -> Vector2:
	return global_position.direction_to(location) * speed


func has_reached_position(location:Vector2) -> bool:
	return global_position.distance_to(location) < 5


func get_team() -> int:
	return team.team


func handle_hit():
	health_stat.health -= 20
	print(name + ' hit! ', health_stat.health)
	if health_stat.health <= 0:
		died.emit()
		queue_free()
