class_name Weapon extends Node2D

@export var bullet:PackedScene

var team:int = -1

@onready var spawn_bullet = $spawn_bullet
@onready var gun_direction = $gun_direction
@onready var attack_cooldown = $AttackCooldown
@onready var animation_player = $AnimationPlayer

func shoot():
	if attack_cooldown.is_stopped() and bullet != null:
		var p_bullet = bullet.instantiate()
		
		var direction = spawn_bullet.global_position.direction_to(gun_direction.global_position)
		Signals.bullet_fired.emit(p_bullet, team, spawn_bullet.global_position, direction.normalized())
		attack_cooldown.start()
		animation_player.play("muzzle_flash")


func initialize(_team:int):
	team = _team
