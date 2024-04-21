extends CharacterBody2D

signal fired_bullet(bullet, position, direction)

@export var speed = 100
@export var bullet:PackedScene

@onready var spawn_bullet = $spawn_bullet
@onready var gun_direction = $gun_direction
@onready var attack_cooldown = $AttackCooldown
@onready var animation_player = $AnimationPlayer


func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction.normalized() * speed
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if attack_cooldown.is_stopped():
		var p_bullet = bullet.instantiate()
		
		var target = get_global_mouse_position()
		var direction = spawn_bullet.global_position.direction_to(gun_direction.global_position)
		fired_bullet.emit(p_bullet, spawn_bullet.global_position, direction.normalized())
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
