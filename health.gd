class_name Health extends Node

@export var health = 100 : set = set_health

func set_health(new_health:int):
	health = clamp(new_health, 0, 100)
