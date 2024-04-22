class_name Player extends CharacterBody2D

signal player_fired_bullet(bullet, position, direction)

@export var speed = 100

@onready var health_stat = $Health
@onready var weapon = $Weapon


func _ready():
	weapon.connect("weapon_fired", shoot)



func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction.normalized() * speed
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		weapon.shoot()


func shoot(p_bullet, location:Vector2, direction:Vector2):
	player_fired_bullet.emit(p_bullet, location, direction)


func handle_hit():
	health_stat.health -= 20
	print(name + ' hit! ', health_stat.health)
