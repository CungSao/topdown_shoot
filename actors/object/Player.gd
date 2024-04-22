class_name Player extends CharacterBody2D

@export var default_speed = 100
var run_speed = default_speed * 2
var speed = default_speed

@onready var team = $Team
@onready var health_stat = $Health
@onready var weapon:Weapon = $Weapon


func _ready():
	weapon.initialize(team.team)
	

func _physics_process(_delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	speed = run_speed if Input.is_action_pressed("run") else default_speed
	
	velocity = input_direction.normalized() * speed
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	elif Input.is_action_just_released("reload"):
		reload()


func reload():
	weapon.start_reload()


func get_team() -> int:
	return team.team


func handle_hit():
	health_stat.health -= 20
	print(name + ' hit! ', health_stat.health)
