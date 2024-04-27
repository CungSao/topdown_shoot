extends Node2D

signal weapon_changed(new_weapon)

@onready var current_weapon:Weapon = $Pistol

var weapons:Array


func initialize(team:int):
	for weapon in weapons:
		weapon.initialize(team)
	
	
func _ready():
	weapons = get_children()
	
	for weapon in weapons:
		weapon.hide()
	
	current_weapon.show()

	
func _physics_process(_delta):
	if Input.is_action_pressed("shoot"):
		current_weapon.shoot()
	elif Input.is_action_just_pressed("reload"):
		reload()
	elif Input.is_action_just_pressed("weapon_1"):
		switch_weapon(weapons[0])
	elif Input.is_action_just_pressed("weapon_2"):
		switch_weapon(weapons[1])


func get_current_weapon() -> Weapon:
	return current_weapon


func reload():
	current_weapon.start_reload()


func switch_weapon(weapon):
	if weapon == current_weapon: return
	
	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	weapon_changed.emit(current_weapon)
