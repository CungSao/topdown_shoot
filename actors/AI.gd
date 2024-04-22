class_name AI extends Node2D

signal state_changed(new_state)

enum State{
	PATROL,
	ENGAGE,
}

@onready var patrol_timer = $PatrolTimer

var current_state:int = -1 : set = set_state
var actor:CharacterBody2D = null
var player:Player = null
var weapon:Weapon = null

# PATROL STATE
var origin:Vector2
var patrol_location:Vector2
var patrol_location_reached = false
var actor_velocity:Vector2


func _ready():
	set_state(State.PATROL)
	
func _physics_process(_delta):
	match current_state:
		State.PATROL:
			if !patrol_location_reached:
				actor.velocity = actor_velocity
				actor.rotate_toward(patrol_location)
				actor.move_and_slide()
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if player != null and weapon != null:
				actor.rotate_toward(player.global_position)
				var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
				if abs(actor.rotation - angle_to_player) < 0.1:
					weapon.shoot()
			else:
				print("In the engage state but no weapon/player")
		_:
			print("Error: found a state for our enemy that should not exist")


func initialize(_actor, _weapon:Weapon):
	actor = _actor
	weapon = _weapon


func set_state(new_state):
	print('r')
	if new_state == current_state: return
	
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
		
	current_state = new_state
	state_changed.emit(current_state)


func _on_player_detection_zone_body_entered(body):
	if body is Player:
		set_state(State.ENGAGE)
		player = body


func _on_player_detection_zone_body_exited(body):
	if body == player:
		set_state(State.PATROL)
		player = null


func _on_patrol_timer_timeout():
	var patrol_range = 50
	var rand_x = randi_range(-patrol_range, patrol_range)
	var rand_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(rand_x, rand_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_toward(patrol_location)
