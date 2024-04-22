class_name AI extends Node

signal state_changed(new_state)

enum State{
	PATROL,
	ENGAGE,
}

var current_state = State.PATROL : set = set_state
var actor = null
var player:Player = null
var weapon:Weapon = null


func _process(_delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and weapon != null:
				actor.rotation = actor.global_position.direction_to(player.global_position).angle()
				weapon.shoot()
			else:
				print("In the engage state but no weapon/player")
		_:
			print("Error: found a state for our enemy that should not exist")


func initialize(_actor, _weapon:Weapon):
	actor = _actor
	weapon = _weapon


func set_state(new_state):
	if new_state != current_state:
		current_state = new_state
		state_changed.emit(current_state)


func _on_player_detection_zone_body_entered(body):
	if body is Player:
		set_state(State.ENGAGE)
		player = body
