class_name Weapon extends Node2D

signal ammo_changed(new_ammo_count)
signal weapon_out_of_ammo

@export var bullet:PackedScene

var team:int = -1

var max_ammo:int = 10
var current_ammo:int = max_ammo : set = set_current_ammo

@onready var spawn_bullet = $spawn_bullet
@onready var gun_direction = $gun_direction
@onready var attack_cooldown = $AttackCooldown
@onready var animation_player = $AnimationPlayer


func _ready():
	$MuzzleFlash.hide()


func initialize(_team:int):
	team = _team

	
func start_reload():
	animation_player.play("reload")


func stop_reload():
	current_ammo = max_ammo


func set_current_ammo(new_ammo:int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			weapon_out_of_ammo.emit()
	ammo_changed.emit(current_ammo)


func shoot():
	if current_ammo == 0 or animation_player.is_playing(): return
	if attack_cooldown.is_stopped() and bullet != null:
		var p_bullet = bullet.instantiate()
		
		var direction = spawn_bullet.global_position.direction_to(gun_direction.global_position)
		Signals.bullet_fired.emit(p_bullet, team, spawn_bullet.global_position, direction.normalized())
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
		set_current_ammo(current_ammo - 1)

